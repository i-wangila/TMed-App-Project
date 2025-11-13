enum MessageType {
  text,
  image,
  file,
  appointment,
  prescription,
  labResults,
  medicalReport,
  xrayReport,
  dischargeSummary,
  vaccinationRecord,
  system,
}

enum MessageCategory {
  healthcareProvider, // Interactive chats with doctors/providers
  systemNotification, // Read-only system alerts/notifications
}

class Message {
  final String id;
  final String senderId;
  final String senderName;
  final String content;
  final DateTime timestamp;
  final MessageType type;
  final MessageCategory category;
  final String? documentId; // ID of the medical record document
  bool isRead;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.category = MessageCategory.healthcareProvider,
    this.documentId,
    this.isRead = false,
  });

  // Helper methods
  bool get isSystemNotification =>
      category == MessageCategory.systemNotification;
  bool get isHealthcareProviderMessage =>
      category == MessageCategory.healthcareProvider;
  bool get canReply => category == MessageCategory.healthcareProvider;
  bool get isMedicalRecord =>
      type == MessageType.prescription ||
      type == MessageType.labResults ||
      type == MessageType.medicalReport ||
      type == MessageType.xrayReport ||
      type == MessageType.dischargeSummary ||
      type == MessageType.vaccinationRecord;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString(),
      'category': category.toString(),
      'documentId': documentId,
      'isRead': isRead,
    };
  }

  // Create from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
      category: MessageCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
        orElse: () => MessageCategory.healthcareProvider,
      ),
      documentId: json['documentId'],
      isRead: json['isRead'] ?? false,
    );
  }
}
