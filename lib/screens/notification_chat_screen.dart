import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message.dart';
import 'appointments_screen.dart';
import 'prescriptions_screen.dart';

class NotificationChatScreen extends StatefulWidget {
  final Message message;

  const NotificationChatScreen({super.key, required this.message});

  @override
  State<NotificationChatScreen> createState() => _NotificationChatScreenState();
}

class _NotificationChatScreenState extends State<NotificationChatScreen> {
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
              _getNotificationSubtitle(),
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
          if (widget.message.type == MessageType.appointment)
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _viewAppointment(),
            ),
          if (widget.message.type == MessageType.prescription)
            IconButton(
              icon: const Icon(Icons.medication),
              onPressed: () => _viewPrescription(),
            ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'mark_unread',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_unread, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Mark as Unread'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Notification'),
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
            child: Container(
              decoration: BoxDecoration(color: Colors.grey[50]),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildNotificationBubble(),
                  const SizedBox(height: 20),
                  _buildNotificationInfo(),
                ],
              ),
            ),
          ),
          _buildDisabledMessageInput(),
        ],
      ),
    );
  }

  Widget _buildNotificationBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: _getNotificationColor(),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _getNotificationBorderColor(), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getNotificationIcon(),
                  size: 20,
                  color: _getNotificationIconColor(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getNotificationTitle(),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _getNotificationIconColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.message.content,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat(
                    'MMM dd, yyyy at hh:mm a',
                  ).format(widget.message.timestamp),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                if (widget.message.type == MessageType.appointment ||
                    widget.message.type == MessageType.prescription)
                  _buildActionButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    String buttonText;
    VoidCallback onPressed;

    if (widget.message.type == MessageType.appointment) {
      buttonText = 'View Appointment';
      onPressed = _viewAppointment;
    } else {
      buttonText = 'View Prescription';
      onPressed = _viewPrescription;
    }

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue[50],
        foregroundColor: Colors.blue[700],
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildDisabledMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.grey[500], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                'This is a system notification - replies are not available',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.grey[500]),
              onPressed: null, // Disabled
            ),
          ),
        ],
      ),
    );
  }

  String _getNotificationSubtitle() {
    switch (widget.message.type) {
      case MessageType.appointment:
        return 'Appointment Notification';
      case MessageType.prescription:
        return 'Prescription Notification';
      case MessageType.system:
        return 'System Notification';
      default:
        return 'Notification';
    }
  }

  String _getNotificationTitle() {
    switch (widget.message.type) {
      case MessageType.appointment:
        return 'Appointment Update';
      case MessageType.prescription:
        return 'Prescription Ready';
      case MessageType.system:
        return 'System Alert';
      default:
        return 'Notification';
    }
  }

  IconData _getNotificationIcon() {
    switch (widget.message.type) {
      case MessageType.appointment:
        return Icons.calendar_today;
      case MessageType.prescription:
        return Icons.medication;
      case MessageType.system:
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor() {
    switch (widget.message.type) {
      case MessageType.appointment:
        return Colors.blue[50]!;
      case MessageType.prescription:
        return Colors.orange[50]!;
      case MessageType.system:
        return Colors.green[50]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Color _getNotificationBorderColor() {
    switch (widget.message.type) {
      case MessageType.appointment:
        return Colors.blue[200]!;
      case MessageType.prescription:
        return Colors.orange[200]!;
      case MessageType.system:
        return Colors.green[200]!;
      default:
        return Colors.grey[300]!;
    }
  }

  Color _getNotificationIconColor() {
    switch (widget.message.type) {
      case MessageType.appointment:
        return Colors.blue[700]!;
      case MessageType.prescription:
        return Colors.orange[700]!;
      case MessageType.system:
        return Colors.green[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  void _viewAppointment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AppointmentsScreen()),
    );
  }

  void _viewPrescription() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PrescriptionsScreen()),
    );
  }

  Widget _buildNotificationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'About this notification',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This is an automated system notification. You cannot reply to this message, but you can take actions using the buttons above if available.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'mark_unread':
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification marked as unread'),
            backgroundColor: Colors.orange,
          ),
        );
        break;
      case 'delete':
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification deleted'),
            backgroundColor: Colors.red,
          ),
        );
        break;
    }
  }
}
