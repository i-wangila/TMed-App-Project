import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'wallet_screen.dart';
import 'profile_edit_screen.dart';
import 'medical_records_screen.dart';
import 'prescriptions_screen.dart';
import 'terms_conditions_screen.dart';
import 'privacy_policy_screen.dart';
import 'faqs_screen.dart';
import 'contact_us_screen.dart';
import 'settings_screen.dart';

import 'onboarding_screen.dart';
import 'become_provider_screen.dart';
import '../services/user_service.dart';

class ProfileDrawer extends StatefulWidget {
  const ProfileDrawer({super.key});

  @override
  State<ProfileDrawer> createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  String? _profileImageUrl;
  bool _hasCustomImage = false;
  File? _profileImageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              _buildBecomeProviderCard(context),
              _buildProfileHeader(context),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildMenuItem(
                      icon: Icons.home,
                      title: 'Home',
                      onTap: () => Navigator.pop(context),
                    ),
                    _buildMenuItem(
                      icon: Icons.person,
                      title: 'My Accounts',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileEditScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.calendar_today,
                      title: 'My Bookings',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.account_balance_wallet,
                      title: 'Wallet',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WalletScreen(),
                          ),
                        );
                      },
                    ),

                    _buildMenuItem(
                      icon: Icons.medical_services,
                      title: 'Medical Records',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MedicalRecordsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.description,
                      title: 'Prescription Reports',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrescriptionsScreen(),
                          ),
                        );
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                        height: 1,
                      ),
                    ),
                    _buildMenuItem(
                      icon: Icons.article,
                      title: 'Terms & Conditions',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsConditionsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.help,
                      title: 'Faqs',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FaqsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.contact_mail,
                      title: 'Contact Us',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ContactUsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Divider(
                        color: Colors.grey[300],
                        thickness: 1,
                        height: 1,
                      ),
                    ),
                    _buildLogoutMenuItem(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                backgroundImage: _getProfileImage(),
                child: !_hasCustomImage
                    ? Text(
                        _getInitials(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImagePickerDialog,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UserService.currentUser?.name ?? 'Guest User',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  UserService.currentUser?.email ?? 'Not signed in',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      dense: true,
    );
  }

  Widget _buildBecomeProviderCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BecomeProviderScreen()),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.blue[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.medical_services,
                color: Colors.blue[700],
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Become a Healthcare Provider',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Join our network of professionals',
                    style: TextStyle(fontSize: 11, color: Colors.blue[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutMenuItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red, size: 24),
      title: const Text(
        'Logout',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () => _showLogoutDialog(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      dense: true,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Logout',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close drawer

              // Sign out user
              await UserService.signOut();

              // Navigate to onboarding screen and clear all previous routes
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                  (route) => false,
                );
              }
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials() {
    final name = UserService.currentUser?.name;
    if (name == null || name.isEmpty) return 'U';

    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else {
      return parts[0][0].toUpperCase();
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Profile Picture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildImageSourceOptions(),
            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 10),
            const Text(
              'Or choose from presets:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            _buildAvatarOptions(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSourceOption(
          icon: Icons.camera_alt,
          label: 'Camera',
          onTap: () => _pickImage(ImageSource.camera),
        ),
        _buildSourceOption(
          icon: Icons.photo_library,
          label: 'Gallery',
          onTap: () => _pickImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.black),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarOptions() {
    final avatarOptions = [
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&h=150&fit=crop&crop=face',
    ];

    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: avatarOptions.map((imageUrl) {
            final isSelected = _profileImageUrl == imageUrl;
            return GestureDetector(
              onTap: () => _selectAvatar(imageUrl),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        if (_hasCustomImage)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: _removeImage,
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Remove Picture',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
      ],
    );
  }

  void _selectAvatar(String imageUrl) {
    Navigator.pop(context);
    setState(() {
      _profileImageUrl = imageUrl;
      _hasCustomImage = true;
    });
    _showSnackBar('Profile picture updated successfully');
  }

  void _removeImage() {
    Navigator.pop(context);
    setState(() {
      _profileImageUrl = null;
      _hasCustomImage = false;
    });
    _showSnackBar('Profile picture removed');
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final navigator = Navigator.of(context);
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null && mounted) {
        navigator.pop(); // Close bottom sheet

        // Save image to app directory
        final File imageFile = File(image.path);
        final File savedImage = await _saveImageToAppDirectory(imageFile);

        if (mounted) {
          setState(() {
            _profileImageFile = savedImage;
            _profileImageUrl = null; // Clear network image
            _hasCustomImage = true;
          });

          _showSnackBar('Profile picture updated successfully');
        }
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to pick image. Please try again.');
      }
    }
  }

  Future<File> _saveImageToAppDirectory(File image) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName =
        'profile_drawer_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String filePath = '${appDir.path}/$fileName';

    return await image.copy(filePath);
  }

  ImageProvider? _getProfileImage() {
    if (_profileImageFile != null) {
      return FileImage(_profileImageFile!);
    } else if (_profileImageUrl != null) {
      return NetworkImage(_profileImageUrl!);
    }
    return null;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
