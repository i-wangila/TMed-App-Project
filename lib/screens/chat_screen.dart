import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../models/message.dart';
import '../services/chat_service.dart';
import '../services/call_service.dart';
import 'call_screen.dart';

class ChatScreen extends StatefulWidget {
  final Message message;

  const ChatScreen({super.key, required this.message});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _chatMessages = [];
  late String _chatRoomId;
  StreamSubscription<List<ChatMessage>>? _chatSubscription;

  @override
  void initState() {
    super.initState();
    // Generate chat room ID based on sender ID
    _chatRoomId = 'chat_${widget.message.senderId}';
    _loadChatMessages();
    _setupChatStream();
  }

  void _setupChatStream() {
    _chatSubscription = ChatService.getChatStream(_chatRoomId).listen((
      messages,
    ) {
      if (mounted) {
        setState(() {
          _chatMessages = messages;
        });
      }
    });
  }

  Future<void> _loadChatMessages() async {
    // Initialize chat room with the original message if it doesn't exist
    await ChatService.initializeChatRoom(
      _chatRoomId,
      widget.message.content,
      widget.message.senderName,
      widget.message.timestamp,
    );

    // Load all messages for this chat room
    final messages = await ChatService.loadChatMessages(_chatRoomId);

    if (mounted) {
      setState(() {
        _chatMessages = messages;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.message.senderName,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Online',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => _startVideoCall(),
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _startVoiceCall(),
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_chat',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear Chat History'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                return _buildChatBubble(_chatMessages[index]);
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    return Align(
      alignment: message.isFromUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isFromUser ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: message.isFromUser
              ? Border.all(color: Colors.black, width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(message.timestamp),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    // Check if this message allows replies
    final canReply = widget.message.canReply;

    if (!canReply) {
      // Show read-only indicator for system notifications
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Text(
              'This is a system notification - no replies allowed',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () => _showAttachmentOptions(),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(color: Colors.black, width: 1),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.black),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      final messageText = _messageController.text.trim();
      _messageController.clear();

      // Add user message
      final userMessage = ChatMessage(
        text: messageText,
        isFromUser: true,
        timestamp: DateTime.now(),
        senderName: 'You',
        messageType: ChatMessageType.text,
      );

      await ChatService.addMessage(_chatRoomId, userMessage);
    }
  }

  void _startVideoCall() async {
    try {
      final callSession = await CallService.startCall(
        providerId: widget.message.senderId,
        providerName: widget.message.senderName,
        callType: CallType.video,
        patientId: 'current_user',
        patientName: 'You',
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(callSession: callSession),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start video call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _startVoiceCall() async {
    try {
      final callSession = await CallService.startCall(
        providerId: widget.message.senderId,
        providerName: widget.message.senderName,
        callType: CallType.voice,
        patientId: 'current_user',
        patientName: 'You',
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(callSession: callSession),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start voice call: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Photo'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Photo attachment feature coming soon'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('Document'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Document attachment feature coming soon'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Location'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Location sharing feature coming soon'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'clear_chat':
        _showClearChatDialog();
        break;
    }
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text(
          'Are you sure you want to clear all messages in this chat? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              navigator.pop();

              // Clear chat messages
              await ChatService.clearChatMessages(_chatRoomId);

              // Reload messages (will be empty)
              final messages = await ChatService.loadChatMessages(_chatRoomId);
              if (mounted) {
                setState(() {
                  _chatMessages = messages;
                });

                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Chat history cleared'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatSubscription?.cancel();
    super.dispose();
  }
}
