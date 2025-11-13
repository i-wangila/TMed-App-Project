import 'package:flutter/material.dart';
import '../models/provider_type.dart';
import '../models/document.dart';
import '../models/user_profile.dart';
import '../models/provider_profile.dart';
import '../services/healthcare_provider_service.dart';
import '../services/healthcare_facility_service.dart';
import '../services/document_service.dart';
import '../services/user_service.dart';
import '../services/provider_service.dart';
import 'document_upload_screen.dart';

class ProviderRegistrationScreen extends StatefulWidget {
  final ProviderType providerType;

  const ProviderRegistrationScreen({super.key, required this.providerType});

  @override
  State<ProviderRegistrationScreen> createState() =>
      _ProviderRegistrationScreenState();
}

class _ProviderRegistrationScreenState extends State<ProviderRegistrationScreen>
    with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;
  bool _isLoading = false;

  // Form controllers
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _professionalInfoFormKey = GlobalKey<FormState>();

  // Basic Info
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  // Professional Info
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();
  final _consultationFeeController = TextEditingController();

  final List<String> _selectedServices = [];
  final List<String> _selectedLanguages = [];
  final List<String> _workingDays = [];

  // Documents
  final List<Document> _uploadedDocuments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeDocumentService();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reload documents when app resumes
      _loadUploadedDocuments();
    }
  }

  Future<void> _initializeDocumentService() async {
    await DocumentService.initialize();
    await _loadUploadedDocuments();
  }

  Future<void> _loadUploadedDocuments() async {
    final documents = DocumentService.getAllDocuments();
    if (mounted) {
      setState(() {
        _uploadedDocuments.clear();
        _uploadedDocuments.addAll(documents);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Register as ${widget.providerType.name}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildBasicInfoStep(),
                _buildProfessionalInfoStep(),
                _buildDocumentsStep(),
                _buildReviewStep(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: List.generate(_totalSteps, (index) {
              final isCompleted = index < _currentStep;
              final isCurrent = index == _currentStep;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < _totalSteps - 1 ? 8 : 0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: isCompleted || isCurrent
                                ? Colors.black
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            'Step ${_currentStep + 1} of $_totalSteps',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _basicInfoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Let\'s start with your basic details',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            _buildTextField(
              controller: _nameController,
              label: widget.providerType.category == ProviderCategory.individual
                  ? 'Full Name'
                  : 'Facility Name',
              hint: widget.providerType.category == ProviderCategory.individual
                  ? 'Dr. John Doe'
                  : 'City Medical Center',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'john.doe@example.com',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '+254740109195',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _addressController,
              label: widget.providerType.category == ProviderCategory.individual
                  ? 'Practice Address'
                  : 'Facility Address',
              hint: 'Nairobi, Kenya',
              icon: Icons.location_on,
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _professionalInfoFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Professional Details',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tell us about your professional background',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            _buildTextField(
              controller: _specializationController,
              label: 'Specialization',
              hint: 'Cardiology, General Practice, etc.',
              icon: Icons.medical_services,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your specialization';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _experienceController,
              label: 'Years of Experience',
              hint: '5',
              icon: Icons.work,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your experience';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _consultationFeeController,
              label: 'Consultation Fee (KES)',
              hint: '2000',
              icon: Icons.attach_money,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your consultation fee';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _bioController,
              label: 'Professional Bio',
              hint: 'Tell patients about your experience and approach...',
              icon: Icons.description,
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your bio';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildServicesSection(),
            const SizedBox(height: 24),
            _buildLanguagesSection(),
            const SizedBox(height: 24),
            _buildWorkingDaysSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Documents',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload required documents for verification',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          ...widget.providerType.requirements.map((requirement) {
            return _buildDocumentUploadCard(requirement);
          }),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue[600], size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Document Guidelines',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '• Documents should be clear and legible\n'
                  '• Accepted formats: PDF, JPG, PNG\n'
                  '• Maximum file size: 5MB per document\n'
                  '• All documents will be verified within 24-48 hours',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Review & Submit',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please review your information before submitting',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          _buildReviewSection('Basic Information', [
            'Name: ${_nameController.text}',
            'Email: ${_emailController.text}',
            'Phone: ${_phoneController.text}',
            'Address: ${_addressController.text}',
          ]),
          const SizedBox(height: 20),
          _buildReviewSection('Professional Details', [
            'Specialization: ${_specializationController.text}',
            'Experience: ${_experienceController.text} years',
            'Consultation Fee: KES ${_consultationFeeController.text}',
            'Services: ${_selectedServices.join(', ')}',
            'Languages: ${_selectedLanguages.join(', ')}',
            'Working Days: ${_workingDays.join(', ')}',
          ]),
          const SizedBox(height: 20),
          _buildReviewSection('Documents', [
            'Uploaded: ${_uploadedDocuments.length}/${widget.providerType.requirements.length} documents',
            'Approved: ${_uploadedDocuments.where((doc) => doc.status == DocumentStatus.approved).length} documents',
            'Pending: ${_uploadedDocuments.where((doc) => doc.status == DocumentStatus.pending).length} documents',
          ]),
          const SizedBox(height: 20),
          _buildReviewSection('Profile Image', [
            'Using current profile picture',
          ]),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Next Steps',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '1. Your application will be reviewed within 24-48 hours\n'
                  '2. You\'ll receive an email notification about the status\n'
                  '3. Once approved, you can start accepting patients\n'
                  '4. Set up your availability and start earning',
                  style: TextStyle(fontSize: 14, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildServicesSection() {
    final availableServices = _getAvailableServices();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Services Offered',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableServices.map((service) {
            final isSelected = _selectedServices.contains(service);
            return FilterChip(
              label: Text(service),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedServices.add(service);
                  } else {
                    _selectedServices.remove(service);
                  }
                });
              },
              selectedColor: Colors.blue[100],
              checkmarkColor: Colors.blue[800],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLanguagesSection() {
    final availableLanguages = [
      'English',
      'Swahili',
      'Kikuyu',
      'Luo',
      'Kalenjin',
      'Kamba',
      'Luhya',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Languages Spoken',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableLanguages.map((language) {
            final isSelected = _selectedLanguages.contains(language);
            return FilterChip(
              label: Text(language),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedLanguages.add(language);
                  } else {
                    _selectedLanguages.remove(language);
                  }
                });
              },
              selectedColor: Colors.green[100],
              checkmarkColor: Colors.green[800],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildWorkingDaysSection() {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Working Days',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: days.map((day) {
            final isSelected = _workingDays.contains(day);
            return FilterChip(
              label: Text(day),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _workingDays.add(day);
                  } else {
                    _workingDays.remove(day);
                  }
                });
              },
              selectedColor: Colors.orange[100],
              checkmarkColor: Colors.orange[800],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDocumentUploadCard(String documentType) {
    // Find all documents for this type
    final documents = _uploadedDocuments
        .where(
          (doc) =>
              doc.typeDisplayName.toLowerCase() == documentType.toLowerCase(),
        )
        .toList();

    final hasDocuments = documents.isNotEmpty;
    final approvedCount = documents
        .where((doc) => doc.status == DocumentStatus.approved)
        .length;
    final pendingCount = documents
        .where((doc) => doc.status == DocumentStatus.pending)
        .length;
    final rejectedCount = documents
        .where((doc) => doc.status == DocumentStatus.rejected)
        .length;

    Color statusColor = Colors.grey[600]!;
    String statusText = 'No documents uploaded';
    IconData statusIcon = Icons.upload_file;

    if (hasDocuments) {
      if (approvedCount > 0) {
        statusColor = Colors.green[600]!;
        statusText = '$approvedCount approved';
        statusIcon = Icons.check_circle;
      } else if (pendingCount > 0) {
        statusColor = Colors.orange[600]!;
        statusText = '$pendingCount pending review';
        statusIcon = Icons.pending;
      } else if (rejectedCount > 0) {
        statusColor = Colors.red[600]!;
        statusText = '$rejectedCount rejected';
        statusIcon = Icons.cancel;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasDocuments
              ? statusColor.withValues(alpha: 0.3)
              : Colors.grey[300]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      documentType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasDocuments
                          ? '$statusText (${documents.length} total)'
                          : statusText,
                      style: TextStyle(
                        fontSize: 14,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _uploadDocument(documentType),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[100],
                  foregroundColor: Colors.blue[800],
                  elevation: 0,
                ),
                child: const Text('Add Document'),
              ),
            ],
          ),
          if (documents.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            ...documents.map((doc) => _buildDocumentListItem(doc)),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentListItem(Document document) {
    Color statusColor = Colors.grey[600]!;
    IconData statusIcon = Icons.pending;

    switch (document.status) {
      case DocumentStatus.approved:
        statusColor = Colors.green[600]!;
        statusIcon = Icons.check_circle;
        break;
      case DocumentStatus.pending:
        statusColor = Colors.orange[600]!;
        statusIcon = Icons.pending;
        break;
      case DocumentStatus.rejected:
        statusColor = Colors.red[600]!;
        statusIcon = Icons.cancel;
        break;
      case DocumentStatus.expired:
        statusColor = Colors.grey[600]!;
        statusIcon = Icons.schedule;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.fileName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${document.statusText} • ${document.fileSizeFormatted}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red[400],
            onPressed: () => _deleteDocument(document.id),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDocument(String documentId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: const Text('Are you sure you want to delete this document?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await DocumentService.deleteDocument(documentId);
      if (success) {
        await _loadUploadedDocuments();
        _showSnackBar('Document deleted successfully');
      } else {
        _showSnackBar('Failed to delete document');
      }
    }
  }

  Widget _buildReviewSection(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                item,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back', style: TextStyle(color: Colors.grey)),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _currentStep == _totalSteps - 1
                          ? 'Submit Application'
                          : 'Continue',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      // Validate current step
      bool isValid = false;
      switch (_currentStep) {
        case 0:
          isValid = _basicInfoFormKey.currentState?.validate() ?? false;
          break;
        case 1:
          isValid = _professionalInfoFormKey.currentState?.validate() ?? false;
          if (isValid && _selectedServices.isEmpty) {
            _showSnackBar('Please select at least one service');
            isValid = false;
          }
          if (isValid && _selectedLanguages.isEmpty) {
            _showSnackBar('Please select at least one language');
            isValid = false;
          }
          if (isValid && _workingDays.isEmpty) {
            _showSnackBar('Please select at least one working day');
            isValid = false;
          }
          break;
        case 2:
          // Check if at least one document is uploaded for each required type
          final requiredTypes = widget.providerType.requirements;
          final missingTypes = <String>[];

          for (final requiredType in requiredTypes) {
            final hasDocument = _uploadedDocuments.any(
              (doc) =>
                  doc.typeDisplayName.toLowerCase() ==
                  requiredType.toLowerCase(),
            );
            if (!hasDocument) {
              missingTypes.add(requiredType);
            }
          }

          isValid = missingTypes.isEmpty;
          if (!isValid) {
            _showSnackBar(
              'Please upload at least one document for: ${missingTypes.join(", ")}',
            );
          }
          break;
      }

      if (isValid) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      _submitApplication();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _uploadDocument(String documentType) async {
    // Map document type string to DocumentType enum
    DocumentType docType;
    switch (documentType.toLowerCase()) {
      case 'medical license':
        docType = DocumentType.medicalLicense;
        break;
      case 'professional certification':
        docType = DocumentType.professionalCertification;
        break;
      case 'valid id':
        docType = DocumentType.validId;
        break;
      case 'insurance certificate':
        docType = DocumentType.insurance;
        break;
      default:
        docType = DocumentType.other;
    }

    // Navigate to document upload screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DocumentUploadScreen(documentType: docType),
      ),
    );

    if (result == true) {
      // Reload uploaded documents
      await _loadUploadedDocuments();
      _showSnackBar('$documentType uploaded successfully');
    }
  }

  void _submitApplication() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = UserService.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Map provider type ID to UserRole
      UserRole providerRole = _mapProviderTypeToRole(widget.providerType.id);

      // Create ProviderProfile
      final providerProfile = ProviderProfile(
        userId: currentUser.id,
        providerType: providerRole,
        status: ProviderStatus.pending, // Pending verification
        specialization: _specializationController.text.trim(),
        servicesOffered: _selectedServices,
        experienceYears: int.tryParse(_experienceController.text),
        bio: _bioController.text.trim(),
        languages: _selectedLanguages,
        consultationFee: double.tryParse(_consultationFeeController.text),
        workingDays: _workingDays,
        verificationDocuments: _uploadedDocuments.map((d) => d.id).toList(),
      );

      // Save provider profile
      final savedProfile = await ProviderService.createProvider(
        providerProfile,
      );
      if (savedProfile == null) {
        throw Exception('Failed to create provider profile');
      }

      // Add provider role to user
      await UserService.addRole(providerRole);

      // Also create in old services for backward compatibility
      if (widget.providerType.category == ProviderCategory.individual) {
        final newProvider =
            HealthcareProviderService.createProviderFromRegistration(
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              address: _addressController.text,
              specialization: _specializationController.text,
              experienceYears: int.tryParse(_experienceController.text) ?? 0,
              bio: _bioController.text,
              consultationFee:
                  double.tryParse(_consultationFeeController.text) ?? 0.0,
              services: _selectedServices,
              languages: _selectedLanguages,
              workingDays: _workingDays,
              providerType: widget.providerType.name,
              profileImagePath:
                  currentUser.profilePicturePath ??
                  'https://via.placeholder.com/200',
            );
        await HealthcareProviderService.addNewProvider(newProvider);
      } else {
        final newFacility =
            HealthcareFacilityService.createFacilityFromRegistration(
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              address: _addressController.text,
              specialization: _specializationController.text,
              bio: _bioController.text,
              services: _selectedServices,
              workingDays: _workingDays,
              facilityTypeId: widget.providerType.id,
              profileImagePath:
                  currentUser.profilePicturePath ??
                  'https://via.placeholder.com/200',
            );
        await HealthcareFacilityService.addNewFacility(newFacility);
      }

      // Simulate processing time
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnackBar('Registration failed: ${e.toString()}');
      }
    }
  }

  UserRole _mapProviderTypeToRole(String providerTypeId) {
    switch (providerTypeId) {
      case 'doctor':
        return UserRole.doctor;
      case 'nurse':
        return UserRole.nurse;
      case 'therapist':
        return UserRole.therapist;
      case 'nutritionist':
        return UserRole.nutritionist;
      case 'home_care':
        return UserRole.homecare;
      case 'hospital':
        return UserRole.hospital;
      case 'clinic':
        return UserRole.clinic;
      case 'pharmacy':
        return UserRole.pharmacy;
      case 'laboratory':
        return UserRole.laboratory;
      case 'dental':
        return UserRole.dental;
      case 'wellness':
        return UserRole.wellness;
      default:
        return UserRole.doctor;
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Application Submitted!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your application to become a ${widget.providerType.name} has been submitted successfully! Your application is now pending admin approval. You will be notified once approved.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Close dialog and navigate back to home
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close registration screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  List<String> _getAvailableServices() {
    switch (widget.providerType.id) {
      case 'doctor':
        return [
          'Consultation',
          'Diagnosis',
          'Treatment',
          'Follow-up',
          'Emergency Care',
        ];
      case 'nurse':
        return [
          'Patient Care',
          'Health Education',
          'Medication Administration',
          'Wound Care',
          'Home Visits',
        ];
      case 'therapist':
        return [
          'Physical Therapy',
          'Mental Health Counseling',
          'Rehabilitation',
          'Group Therapy',
          'Assessment',
        ];
      case 'nutritionist':
        return [
          'Diet Planning',
          'Nutrition Counseling',
          'Weight Management',
          'Sports Nutrition',
          'Health Assessment',
        ];
      case 'home_care':
        return [
          'Personal Care',
          'Medical Assistance',
          'Companionship',
          'Medication Reminders',
          'Mobility Support',
        ];
      case 'hospital':
        return [
          'Emergency Services',
          'Surgery',
          'Inpatient Care',
          'Outpatient Services',
          'Diagnostic Services',
        ];
      case 'clinic':
        return [
          'General Consultation',
          'Specialist Services',
          'Preventive Care',
          'Health Screenings',
          'Vaccinations',
        ];
      case 'pharmacy':
        return [
          'Prescription Dispensing',
          'Medication Counseling',
          'Health Products',
          'Vaccination Services',
          'Health Screenings',
        ];
      case 'laboratory':
        return [
          'Blood Tests',
          'Imaging Services',
          'Pathology',
          'Diagnostic Tests',
          'Health Screenings',
        ];
      case 'dental':
        return [
          'General Dentistry',
          'Teeth Cleaning',
          'Oral Surgery',
          'Orthodontics',
          'Cosmetic Dentistry',
        ];
      case 'wellness':
        return [
          'Wellness Programs',
          'Fitness Training',
          'Stress Management',
          'Nutrition Guidance',
          'Health Coaching',
        ];
      default:
        return ['General Services'];
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    _consultationFeeController.dispose();
    super.dispose();
  }
}
