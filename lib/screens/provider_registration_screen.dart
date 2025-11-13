import 'package:flutter/material.dart';
import '../models/provider_type.dart';
import '../models/document.dart';
import '../services/healthcare_provider_service.dart';
import '../services/healthcare_facility_service.dart';
import '../services/document_service.dart';
import '../services/user_service.dart';
import 'document_upload_screen.dart';

class ProviderRegistrationScreen extends StatefulWidget {
  final ProviderType providerType;

  const ProviderRegistrationScreen({super.key, required this.providerType});

  @override
  State<ProviderRegistrationScreen> createState() =>
      _ProviderRegistrationScreenState();
}

class _ProviderRegistrationScreenState
    extends State<ProviderRegistrationScreen> {
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
    _initializeDocumentService();
  }

  Future<void> _initializeDocumentService() async {
    await DocumentService.initialize();
    await _loadUploadedDocuments();
  }

  Future<void> _loadUploadedDocuments() async {
    final documents = DocumentService.getAllDocuments();
    setState(() {
      _uploadedDocuments.clear();
      _uploadedDocuments.addAll(documents);
    });
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
    // Find the document for this type
    Document? document;
    try {
      document = _uploadedDocuments.firstWhere(
        (doc) =>
            doc.typeDisplayName.toLowerCase() == documentType.toLowerCase(),
      );
    } catch (e) {
      document = null;
    }

    final isUploaded = document != null;
    Color statusColor = Colors.grey[600]!;
    String statusText = 'Tap to upload';
    IconData statusIcon = Icons.upload_file;

    if (isUploaded) {
      switch (document.status) {
        case DocumentStatus.approved:
          statusColor = Colors.green[600]!;
          statusText = 'Approved';
          statusIcon = Icons.check_circle;
          break;
        case DocumentStatus.pending:
          statusColor = Colors.orange[600]!;
          statusText = 'Pending review';
          statusIcon = Icons.pending;
          break;
        case DocumentStatus.rejected:
          statusColor = Colors.red[600]!;
          statusText = 'Rejected - needs update';
          statusIcon = Icons.cancel;
          break;
        case DocumentStatus.expired:
          statusColor = Colors.grey[600]!;
          statusText = 'Expired - needs renewal';
          statusIcon = Icons.schedule;
          break;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUploaded
              ? statusColor.withValues(alpha: 0.3)
              : Colors.grey[300]!,
        ),
      ),
      child: Row(
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
                  statusText,
                  style: TextStyle(
                    fontSize: 14,
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isUploaded && document.fileName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    document.fileName,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _uploadDocument(documentType),
            style: ElevatedButton.styleFrom(
              backgroundColor: isUploaded
                  ? statusColor.withValues(alpha: 0.1)
                  : Colors.blue[100],
              foregroundColor: isUploaded ? statusColor : Colors.blue[800],
              elevation: 0,
            ),
            child: Text(isUploaded ? 'Update' : 'Upload'),
          ),
        ],
      ),
    );
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
          // Check if all required documents are uploaded and approved
          final requiredDocs = widget.providerType.requirements.length;
          final approvedDocs = _uploadedDocuments
              .where((doc) => doc.status == DocumentStatus.approved)
              .length;

          isValid = _uploadedDocuments.length >= requiredDocs;
          if (!isValid) {
            _showSnackBar('Please upload all required documents');
          } else if (approvedDocs < requiredDocs) {
            _showSnackBar('Some documents are still pending approval');
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
      // Create provider/facility based on category
      if (widget.providerType.category == ProviderCategory.individual) {
        // Create individual healthcare provider
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
                  UserService.currentUser?.profilePicturePath ??
                  'https://via.placeholder.com/200',
            );

        // Add to provider service
        final success = await HealthcareProviderService.addNewProvider(
          newProvider,
        );
        if (!success) {
          throw Exception(
            'Failed to register provider - email may already exist',
          );
        }
      } else {
        // Create healthcare facility
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
                  UserService.currentUser?.profilePicturePath ??
                  'https://via.placeholder.com/200',
            );

        // Add to facility service
        final success = await HealthcareFacilityService.addNewFacility(
          newFacility,
        );
        if (!success) {
          throw Exception(
            'Failed to register facility - email may already exist',
          );
        }
      }

      // Simulate additional processing time
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
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
              'Your application to become a ${widget.providerType.name} has been submitted successfully. You are now listed in the TMed network and can start receiving appointment requests!',
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
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
                  'Back to Home',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
