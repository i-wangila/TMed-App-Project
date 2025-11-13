import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';

class DocumentService {
  static const String _storageKey = 'tmed_documents';
  static final List<Document> _documents = [];
  static bool _isInitialized = false;

  // Initialize the service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    await _loadDocuments();
    _isInitialized = true;
  }

  // Load documents from storage
  static Future<void> _loadDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final documentsJson = prefs.getString(_storageKey);

      if (documentsJson != null) {
        final List<dynamic> documentsList = json.decode(documentsJson);
        _documents.clear();
        _documents.addAll(
          documentsList.map((json) => Document.fromJson(json)).toList(),
        );
      }
    } catch (e) {
      // Handle loading error silently
    }
  }

  // Save documents to storage
  static Future<void> _saveDocuments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final documentsJson = json.encode(
        _documents.map((doc) => doc.toJson()).toList(),
      );
      await prefs.setString(_storageKey, documentsJson);
    } catch (e) {
      // Handle save error silently
    }
  }

  // Upload a new document
  static Future<bool> uploadDocument({
    required String name,
    required DocumentType type,
    required String filePath,
    DateTime? expiryDate,
    String? notes,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return false;
      }

      // Copy file to app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = filePath.split('/').last;
      final fileExtension = fileName.split('.').last;
      final newFileName =
          'doc_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final newFilePath = '${appDir.path}/documents/$newFileName';

      // Create documents directory if it doesn't exist
      final documentsDir = Directory('${appDir.path}/documents');
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      // Copy file
      final newFile = await file.copy(newFilePath);
      final fileStats = await newFile.stat();

      final document = Document(
        id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        type: type,
        filePath: newFilePath,
        fileName: fileName,
        fileExtension: fileExtension,
        fileSizeBytes: fileStats.size,
        uploadedAt: DateTime.now(),
        expiryDate: expiryDate,
        status: DocumentStatus.pending,
        notes: notes,
      );

      _documents.add(document);
      await _saveDocuments();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get all documents
  static List<Document> getAllDocuments() {
    return List.from(_documents);
  }

  // Get documents by type
  static List<Document> getDocumentsByType(DocumentType type) {
    return _documents.where((doc) => doc.type == type).toList();
  }

  // Get documents by status
  static List<Document> getDocumentsByStatus(DocumentStatus status) {
    return _documents.where((doc) => doc.status == status).toList();
  }

  // Get pending documents
  static List<Document> getPendingDocuments() {
    return getDocumentsByStatus(DocumentStatus.pending);
  }

  // Get approved documents
  static List<Document> getApprovedDocuments() {
    return getDocumentsByStatus(DocumentStatus.approved);
  }

  // Get expired or expiring documents
  static List<Document> getExpiringDocuments() {
    return _documents
        .where((doc) => doc.isExpired || doc.needsRenewal)
        .toList();
  }

  // Update document status
  static Future<bool> updateDocumentStatus(
    String documentId,
    DocumentStatus status, {
    String? rejectionReason,
  }) async {
    try {
      final index = _documents.indexWhere((doc) => doc.id == documentId);
      if (index == -1) return false;

      _documents[index] = _documents[index].copyWith(
        status: status,
        rejectionReason: rejectionReason,
      );

      await _saveDocuments();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Replace/update an existing document
  static Future<bool> replaceDocument({
    required String documentId,
    required String filePath,
    String? notes,
    DateTime? expiryDate,
  }) async {
    try {
      final index = _documents.indexWhere((doc) => doc.id == documentId);
      if (index == -1) return false;

      final oldDocument = _documents[index];

      // Delete old file
      final oldFile = File(oldDocument.filePath);
      if (await oldFile.exists()) {
        await oldFile.delete();
      }

      // Copy new file
      final file = File(filePath);
      if (!await file.exists()) {
        return false;
      }

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = filePath.split('/').last;
      final fileExtension = fileName.split('.').last;
      final newFileName =
          'doc_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final newFilePath = '${appDir.path}/documents/$newFileName';

      final newFile = await file.copy(newFilePath);
      final fileStats = await newFile.stat();

      _documents[index] = oldDocument.copyWith(
        filePath: newFilePath,
        fileName: fileName,
        fileExtension: fileExtension,
        fileSizeBytes: fileStats.size,
        uploadedAt: DateTime.now(),
        expiryDate: expiryDate,
        status: DocumentStatus.pending,
        notes: notes,
        rejectionReason: null, // Clear previous rejection reason
      );

      await _saveDocuments();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete a document
  static Future<bool> deleteDocument(String documentId) async {
    try {
      final index = _documents.indexWhere((doc) => doc.id == documentId);
      if (index == -1) return false;

      final document = _documents[index];

      // Delete file
      final file = File(document.filePath);
      if (await file.exists()) {
        await file.delete();
      }

      _documents.removeAt(index);
      await _saveDocuments();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get document by ID
  static Document? getDocumentById(String documentId) {
    try {
      return _documents.firstWhere((doc) => doc.id == documentId);
    } catch (e) {
      return null;
    }
  }

  // Check if document type already exists and is approved
  static bool hasApprovedDocument(DocumentType type) {
    return _documents.any(
      (doc) => doc.type == type && doc.status == DocumentStatus.approved,
    );
  }

  // Get the latest document of a specific type
  static Document? getLatestDocumentByType(DocumentType type) {
    final docs = getDocumentsByType(type);
    if (docs.isEmpty) return null;

    docs.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return docs.first;
  }

  // Simulate admin approval (for demo purposes)
  static Future<void> simulateAdminReview(String documentId) async {
    await Future.delayed(const Duration(seconds: 2));

    // Randomly approve or reject for demo
    final isApproved = DateTime.now().millisecond % 2 == 0;

    if (isApproved) {
      await updateDocumentStatus(documentId, DocumentStatus.approved);
    } else {
      await updateDocumentStatus(
        documentId,
        DocumentStatus.rejected,
        rejectionReason:
            'Document quality is not clear enough. Please upload a clearer image.',
      );
    }
  }

  // Get document statistics
  static Map<String, int> getDocumentStats() {
    return {
      'total': _documents.length,
      'pending': getPendingDocuments().length,
      'approved': getApprovedDocuments().length,
      'rejected': getDocumentsByStatus(DocumentStatus.rejected).length,
      'expiring': getExpiringDocuments().length,
    };
  }

  // Clear all documents (for testing)
  static Future<void> clearAllDocuments() async {
    // Delete all files
    for (final doc in _documents) {
      final file = File(doc.filePath);
      if (await file.exists()) {
        try {
          await file.delete();
        } catch (e) {
          // Continue even if file deletion fails
        }
      }
    }

    _documents.clear();
    await _saveDocuments();
  }
}
