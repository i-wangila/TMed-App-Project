import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/provider_type.dart';
import '../models/document.dart';
import '../models/user_profile.dart';
import '../models/provider_profile.dart';
import '../services/healthcare_provider_service.dart';
import '../services/healthcare_facility_service.dart';
import '../services/document_service.dart';
import '../services/user_service.dart';
import '../services/provider_service.dart';
import '../services/message_service.dart';
import '../models/message.dart';
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
  final _servicesDescriptionController = TextEditingController();

  final List<String> _selectedServices = [];
  final List<String> _selectedLanguages = [];
  final List<String> _selectedInsurance = [];
  final List<String> _selectedPaymentMethods = [];

  // M-Pesa payment details
  final _mpesaPaybillController = TextEditingController();
  final _mpesaAccountController = TextEditingController();
  final _mpesaTillController = TextEditingController();

  // Bank transfer details
  final _bankNameController = TextEditingController();
  final _bankAccountController = TextEditingController();

  final List<String> _workingDays = [];
  final Map<String, Map<String, String>> _workingHours =
      {}; // day -> {start, end}
  final List<String> _profileImages = []; // Store image paths
  final ImagePicker _picker = ImagePicker();

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
            _buildInsuranceSection(),
            const SizedBox(height: 24),
            _buildPaymentMethodsSection(),
            const SizedBox(height: 24),
            _buildWorkingDaysSection(),
            const SizedBox(height: 24),
            _buildProfileImagesSection(),
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
          ]),
          const SizedBox(height: 20),
          _buildWorkingHoursReviewSection(),
          const SizedBox(height: 20),
          _buildReviewSection('Documents', [
            'Uploaded: ${_uploadedDocuments.length}/${widget.providerType.requirements.length} documents',
            'Approved: ${_uploadedDocuments.where((doc) => doc.status == DocumentStatus.approved).length} documents',
            'Pending: ${_uploadedDocuments.where((doc) => doc.status == DocumentStatus.pending).length} documents',
          ]),
          const SizedBox(height: 20),
          _buildReviewSection('Profile/Premise Image', [
            _profileImages.isNotEmpty
                ? '1 image uploaded'
                : 'Using current profile picture',
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
        const SizedBox(height: 16),
        TextFormField(
          controller: _servicesDescriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'Detailed Service Description',
            hintText:
                'Describe your services in detail, including specialties, procedures, treatments, equipment, and any other relevant information...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.description),
            helperText:
                'Provide as much detail as you want about your services',
            helperMaxLines: 2,
          ),
          validator: (value) {
            if ((value == null || value.trim().isEmpty) &&
                _selectedServices.isEmpty) {
              return 'Please select services or provide a description';
            }
            return null;
          },
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

  List<String> _buildPaymentMethodsString() {
    final methods = List<String>.from(_selectedPaymentMethods);

    // Add M-Pesa details if provided
    if (_selectedPaymentMethods.contains('M-Pesa')) {
      if (_mpesaPaybillController.text.isNotEmpty) {
        methods.add(
          'M-Pesa Paybill: ${_mpesaPaybillController.text}${_mpesaAccountController.text.isNotEmpty ? ' (Acc: ${_mpesaAccountController.text})' : ''}',
        );
      }
      if (_mpesaTillController.text.isNotEmpty) {
        methods.add('M-Pesa Till: ${_mpesaTillController.text}');
      }
    }

    // Add Bank details if provided
    if (_selectedPaymentMethods.contains('Bank Transfer')) {
      if (_bankNameController.text.isNotEmpty &&
          _bankAccountController.text.isNotEmpty) {
        methods.add(
          'Bank: ${_bankNameController.text} - ${_bankAccountController.text}',
        );
      }
    }

    return methods;
  }

  Widget _buildInsuranceSection() {
    final availableInsurance = [
      'NHIF',
      'AAR Insurance',
      'Jubilee Insurance',
      'CIC Insurance',
      'Madison Insurance',
      'Britam',
      'APA Insurance',
      'GA Insurance',
      'Old Mutual',
      'Liberty Life',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Insurance Accepted',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Select insurance providers you accept',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableInsurance.map((insurance) {
            final isSelected = _selectedInsurance.contains(insurance);
            return FilterChip(
              label: Text(insurance),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedInsurance.add(insurance);
                  } else {
                    _selectedInsurance.remove(insurance);
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

  Widget _buildPaymentMethodsSection() {
    final paymentOptions = [
      'M-Pesa',
      'Bank Transfer',
      'Credit/Debit Card',
      'Insurance',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Methods Accepted',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Select payment methods you accept',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: paymentOptions.map((method) {
            final isSelected = _selectedPaymentMethods.contains(method);
            return FilterChip(
              label: Text(method),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedPaymentMethods.add(method);
                  } else {
                    _selectedPaymentMethods.remove(method);
                  }
                });
              },
              selectedColor: Colors.green[100],
              checkmarkColor: Colors.green[800],
            );
          }).toList(),
        ),
        // M-Pesa Details
        if (_selectedPaymentMethods.contains('M-Pesa')) ...[
          const SizedBox(height: 20),
          const Text(
            'M-Pesa Payment Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _mpesaPaybillController,
            label: 'Paybill Number (Optional)',
            hint: 'Enter paybill number',
            icon: Icons.payment,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _mpesaAccountController,
            label: 'Account Number (Optional)',
            hint: 'Enter account number for paybill',
            icon: Icons.account_balance,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _mpesaTillController,
            label: 'Till Number (Optional)',
            hint: 'Enter till number',
            icon: Icons.store,
            keyboardType: TextInputType.number,
          ),
        ],
        // Bank Transfer Details
        if (_selectedPaymentMethods.contains('Bank Transfer')) ...[
          const SizedBox(height: 20),
          const Text(
            'Bank Transfer Details',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _bankNameController,
            label: 'Bank Name',
            hint: 'e.g., Equity Bank',
            icon: Icons.account_balance,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            controller: _bankAccountController,
            label: 'Account Number',
            hint: 'Enter account number',
            icon: Icons.numbers,
            keyboardType: TextInputType.number,
          ),
        ],
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
        Row(
          children: [
            const Icon(Icons.schedule, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Working Days & Hours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Select your working days and set hours for each day',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: days.map((day) {
              final isSelected = _workingDays.contains(day);
              final hours = _workingHours[day];
              final startTime = hours?['start'] ?? '08:00 AM';
              final endTime = hours?['end'] ?? '10:00 PM';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue[50] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? Colors.blue[200]! : Colors.grey[300]!,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (selected) {
                            setState(() {
                              if (selected == true) {
                                _workingDays.add(day);
                                // Set default hours if not already set
                                if (!_workingHours.containsKey(day)) {
                                  _workingHours[day] = {
                                    'start': '08:00 AM',
                                    'end': '10:00 PM',
                                  };
                                }
                              } else {
                                _workingDays.remove(day);
                                _workingHours.remove(day);
                              }
                            });
                          },
                          activeColor: Colors.blue[600],
                        ),
                        Expanded(
                          child: Text(
                            day,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.black
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                        if (isSelected)
                          Text(
                            '$startTime - $endTime',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                    if (isSelected) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTimeSelector(
                              label: 'Start Time',
                              value: startTime,
                              onTap: () => _selectTime(day, 'start', startTime),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTimeSelector(
                              label: 'End Time',
                              value: endTime,
                              onTap: () => _selectTime(day, 'end', endTime),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(String day, String type, String currentTime) async {
    // Parse current time
    final parts = currentTime.split(' ');
    final timeParts = parts[0].split(':');
    final isPM = parts[1] == 'PM';
    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Convert to 24-hour format for TimeOfDay
    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hour, minute: minute),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[600]!,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Convert to 12-hour format
      final hour12 = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
      final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
      final formattedTime =
          '${hour12.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')} $period';

      setState(() {
        if (!_workingHours.containsKey(day)) {
          _workingHours[day] = {'start': '08:00 AM', 'end': '10:00 PM'};
        }
        _workingHours[day]![type] = formattedTime;
      });
    }
  }

  Widget _buildProfileImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile/Premise Image',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          'Upload one image that will appear on your provider card on the patient home screen. This can be your professional photo or your facility/premise.',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        if (_profileImages.isNotEmpty)
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              image: DecorationImage(
                image: kIsWeb
                    ? NetworkImage(_profileImages[0])
                    : FileImage(File(_profileImages[0])) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _profileImages.clear();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _profileImages.isEmpty ? _pickProfileImage : null,
          icon: const Icon(Icons.add_photo_alternate),
          label: Text(
            _profileImages.isEmpty
                ? 'Upload Profile/Premise Image'
                : 'Image Uploaded',
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue,
            side: const BorderSide(color: Colors.blue),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
        if (_profileImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'To change the image, remove the current one first',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
      ],
    );
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _profileImages.add(image.path);
        });
      }
    } catch (e) {
      _showSnackBar('Failed to pick image: ${e.toString()}');
    }
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

  Widget _buildWorkingHoursReviewSection() {
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
          Row(
            children: [
              const Icon(Icons.schedule, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Working Schedule',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_workingDays.isEmpty)
            Text(
              'No working days selected',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            )
          else
            ..._workingDays.map((day) {
              final hours = _workingHours[day];
              final timeRange = hours != null
                  ? '${hours['start']} - ${hours['end']}'
                  : 'Not set';
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        day,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        timeRange,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              );
            }),
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
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : Text(
                      _currentStep == _totalSteps - 1
                          ? 'Submit Application'
                          : 'Continue',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
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
          if (isValid &&
              _selectedServices.isEmpty &&
              _servicesDescriptionController.text.trim().isEmpty) {
            _showSnackBar(
              'Please select services or provide a detailed description',
            );
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
      case 'nursing license':
        docType = DocumentType.nursingLicense;
        break;
      case 'professional license':
        docType = DocumentType.professionalLicense;
        break;
      case 'professional certification':
        docType = DocumentType.professionalCertification;
        break;
      case 'certification':
        docType = DocumentType.certification;
        break;
      case 'nutrition certification':
        docType = DocumentType.nutritionCertification;
        break;
      case 'caregiver certification':
        docType = DocumentType.caregiverCertification;
        break;
      case 'background check':
        docType = DocumentType.backgroundCheck;
        break;
      case 'valid id':
        docType = DocumentType.validId;
        break;
      case 'insurance certificate':
        docType = DocumentType.insurance;
        break;
      case 'hospital license':
        docType = DocumentType.hospitalLicense;
        break;
      case 'accreditation':
        docType = DocumentType.accreditation;
        break;
      case 'business registration':
        docType = DocumentType.businessRegistration;
        break;
      case 'clinic license':
        docType = DocumentType.clinicLicense;
        break;
      case 'medical permits':
        docType = DocumentType.medicalPermits;
        break;
      case 'pharmacy license':
        docType = DocumentType.pharmacyLicense;
        break;
      case 'pharmacist license':
        docType = DocumentType.pharmacistLicense;
        break;
      case 'laboratory license':
        docType = DocumentType.laboratoryLicense;
        break;
      case 'quality certification':
        docType = DocumentType.qualityCertification;
        break;
      case 'dental license':
        docType = DocumentType.dentalLicense;
        break;
      case 'practice license':
        docType = DocumentType.practiceLicense;
        break;
      case 'business license':
        docType = DocumentType.businessLicense;
        break;
      case 'health permits':
        docType = DocumentType.healthPermits;
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

      // Convert working hours to the format expected by the model
      final Map<String, String> formattedWorkingHours = {};
      for (final day in _workingDays) {
        final hours = _workingHours[day];
        if (hours != null) {
          formattedWorkingHours[day] = '${hours['start']} - ${hours['end']}';
        }
      }

      // Create BusinessPremises if name, phone, and address are provided
      BusinessPremises? premises;
      if (_nameController.text.trim().isNotEmpty &&
          _phoneController.text.trim().isNotEmpty &&
          _addressController.text.trim().isNotEmpty) {
        premises = BusinessPremises(
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          city: 'Nairobi', // Default city, can be updated later
          country: 'Kenya',
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          description: _bioController.text.trim(),
        );
      }

      // Create ProviderProfile
      final providerProfile = ProviderProfile(
        userId: currentUser.id,
        providerType: providerRole,
        status: ProviderStatus.pending, // Pending verification
        specialization: _specializationController.text.trim(),
        servicesOffered: _selectedServices,
        servicesDescription: _servicesDescriptionController.text.trim(),
        profileImages: _profileImages,
        experienceYears: int.tryParse(_experienceController.text),
        bio: _bioController.text.trim(),
        languages: _selectedLanguages,
        insuranceAccepted: _selectedInsurance,
        paymentMethods: _buildPaymentMethodsString(),
        consultationFee: double.tryParse(_consultationFeeController.text),
        workingDays: _workingDays,
        workingHours: formattedWorkingHours,
        verificationDocuments: _uploadedDocuments.map((d) => d.id).toList(),
        premises: premises,
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

      // Send notification to user's inbox
      await MessageService.addMessage(
        senderId: 'system',
        senderName: 'Klinate System',
        content:
            'Your provider application has been submitted successfully! Our team will review your documents and notify you once the verification is complete. Thank you for joining Klinate.',
        type: MessageType.system,
        category: MessageCategory.systemNotification,
      );

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
              'Documents Submitted Successfully!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Your documents have been submitted successfully and will be reviewed by our team. We will notify you once the review is complete.',
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
                  // Close dialog
                  Navigator.of(context).pop();
                  // Close registration screen
                  Navigator.of(context).pop();
                  // Close provider type selection screen
                  Navigator.of(context).pop();
                  // Close become provider screen - returns to profile
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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
