import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static const String _storageKey = 'klinate_chat_messages';
  static final Map<String, List<ChatMessage>> _chatRooms = {};
  static final Map<String, StreamController<List<ChatMessage>>>
  _streamControllers = {};

  // Get real-time stream for chat messages
  static Stream<List<ChatMessage>> getChatStream(String chatRoomId) {
    if (!_streamControllers.containsKey(chatRoomId)) {
      _streamControllers[chatRoomId] =
          StreamController<List<ChatMessage>>.broadcast();
    }
    return _streamControllers[chatRoomId]!.stream;
  }

  // Notify listeners of message updates
  static void _notifyListeners(String chatRoomId) {
    if (_streamControllers.containsKey(chatRoomId)) {
      _streamControllers[chatRoomId]!.add(_chatRooms[chatRoomId] ?? []);
    }
  }

  // Load chat messages for a specific chat room
  static Future<List<ChatMessage>> loadChatMessages(String chatRoomId) async {
    if (_chatRooms.containsKey(chatRoomId)) {
      return _chatRooms[chatRoomId]!;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final chatData = prefs.getString('${_storageKey}_$chatRoomId');

      if (chatData != null) {
        final List<dynamic> messagesList = json.decode(chatData);
        final messages = messagesList
            .map((json) => ChatMessage.fromJson(json))
            .toList();
        _chatRooms[chatRoomId] = messages;
        return messages;
      }
    } catch (e) {
      // Handle error silently
    }

    // Return empty list if no messages found
    _chatRooms[chatRoomId] = [];
    return _chatRooms[chatRoomId]!;
  }

  // Save chat messages for a specific chat room
  static Future<void> _saveChatMessages(String chatRoomId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messages = _chatRooms[chatRoomId] ?? [];
      final messagesJson = json.encode(
        messages.map((message) => message.toJson()).toList(),
      );
      await prefs.setString('${_storageKey}_$chatRoomId', messagesJson);
    } catch (e) {
      // Handle save error silently
    }
  }

  // Add a message to a chat room
  static Future<void> addMessage(String chatRoomId, ChatMessage message) async {
    if (!_chatRooms.containsKey(chatRoomId)) {
      _chatRooms[chatRoomId] = [];
    }

    _chatRooms[chatRoomId]!.add(message);
    await _saveChatMessages(chatRoomId);
    _notifyListeners(chatRoomId);

    // Simulate provider response for demo purposes
    if (message.isFromUser) {
      _simulateProviderResponse(chatRoomId, message.text);
    }
  }

  // Simulate provider response (replace with real backend integration)
  static void _simulateProviderResponse(String chatRoomId, String userMessage) {
    Timer(const Duration(seconds: 2), () async {
      final response = _generateProviderResponse(userMessage);
      final responseMessage = ChatMessage(
        text: response,
        isFromUser: false,
        timestamp: DateTime.now(),
        senderName: _getProviderName(chatRoomId),
        messageType: ChatMessageType.text,
      );

      if (!_chatRooms.containsKey(chatRoomId)) {
        _chatRooms[chatRoomId] = [];
      }

      _chatRooms[chatRoomId]!.add(responseMessage);
      await _saveChatMessages(chatRoomId);
      _notifyListeners(chatRoomId);
    });
  }

  static String _getProviderName(String chatRoomId) {
    // Extract provider name from chat room ID or use default
    if (chatRoomId.contains('dr_')) {
      return 'Dr. Smith';
    }
    return 'Healthcare Provider';
  }

  static String _generateProviderResponse(String userMessage) {
    final message = userMessage.toLowerCase();

    if (message.contains('appointment') || message.contains('book')) {
      return 'I can help you book an appointment. What type of consultation would you prefer - video call, voice call, or chat?';
    } else if (message.contains('prescription') ||
        message.contains('medicine')) {
      return 'Your prescription is ready for pickup. You can collect it from the pharmacy mentioned in your prescription details.';
    } else if (message.contains('pain') || message.contains('symptom')) {
      return 'I understand your concern. Can you describe the symptoms in more detail? When did they start?';
    } else if (message.contains('thank')) {
      return 'You\'re welcome! Is there anything else I can help you with?';
    } else if (message.contains('call') || message.contains('video')) {
      return 'I can arrange a video or voice call consultation. Would you like me to schedule one for you?';
    } else {
      return 'Thank you for your message. I\'ll review your case and get back to you with more information shortly.';
    }
  }

  // Get messages for a chat room (without loading from storage)
  static List<ChatMessage> getChatMessages(String chatRoomId) {
    return _chatRooms[chatRoomId] ?? [];
  }

  // Clear messages for a chat room
  static Future<void> clearChatMessages(String chatRoomId) async {
    _chatRooms[chatRoomId] = [];
    await _saveChatMessages(chatRoomId);
  }

  // Initialize a chat room with an initial message if it doesn't exist
  static Future<void> initializeChatRoom(
    String chatRoomId,
    String initialMessage,
    String senderName,
    DateTime timestamp,
  ) async {
    final messages = await loadChatMessages(chatRoomId);

    // If no messages exist, add the initial message
    if (messages.isEmpty) {
      await addMessage(
        chatRoomId,
        ChatMessage(
          text: initialMessage,
          isFromUser: false,
          timestamp: timestamp,
          senderName: senderName,
        ),
      );
    }
  }
}

enum ChatMessageType { text, image, file, call, video }

class ChatMessage {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final String senderName;
  final ChatMessageType messageType;
  final String? attachmentUrl;

  ChatMessage({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    required this.senderName,
    this.messageType = ChatMessageType.text,
    this.attachmentUrl,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'senderName': senderName,
      'messageType': messageType.toString(),
      'attachmentUrl': attachmentUrl,
    };
  }

  // Create from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isFromUser: json['isFromUser'],
      timestamp: DateTime.parse(json['timestamp']),
      senderName: json['senderName'],
      messageType: ChatMessageType.values.firstWhere(
        (e) => e.toString() == (json['messageType'] ?? 'ChatMessageType.text'),
        orElse: () => ChatMessageType.text,
      ),
      attachmentUrl: json['attachmentUrl'],
    );
  }
}
