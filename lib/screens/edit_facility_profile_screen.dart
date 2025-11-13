import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/healthcare_facility.dart';
import '../services/healthcare_facility_service.dart';

class EditFacilityProfileScreen extends StatefulWidget {
  final HealthcareFacility facility;

  const EditFacilityProfileScreen({super.key, required this.facility});

  @override
  State<EditFacilityProfileScreen> createState() =>
      _EditFacilityProfileScreenState();
}

class _EditFacilityProfileScreenState extends State<EditFacilityProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _descriptionController;
  late TextEditingController _openingHoursController;

  List<String> _services = [];
  List<String> _certifications = [];
  List<String> _departments = [];
  bool _isEmergencyAvailable = false;
  bool _isLoading = false;

  // Profile Image
  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.facility.name);
    _addressController = TextEditingController(text: widget.facility.address);
    _phoneController = TextEditingController(text: widget.facility.phone);
    _emailController = TextEditingController(text: widget.facility.email);
    _websiteController = TextEditingController(text: widget.facility.website);
    _descriptionController = TextEditingController(
      text: widget.facility.description,
    );
    _openingHoursController = TextEditingController(
      text: 'Mon-Fri: 8:00 AM - 6:00 PM',
    );

    _services = List.from(widget.facility.services);
    _certifications = List.from(widget.facility.certifications);
    _departments = List.from(widget.facility.departments);
    _isEmergencyAvailable = widget.facility.emergencyServices;
    _profileImagePath = widget.facility.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Facility Profile'),
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
              _buildProfileImageSection(),
              const SizedBox(height: 24),
              _buildContactInfoSection(),
              const SizedBox(height: 24),
              _buildServicesSection(),
              const SizedBox(height: 24),
              _buildDepartmentsSection(),
              const SizedBox(height: 24),
              _buildCertificationsSection(),
              const SizedBox(height: 24),
              _buildEmergencySection(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildBasicInfoSection() {
    return _buildSection('Basic Information', [
      TextFormField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Facility Name',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter facility name';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter description';
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
          hintText: 'e.g., Mon-Fri: 8:00 AM - 6:00 PM',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter opening hours';
          }
          return null;
        },
      ),
    ]);
  }

  Widget _buildProfileImageSection() {
    return _buildSection('Facility Logo', [
      Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickProfileImage,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: _buildCurrentImage(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _pickProfileImage,
                  icon: const Icon(Icons.edit),
                  label: const Text('Change Logo'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    foregroundColor: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: _removeProfileImage,
                  icon: const Icon(Icons.delete),
                  label: const Text('Remove'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildCurrentImage() {
    if (_profileImagePath != null && _profileImagePath!.startsWith('/')) {
      // Local file path
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          File(_profileImagePath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        ),
      );
    } else if (_profileImagePath != null &&
        _profileImagePath != 'https://via.placeholder.com/200') {
      // Network image
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          _profileImagePath!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultAvatar();
          },
        ),
      );
    } else {
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            'Tap to upload logo',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return _buildSection('Contact Information', [
      TextFormField(
        controller: _addressController,
        decoration: const InputDecoration(
          labelText: 'Address',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter address';
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter phone number';
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter email';
          }
          return null;
        },
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _websiteController,
        decoration: const InputDecoration(
          labelText: 'Website (Optional)',
          border: OutlineInputBorder(),
        ),
      ),
    ]);
  }

  Widget _buildServicesSection() {
    return _buildSection('Services Offered', [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _services.map((service) {
          return Chip(
            label: Text(service),
            onDeleted: () {
              setState(() {
                _services.remove(service);
              });
            },
          );
        }).toList(),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Add Service',
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty && !_services.contains(value)) {
                  setState(() {
                    _services.add(value);
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // Add service logic handled by onFieldSubmitted
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ]);
  }

  Widget _buildDepartmentsSection() {
    return _buildSection('Departments', [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _departments.map((department) {
          return Chip(
            label: Text(department),
            onDeleted: () {
              setState(() {
                _departments.remove(department);
              });
            },
          );
        }).toList(),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Add Department',
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty && !_departments.contains(value)) {
                  setState(() {
                    _departments.add(value);
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // Add department logic handled by onFieldSubmitted
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ]);
  }

  Widget _buildCertificationsSection() {
    return _buildSection('Certifications', [
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _certifications.map((certification) {
          return Chip(
            label: Text(certification),
            onDeleted: () {
              setState(() {
                _certifications.remove(certification);
              });
            },
          );
        }).toList(),
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Add Certification',
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty && !_certifications.contains(value)) {
                  setState(() {
                    _certifications.add(value);
                  });
                }
              },
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              // Add certification logic handled by onFieldSubmitted
            },
            child: const Text('Add'),
          ),
        ],
      ),
    ]);
  }

  Widget _buildEmergencySection() {
    return _buildSection('Emergency Services', [
      SwitchListTile(
        title: const Text('Emergency Services Available'),
        subtitle: const Text(
          'Toggle if your facility provides emergency services',
        ),
        value: _isEmergencyAvailable,
        onChanged: (value) {
          setState(() {
            _isEmergencyAvailable = value;
          });
        },
      ),
    ]);
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Facility logo updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeProfileImage() {
    setState(() {
      _profileImagePath = 'https://via.placeholder.com/200';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Facility logo removed'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
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

      final updatedFacility = widget.facility.copyWith(
        name: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        website: _websiteController.text,
        description: _descriptionController.text,
        services: _services,
        certifications: _certifications,
        departments: _departments,
        emergencyServices: _isEmergencyAvailable,
        imageUrl: _profileImagePath,
      );

      final success = await HealthcareFacilityService.updateFacility(
        updatedFacility,
      );

      if (success && mounted) {
        Navigator.pop(context, updatedFacility);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Facility profile updated successfully'),
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
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _openingHoursController.dispose();
    super.dispose();
  }
}
