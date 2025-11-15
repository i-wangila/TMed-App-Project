import 'package:flutter/material.dart';
import '../models/provider_profile.dart';
import '../models/user_profile.dart';
import '../services/user_service.dart';
import '../services/provider_service.dart';
import '../services/message_service.dart';
import 'provider_analytics_screen.dart';
import 'provider_appointments_screen.dart';
import 'provider_patients_screen.dart';
import 'provider_inbox_screen.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  State<ProviderDashboardScreen> createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  ProviderProfile? _providerProfile;
  bool _isLoading = true;
  int _selectedNavIndex = 0; // Default to Patients tab
  DateTime? _lastHomeTap;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProviderProfile();
    MessageService.addListener(_onMessageUpdate);
    _updateUnreadCount();
  }

  @override
  void dispose() {
    MessageService.removeListener(_onMessageUpdate);
    super.dispose();
  }

  void _onMessageUpdate() {
    if (mounted) {
      _updateUnreadCount();
    }
  }

  void _updateUnreadCount() {
    setState(() {
      _unreadCount = MessageService.getUnreadCount();
    });
  }

  Future<void> _loadProviderProfile() async {
    setState(() => _isLoading = true);

    final user = UserService.currentUser;
    if (user != null) {
      final providers = ProviderService.getProvidersByUserId(user.id);
      if (providers.isNotEmpty) {
        _providerProfile = providers.firstWhere(
          (p) => p.providerType == user.currentRole,
          orElse: () => providers.first,
        );
      }
    }

    setState(() => _isLoading = false);
  }

  void _handleHomeTap() {
    final now = DateTime.now();

    // Check if this is a double tap (within 500ms)
    if (_lastHomeTap != null &&
        now.difference(_lastHomeTap!) < const Duration(milliseconds: 500)) {
      // Double tap detected - exit to patient home
      UserService.switchRole(UserRole.patient);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Single tap - go to Patient tab if not already there
      if (_selectedNavIndex != 0) {
        setState(() {
          _selectedNavIndex = 0;
        });
      }
    }

    // Update last tap time
    _lastHomeTap = now;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildTopNavBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _providerProfile == null
                ? _buildNoProfileView()
                : _selectedNavIndex == 0
                ? const ProviderPatientsScreen()
                : _selectedNavIndex == 1
                ? const ProviderInboxScreen()
                : _selectedNavIndex == 2
                ? const ProviderAppointmentsScreen()
                : _selectedNavIndex == 3
                ? const ProviderAnalyticsScreen()
                : const ProviderPatientsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          // Home button with double-tap functionality (moved to left)
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: _handleHomeTap,
              icon: const Icon(Icons.home, color: Colors.black, size: 20),
              tooltip: 'Double tap to exit Business Dashboard',
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ),
          // Notification icon with badge (moved next to home)
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() => _selectedNavIndex = 1); // Go to Inbox
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                    size: 20,
                  ),
                  tooltip: 'Notifications',
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ),
              if (_unreadCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      _unreadCount > 99 ? '99+' : _unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
          // Navigation Items (with reduced spacing)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildNavItem('Patient', 0),
                  _buildNavItem('Inbox', 1),
                  _buildNavItem('Appointments', 2),
                  _buildNavItem('Analytics', 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, int index, {bool hasDropdown = false}) {
    final isSelected = _selectedNavIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey[700],
              ),
            ),
            if (hasDropdown) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.grey[700],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoProfileView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'No Business Account Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Your business account registration is being processed.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
