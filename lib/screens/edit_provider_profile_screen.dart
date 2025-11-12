import 'package:flutter/material.dart';
import '../models/healthcare_provider.dart';
import '../services/healthcare_provider_service.dart';

class EditProviderProfileScreen extends StatefulWidget {
  final HealthcareProvider provider;

  const EditProviderProfileScreen({super.key, required this.provider});

  @override
  State<EditProviderProfileScreen> createState() =>
      _EditProviderProfileScreenState();
}

class _EditProviderProfileScreenState extends State<EditProviderProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _specializationController;
  late TextEditingController _locationController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _bioController;
  late TextEditingController _consultationFeeController;
  late TextEditingController _openingHoursController;

  List<String> _qualifications = [];
  List<String> _certifications = [];
  List<String> _services = [];
  List<String> _languages = [];
  List<String> _workingDays = [];
  bool _isAvailable = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.provider.name);
    _specializationController = TextEditingController(
      text: widget.provider.specialization,
    );
    _locationController = TextEditingController(text: widget.provider.location);
    _phoneController = TextEditingController(text: widget.provider.phone);
    _emailController = TextEditingController(text: widget.provider.email);
    _bioController = TextEditingController(text: widget.provider.bio);
    _consultationFeeController = TextEditingController(
      text: widget.provider.consultationFee.toString(),
    );
    _openingHoursController = TextEditingController(
      text: widget.provider.openingHours,
    );

    _qualifications = List.from(widget.provider.qualifications);
    _certifications = List.from(widget.provider.certifications);
    _services = List.from(widget.provider.services);
    _languages = List.from(widget.provider.languages);
    _workingDays = List.from(widget.provider.workingDays);
    _isAvailable = widget.provider.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildProfessionalInfoSection(),
              const SizedBox(height: 24),
              _buildQualificationsSection(),
              const SizedBox(height: 24),
              _buildCertificationsSection(),
              const SizedBox(height: 24),
              _buildServicesSection(),
              const SizedBox(height: 24),
              _buildAvailabilitySection(),
              const SizedBox(height: 24),
              _buildLanguagesSection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildSection('Basic Information', [
      TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Full Name',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your name';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _specializationController,
        decoration: const InputDecoration(
          labelText: 'Specialization',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your specialization';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _bioController,
        maxLines: 4,
        decoration: const InputDecoration(
          labelText: 'Bio',
          border: OutlineInputBorder(),
          hintText: 'Tell patients about yourself and your experience...',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your bio';
          }
          return null;
        },
      ),
    ]);
  }

  Widget _buildProfessionalInfoSection() {
    return _buildSection('Professional Information', [
      TextFormField(
        controller: _locationController,
        decoration: const InputDecoration(
          labelText: 'Location/Clinic',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your location';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _phoneController,
        decoration: const InputDecoration(
          labelText: 'Phone Number',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your phone number';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
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
      const SizedBox(height: 16),
      TextFormField(
        controller: _consultationFeeController,
        decoration: const InputDecoration(
          labelText: 'Consultation Fee (KES)',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your consultation fee';
          }
          if (double.tryParse(value) == null) {
            return 'Please enter a valid amount';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _openingHoursController,
        decoration: const InputDecoration(
          labelText: 'Opening Hours',
          border: OutlineInputBorder(),
          hintText: 'e.g., 9:00 AM - 5:00 PM',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your opening hours';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      SwitchListTile(
        title: const Text('Available for Appointments'),
        subtitle: const Text('Toggle your availability status'),
        value: _isAvailable,
        onChanged: (value) {
          setState(() {
            _isAvailable = value;
          });
        },
      ),
    ]);
  }

  Widget _buildQualificationsSection() {
    return _buildListSection(
      'Qualifications',
      _qualifications,
      'Add Qualification',
      'Enter your qualification (e.g., MBChB - University of Nairobi)',
    );
  }

  Widget _buildCertificationsSection() {
    return _buildListSection(
      'Certifications',
      _certifications,
      'Add Certification',
      'Enter your certification',
    );
  }

  Widget _buildServicesSection() {
    return _buildListSection(
      'Services Offered',
      _services,
      'Add Service',
      'Enter a service you offer',
    );
  }

  Widget _buildLanguagesSection() {
    return _buildListSection(
      'Languages',
      _languages,
      'Add Language',
      'Enter a language you speak',
    );
  }

  Widget _buildAvailabilitySection() {
    final allDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return _buildSection('Working Days', [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: allDays.map((day) {
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
            selectedColor: Colors.blue[100],
            checkmarkColor: Colors.blue[800],
          );
        }).toList(),
      ),
    ]);
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildListSection(
    String title,
    List<String> items,
    String addButtonText,
    String hintText,
  ) {
    return _buildSection(title, [
      ...items.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
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
              Expanded(child: Text(item, style: const TextStyle(fontSize: 14))),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () {
                  setState(() {
                    items.removeAt(index);
                  });
                },
              ),
            ],
          ),
        );
      }),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () => _showAddItemDialog(items, addButtonText, hintText),
        icon: const Icon(Icons.add),
        label: Text(addButtonText),
      ),
    ]);
  }

  void _showAddItemDialog(List<String> items, String title, String hintText) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  items.add(controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_qualifications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one qualification'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_services.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one service'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 1));

      final updatedProvider = widget.provider.copyWith(
        name: _nameController.text,
        specialization: _specializationController.text,
        location: _locationController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        bio: _bioController.text,
        consultationFee: double.parse(_consultationFeeController.text),
        openingHours: _openingHoursController.text,
        qualifications: _qualifications,
        certifications: _certifications,
        services: _services,
        languages: _languages,
        workingDays: _workingDays,
        isAvailable: _isAvailable,
      );

      final success = HealthcareProviderService.updateProvider(updatedProvider);

      if (success && mounted) {
        Navigator.pop(context, updatedProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _specializationController.dispose();
    _locationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _consultationFeeController.dispose();
    _openingHoursController.dispose();
    super.dispose();
  }
}
