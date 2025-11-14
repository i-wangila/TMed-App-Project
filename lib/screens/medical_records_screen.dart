import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/document.dart';
import '../services/document_service.dart';

class MedicalRecordsScreen extends StatefulWidget {
  final String? highlightDocumentId;

  const MedicalRecordsScreen({super.key, this.highlightDocumentId});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Prescriptions',
    'Lab Results',
    'X-Ray Reports',
    'Medical Reports',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Medical Records',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildCategoryTabs(),
          Expanded(child: _buildDocumentsList()),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue[800],
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue[800] : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDocumentsList() {
    final allDocuments = DocumentService.getAllDocuments();
    final filteredDocuments = _filterDocuments(allDocuments);

    if (filteredDocuments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No medical records found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredDocuments.length,
      itemBuilder: (context, index) {
        final document = filteredDocuments[index];
        final isHighlighted = document.id == widget.highlightDocumentId;
        return _buildDocumentCard(document, isHighlighted);
      },
    );
  }

  List<Document> _filterDocuments(List<Document> documents) {
    // Filter medical documents only
    final medicalDocs = documents.where((doc) {
      return doc.type == DocumentType.prescription ||
          doc.type == DocumentType.labResults ||
          doc.type == DocumentType.xrayReport ||
          doc.type == DocumentType.medicalReport ||
          doc.type == DocumentType.dischargeSummary ||
          doc.type == DocumentType.vaccinationRecord;
    }).toList();

    if (_selectedCategory == 'All') {
      return medicalDocs;
    } else if (_selectedCategory == 'Prescriptions') {
      return medicalDocs
          .where((doc) => doc.type == DocumentType.prescription)
          .toList();
    } else if (_selectedCategory == 'Lab Results') {
      return medicalDocs
          .where((doc) => doc.type == DocumentType.labResults)
          .toList();
    } else if (_selectedCategory == 'X-Ray Reports') {
      return medicalDocs
          .where((doc) => doc.type == DocumentType.xrayReport)
          .toList();
    } else if (_selectedCategory == 'Medical Reports') {
      return medicalDocs
          .where((doc) => doc.type == DocumentType.medicalReport)
          .toList();
    } else {
      return medicalDocs
          .where(
            (doc) =>
                doc.type == DocumentType.dischargeSummary ||
                doc.type == DocumentType.vaccinationRecord,
          )
          .toList();
    }
  }

  Widget _buildDocumentCard(Document document, bool isHighlighted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.blue[50] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted ? Colors.blue : Colors.grey[300]!,
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _viewDocument(document),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _getDocumentColor(
                          document.type,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getDocumentIcon(document.type),
                        color: _getDocumentColor(document.type),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.typeDisplayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            document.name,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isHighlighted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'NEW',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(document.uploadedAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('h:mm a').format(document.uploadedAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
                if (document.notes != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    document.notes!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getDocumentIcon(DocumentType type) {
    switch (type) {
      case DocumentType.prescription:
        return Icons.medication;
      case DocumentType.labResults:
        return Icons.science;
      case DocumentType.xrayReport:
        return Icons.medical_services;
      case DocumentType.medicalReport:
        return Icons.description;
      case DocumentType.dischargeSummary:
        return Icons.assignment;
      case DocumentType.vaccinationRecord:
        return Icons.vaccines;
      default:
        return Icons.folder;
    }
  }

  Color _getDocumentColor(DocumentType type) {
    switch (type) {
      case DocumentType.prescription:
        return Colors.green;
      case DocumentType.labResults:
        return Colors.purple;
      case DocumentType.xrayReport:
        return Colors.blue;
      case DocumentType.medicalReport:
        return Colors.orange;
      case DocumentType.dischargeSummary:
        return Colors.teal;
      case DocumentType.vaccinationRecord:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  void _viewDocument(Document document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document.typeDisplayName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Document: ${document.name}'),
              const SizedBox(height: 8),
              Text(
                'Uploaded: ${DateFormat('MMM dd, yyyy - h:mm a').format(document.uploadedAt)}',
              ),
              if (document.notes != null) ...[
                const SizedBox(height: 8),
                Text('Notes: ${document.notes}'),
              ],
              const SizedBox(height: 16),
              const Text(
                'Document preview and download functionality will be implemented here.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading ${document.name}...'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
