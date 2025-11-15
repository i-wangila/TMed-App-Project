import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';

class MessageService {
  static const String _storageKey = 'klinate_messages';
  static final List<Message> _messages = [];
  static final List<VoidCallback> _listeners = [];

  // Initialize with default messages if no stored messages exist
  static Future<void> _initializeDefaultMessages() async {
    if (_messages.isEmpty) {
      _messages.addAll([
        // Healthcare provider messages (can reply)
        Message(
          id: '1',
          senderId: 'dr_sarah_mwangi',
          senderName: 'Dr. Sarah Mwangi',
          content:
              'Hello! How are you feeling after your last consultation? Any concerns?',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          type: MessageType.text,
          category: MessageCategory.healthcareProvider,
          isRead: false,
        ),
        Message(
          id: '2',
          senderId: 'dr_james_kiprotich',
          senderName: 'Dr. James Kiprotich',
          content:
              'Your test results are ready. Please schedule a follow-up appointment to discuss them.',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          type: MessageType.text,
          category: MessageCategory.healthcareProvider,
          isRead: false,
        ),

        // System notifications (read-only)
        Message(
          id: '3',
          senderId: 'system',
          senderName: 'Klinate System',
          content:
              'Your appointment with Dr. Sarah Mwangi is confirmed for tomorrow at 10:00 AM.',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          type: MessageType.appointment,
          category: MessageCategory.systemNotification,
          isRead: false,
        ),
        Message(
          id: '4',
          senderId: 'system',
          senderName: 'Klinate System',
          content:
              'Your prescription is ready for pickup at Goodlife Pharmacy, Westlands branch.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          type: MessageType.prescription,
          category: MessageCategory.systemNotification,
          isRead: false,
        ),
        Message(
          id: '5',
          senderId: 'system',
          senderName: 'Klinate System',
          content:
              'Payment of KES 2,150 has been processed successfully for your consultation.',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
          type: MessageType.system,
          category: MessageCategory.systemNotification,
          isRead: true,
        ),
        Message(
          id: '6',
          senderId: 'system',
          senderName: 'Klinate System',
          content:
              'Reminder: You have an upcoming appointment in 24 hours with Dr. James Kiprotich.',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          type: MessageType.appointment,
          category: MessageCategory.systemNotification,
          isRead: true,
        ),
        // Medical record notifications
        Message(
          id: '7',
          senderId: 'system',
          senderName: 'Dr. Sarah Mwangi',
          content:
              'Your lab results are now available. Please review them in your Medical Records.',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          type: MessageType.labResults,
          category: MessageCategory.systemNotification,
          documentId: 'doc_lab_001',
          isRead: false,
        ),
        Message(
          id: '8',
          senderId: 'system',
          senderName: 'Nairobi Hospital',
          content:
              'Your X-ray report has been uploaded to your medical records. Click to view.',
          timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
          type: MessageType.xrayReport,
          category: MessageCategory.systemNotification,
          documentId: 'doc_xray_001',
          isRead: false,
        ),
      ]);
      await _saveMessages();
    }
  }

  // Load messages from storage
  static Future<void> loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = prefs.getString(_storageKey);

      if (messagesJson != null) {
        final List<dynamic> messagesList = json.decode(messagesJson);
        _messages.clear();
        _messages.addAll(
          messagesList.map((json) => Message.fromJson(json)).toList(),
        );
      } else {
        await _initializeDefaultMessages();
      }
    } catch (e) {
      // If loading fails, initialize with default messages
      await _initializeDefaultMessages();
    }
  }

  // Save messages to storage
  static Future<void> _saveMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final messagesJson = json.encode(
        _messages.map((message) => message.toJson()).toList(),
      );
      await prefs.setString(_storageKey, messagesJson);
    } catch (e) {
      // Handle save error silently
    }
  }

  static List<Message> getAllMessages() => _messages;

  static List<Message> getUnreadMessages() {
    return _messages.where((msg) => !msg.isRead).toList();
  }

  static Future<void> markAsRead(String messageId) async {
    final message = _messages.firstWhere((msg) => msg.id == messageId);
    message.isRead = true;
    await _saveMessages();
    _notifyListeners();
  }

  static Future<void> sendMessage(Message message) async {
    _messages.insert(0, message);
    await _saveMessages();
    _notifyListeners();
  }

  static int getUnreadCount() {
    return _messages.where((msg) => !msg.isRead).length;
  }

  static Future<void> markAsUnread(String messageId) async {
    final messageIndex = _messages.indexWhere((msg) => msg.id == messageId);
    if (messageIndex != -1) {
      _messages[messageIndex].isRead = false;
      await _saveMessages();
    }
  }

  static Future<void> markAllAsRead() async {
    for (var message in _messages) {
      message.isRead = true;
    }
    await _saveMessages();
    _notifyListeners();
  }

  // Mark messages as read when inbox is viewed
  static Future<void> markInboxAsViewed() async {
    bool hasChanges = false;
    for (var message in _messages) {
      if (!message.isRead) {
        message.isRead = true;
        hasChanges = true;
      }
    }
    if (hasChanges) {
      await _saveMessages();
    }
  }

  static Future<void> deleteMessage(String messageId) async {
    _messages.removeWhere((msg) => msg.id == messageId);
    await _saveMessages();
  }

  static Future<void> clearAllMessages() async {
    _messages.clear();
    await _saveMessages();
  }

  // Simulate receiving a new message (for testing persistence)
  static Future<void> simulateNewMessage() async {
    final newMessage = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'dr_${DateTime.now().millisecondsSinceEpoch % 100}',
      senderName: 'Dr. Test Provider',
      content:
          'This is a test message to verify persistence. Message sent at ${DateTime.now().toString().substring(11, 16)}',
      timestamp: DateTime.now(),
      type: MessageType.text,
      isRead: false,
    );
    _messages.insert(0, newMessage);
    await _saveMessages();
  }

  // Add a message from appointment booking (system notification)
  static Future<void> addAppointmentMessage(
    String providerName,
    String appointmentDetails,
  ) async {
    final message = Message(
      id: 'apt_msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'system',
      senderName: 'Klinate System',
      content: 'Appointment booked with $providerName. $appointmentDetails',
      timestamp: DateTime.now(),
      type: MessageType.appointment,
      category: MessageCategory.systemNotification,
      isRead: false,
    );
    _messages.insert(0, message);
    await _saveMessages();
    _notifyListeners();
  }

  // Add a message from provider (interactive)
  static Future<void> addProviderMessage(
    String providerId,
    String providerName,
    String content,
  ) async {
    final message = Message(
      id: 'provider_msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: providerId,
      senderName: providerName,
      content: content,
      timestamp: DateTime.now(),
      type: MessageType.text,
      category: MessageCategory.healthcareProvider,
      isRead: false,
    );
    _messages.insert(0, message);
    await _saveMessages();
  }

  // Add a system notification (read-only)
  static Future<void> addSystemNotification(
    String content,
    MessageType type,
  ) async {
    final message = Message(
      id: 'system_msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'system',
      senderName: 'Klinate System',
      content: content,
      timestamp: DateTime.now(),
      type: type,
      category: MessageCategory.systemNotification,
      isRead: false,
    );
    _messages.insert(0, message);
    await _saveMessages();
  }

  // Get message count for badge display
  static int getTotalMessageCount() {
    return _messages.length;
  }

  // Get messages by type
  static List<Message> getMessagesByType(MessageType type) {
    return _messages.where((msg) => msg.type == type).toList();
  }

  // Get messages by category
  static List<Message> getMessagesByCategory(MessageCategory category) {
    return _messages.where((msg) => msg.category == category).toList();
  }

  // Get messages by role
  static List<Message> getMessagesByRole(MessageRole role) {
    return _messages.where((msg) => msg.role == role).toList();
  }

  // Get patient messages only
  static List<Message> getPatientMessages() {
    return _messages.where((msg) => msg.role == MessageRole.patient).toList();
  }

  // Get provider messages only
  static List<Message> getProviderMessages() {
    return _messages.where((msg) => msg.role == MessageRole.provider).toList();
  }

  // Get healthcare provider messages (can reply)
  static List<Message> getHealthcareProviderMessages() {
    return _messages
        .where((msg) => msg.category == MessageCategory.healthcareProvider)
        .toList();
  }

  // Get system notifications (read-only)
  static List<Message> getSystemNotifications() {
    return _messages
        .where((msg) => msg.category == MessageCategory.systemNotification)
        .toList();
  }

  // Add a generic message (for testing and general use)
  static Future<void> addMessage({
    required String senderId,
    required String senderName,
    required String content,
    required MessageType type,
    MessageCategory category = MessageCategory.healthcareProvider,
    MessageRole role = MessageRole.patient, // Default to patient
    String? documentId,
    bool isRead = false,
  }) async {
    final message = Message(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: senderId,
      senderName: senderName,
      content: content,
      timestamp: DateTime.now(),
      type: type,
      category: category,
      role: role,
      documentId: documentId,
      isRead: isRead,
    );
    _messages.insert(0, message);
    await _saveMessages();
    _notifyListeners();
  }

  // Force save messages (useful when app is closing or navigating away)
  static Future<void> forceSave() async {
    await _saveMessages();
  }

  // Check if messages are loaded
  static bool get isLoaded => _messages.isNotEmpty;

  // Helper method to create medical record notification
  static Future<void> createMedicalRecordNotification({
    required String providerName,
    required MessageType recordType,
    required String content,
    String? documentId,
  }) async {
    await addMessage(
      senderId: 'system',
      senderName: providerName,
      content: content,
      type: recordType,
      category: MessageCategory.systemNotification,
      documentId: documentId,
    );
  }

  // Listener management for real-time updates
  static void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  static void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  static void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  // Update or create a conversation (for chat inbox)
  // This ensures only one conversation entry exists per patient-provider pair
  static Future<void> updateOrCreateConversation({
    required String conversationId,
    required String senderId,
    required String senderName,
    required String content,
  }) async {
    // Remove existing conversation with this ID if it exists
    _messages.removeWhere((msg) => msg.id == conversationId);

    // Create new conversation entry with updated content
    final conversation = Message(
      id: conversationId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      timestamp: DateTime.now(),
      type: MessageType.text,
      category: MessageCategory.healthcareProvider,
      isRead: false,
    );

    // Insert at the beginning (most recent)
    _messages.insert(0, conversation);
    await _saveMessages();
    _notifyListeners();
  }
}
