import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/provider_profile.dart';
import '../services/user_service.dart';
import '../services/provider_service.dart';
import '../widgets/role_switcher.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({super.key});

  @override
  State<ProviderDashboardScreen> createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  ProviderProfile? _providerProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProviderProfile();
  }

  Future<void> _loadProviderProfile() async {
    setState(() => _isLoading = true);

    final user = UserService.currentUser;
    if (user != null) {
      final providers = ProviderService.getProvidersByUserId(user.id);
      if (providers.isNotEmpty) {
        // Find provider matching current role
        _providerProfile = providers.firstWhere(
          (p) => p.providerType == user.currentRole,
          orElse: () => providers.first,
        );
      }
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          RoleSwitcher(
            onRoleChanged: (role) {
              setState(() {
                _loadProviderProfile();
              });
              // Navigate based on new role
              if (role == UserRole.patient) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _providerProfile == null
          ? _buildNoProfileView()
          : _buildDashboardContent(),
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
              'No Provider Profile Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Your provider registration is being processed.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: _loadProviderProfile,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 16),
            _buildStatsGrid(),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 16),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (_providerProfile!.status) {
      case ProviderStatus.approved:
        statusColor = Colors.green;
        statusText = 'Verified & Active';
        statusIcon = Icons.verified;
        break;
      case ProviderStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending Verification';
        statusIcon = Icons.pending;
        break;
      case ProviderStatus.rejected:
        statusColor = Colors.red;
        statusText = 'Verification Failed';
        statusIcon = Icons.cancel;
        break;
      case ProviderStatus.suspended:
        statusColor = Colors.grey;
        statusText = 'Account Suspended';
        statusIcon = Icons.block;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withValues(alpha: 0.1),
            statusColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(statusIcon, color: statusColor, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _providerProfile!.providerType.displayName,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                if (_providerProfile!.specialization != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _providerProfile!.specialization!,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
          if (_providerProfile!.isVerified)
            Switch(
              value: _providerProfile!.isAvailable,
              onChanged: (value) async {
                final newStatus = value
                    ? AvailabilityStatus.available
                    : AvailabilityStatus.offline;
                await ProviderService.updateAvailabilityStatus(
                  _providerProfile!.id,
                  newStatus,
                );
                _loadProviderProfile();
              },
              activeColor: Colors.green,
            ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Patients',
          _providerProfile!.totalPatients.toString(),
          Icons.people,
          Colors.blue,
        ),
        _buildStatCard(
          'Appointments',
          _providerProfile!.totalAppointments.toString(),
          Icons.calendar_today,
          Colors.green,
        ),
        _buildStatCard(
          'Rating',
          _providerProfile!.rating.toStringAsFixed(1),
          Icons.star,
          Colors.orange,
        ),
        _buildStatCard(
          'Reviews',
          _providerProfile!.totalReviews.toString(),
          Icons.rate_review,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildActionButton('Edit Profile', Icons.edit, Colors.blue, () {
              // Navigate to edit profile
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Profile - Coming Soon')),
              );
            }),
            _buildActionButton(
              'Manage Premises',
              Icons.business,
              Colors.green,
              () {
                // Navigate to manage premises
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Manage Premises - Coming Soon'),
                  ),
                );
              },
            ),
            _buildActionButton(
              'Availability',
              Icons.schedule,
              Colors.orange,
              () {
                // Navigate to availability settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Availability - Coming Soon')),
                );
              },
            ),
            _buildActionButton(
              'Services',
              Icons.medical_services,
              Colors.purple,
              () {
                // Navigate to services management
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Services - Coming Soon')),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  'No recent activity',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
