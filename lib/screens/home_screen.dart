import 'package:flutter/material.dart';
import 'dart:io';
import 'appointments_screen.dart';
import 'category_screen.dart';
import 'inbox_screen.dart';
import '../utils/responsive_utils.dart';
import '../services/user_service.dart';
import 'provider_profile_screen.dart';
import 'facility_profile_screen.dart';
import '../services/healthcare_provider_service.dart';
import '../services/healthcare_facility_service.dart';
import '../services/message_service.dart';
import '../models/healthcare_facility.dart';
import 'wallet_screen.dart';
import 'document_management_screen.dart';
import 'terms_conditions_screen.dart';
import 'privacy_policy_screen.dart';
import 'contact_us_screen.dart';
import 'about_screen.dart';
import 'become_provider_screen.dart';
import 'settings_screen.dart';
import 'faqs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedNavIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MessageService.addListener(_onMessageUpdate);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    MessageService.removeListener(_onMessageUpdate);
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _performSearch(query);
    });
  }

  List<Map<String, dynamic>> _performSearch(String query) {
    final results = <Map<String, dynamic>>[];
    final lowerQuery = query.toLowerCase();

    // Search hospitals and clinics
    final facilities = HealthcareFacilityService.getAllFacilities();
    for (var facility in facilities) {
      if (facility.name.toLowerCase().contains(lowerQuery) ||
          facility.type.name.toLowerCase().contains(lowerQuery) ||
          facility.address.toLowerCase().contains(lowerQuery)) {
        results.add({
          'type': 'facility',
          'name': facility.name,
          'subtitle': facility.type.name,
          'rating': facility.rating.toStringAsFixed(2),
          'data': facility,
        });
      }
    }

    // Search providers
    final providers = HealthcareProviderService.getAllProviders();
    for (var provider in providers) {
      if (provider.name.toLowerCase().contains(lowerQuery) ||
          provider.specialization.toLowerCase().contains(lowerQuery)) {
        results.add({
          'type': 'provider',
          'name': provider.name,
          'subtitle': provider.specialization,
          'rating': provider.rating.toStringAsFixed(2),
          'data': provider,
        });
      }
    }

    return results;
  }

  void _onMessageUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: _buildProfileMenuDrawer(),
      body: _getSelectedScreen(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildProfileMenuDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: SafeArea(
        child: Column(
          children: [
            _buildBecomeProviderBanner(),
            _buildProfileHeader(),
            Expanded(
              child: SingleChildScrollView(child: _buildProfileMenuList()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedNavIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const AppointmentsScreen();
      case 2:
        return const InboxScreen();
      case 3:
        return _buildHomeContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildHomeHeader(),
          _buildSearchBar(),
          Expanded(
            child: _isSearching
                ? _buildSearchResults()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHospitalsSection(),
                        _buildPharmaciesSection(),
                        _buildProvidersSection(),
                        _buildLaboratoriesSection(),
                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            80,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(
        ResponsiveUtils.getResponsiveSpacing(context, 16),
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return Card(
          margin: EdgeInsets.only(
            bottom: ResponsiveUtils.getResponsiveSpacing(context, 12),
          ),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey[300]!),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(
              ResponsiveUtils.getResponsiveSpacing(context, 12),
            ),
            leading: CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Icon(
                result['type'] == 'facility'
                    ? Icons.local_hospital
                    : Icons.person,
                color: Colors.grey[700],
              ),
            ),
            title: Text(
              result['name'],
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  result['subtitle'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.black),
                    const SizedBox(width: 4),
                    Text(
                      result['rating'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (result['type'] == 'facility') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FacilityProfileScreen(facilityId: result['data'].id),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProviderProfileScreen(providerId: result['data'].id),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
        vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search doctors, hospitals, clinics, pharmacies...',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[600],
              size: ResponsiveUtils.isSmallScreen(context) ? 20 : 24,
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
              vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveUtils.getResponsiveSpacing(context, 20),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                child: Text(
                  'II',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 2),
                  ),
                  child: Icon(Icons.camera_alt, size: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UserService.currentUser?.name ?? 'User',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      24,
                    ),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  UserService.currentUser?.email ?? 'user@example.com',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      14,
                    ),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBecomeProviderBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BecomeProviderScreen()),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
          vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
        ),
        padding: EdgeInsets.all(
          ResponsiveUtils.getResponsiveSpacing(context, 16),
        ),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Row(
          children: [
            Icon(Icons.medical_services, color: Colors.blue[700], size: 24),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Become a Healthcare Provider',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        16,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  Text(
                    'Join our network of professionals',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        12,
                      ),
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuList() {
    return Column(
      children: [
        _buildProfileMenuItem(
          icon: Icons.home,
          title: 'Home',
          onTap: () {
            Navigator.of(context).pop(); // Close the drawer
            setState(() {
              _selectedNavIndex = 0;
            });
          },
        ),
        _buildProfileMenuItem(
          icon: Icons.account_balance_wallet,
          title: 'Wallet',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WalletScreen()),
            );
          },
        ),
        _buildProfileMenuItem(
          icon: Icons.medical_information,
          title: 'Medical Records',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DocumentManagementScreen(),
              ),
            );
          },
        ),
        _buildProfileMenuItem(
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
        _buildProfileMenuItem(
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
        _buildProfileMenuItem(
          icon: Icons.help,
          title: 'FAQ',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FAQsScreen()),
            );
          },
        ),
        _buildProfileMenuItem(
          icon: Icons.contact_support,
          title: 'Contact Us',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ContactUsScreen()),
            );
          },
        ),
        _buildProfileMenuItem(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
            // Refresh the screen when returning from settings
            if (mounted) {
              setState(() {});
            }
          },
        ),
        _buildProfileMenuItem(
          icon: Icons.info,
          title: 'About',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          },
        ),
        _buildProfileMenuItem(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {
            _showLogoutDialog();
          },
          isLogout: true,
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 80)),
      ],
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getResponsiveSpacing(context, 20),
          vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red : Colors.black,
              size: ResponsiveUtils.isSmallScreen(context) ? 20 : 24,
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
                  color: isLogout ? Colors.red : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: ResponsiveUtils.isSmallScreen(context) ? 18 : 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
        vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Klinate',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 32),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                  size: ResponsiveUtils.isSmallScreen(context) ? 22 : 24,
                ),
                onPressed: () {
                  setState(() {
                    _selectedNavIndex = 2; // Navigate to Inbox
                  });
                },
              ),
              if (MessageService.getUnreadCount() > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '${MessageService.getUnreadCount()}',
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Map<String, String>> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
            vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ResponsiveUtils.safeText(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      18,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToCategory(title, items),
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.getResponsiveSpacing(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: ResponsiveUtils.isSmallScreen(context) ? 18 : 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: ResponsiveUtils.isSmallScreen(context) ? 190 : 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
            ),
            itemCount: items.length > 8 ? 8 : items.length,
            itemBuilder: (context, index) {
              return _buildHealthcareCard(
                title: items[index]['title']!,
                rating: items[index]['rating']!,
                category: title,
                imageUrl: items[index]['imageUrl'],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHealthcareCard({
    required String title,
    required String rating,
    required String category,
    String? imageUrl,
  }) {
    IconData getIcon() {
      if (category.contains('Hospital')) return Icons.local_hospital;
      if (category.contains('Pharmacies')) return Icons.local_pharmacy;
      if (category.contains('Doctors')) return Icons.person;
      if (category.contains('Laboratories')) return Icons.science;
      return Icons.medical_services;
    }

    return GestureDetector(
      onTap: () => _navigateToProviderProfile(title, category),
      child: Container(
        width: 160,
        margin: EdgeInsets.only(
          right: ResponsiveUtils.getResponsiveSpacing(context, 16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: ResponsiveUtils.isSmallScreen(context) ? 110 : 120,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: _buildFacilityImage(imageUrl, getIcon()),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
            Flexible(
              child: ResponsiveUtils.safeText(
                title,
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                maxLines: 2,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 2)),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: ResponsiveUtils.isSmallScreen(context) ? 12 : 14,
                  color: Colors.black,
                ),
                SizedBox(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 2),
                ),
                Flexible(
                  child: Text(
                    rating,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        13,
                      ),
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilityImage(String? imageUrl, IconData defaultIcon) {
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        imageUrl != 'https://via.placeholder.com/200') {
      if (imageUrl.startsWith('/')) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.file(
            File(imageUrl),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(defaultIcon, size: 80, color: Colors.grey[600]),
              );
            },
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(defaultIcon, size: 80, color: Colors.grey[600]),
              );
            },
          ),
        );
      }
    } else {
      return Center(
        child: Icon(defaultIcon, size: 80, color: Colors.grey[600]),
      );
    }
  }

  void _navigateToProviderProfile(String title, String category) {
    if (category.contains('Doctors')) {
      String providerName = title;
      final providers = HealthcareProviderService.getAllProviders();
      final provider = providers.firstWhere(
        (p) => p.name.toLowerCase().contains(
          providerName.toLowerCase().split(' - ')[0],
        ),
        orElse: () => providers.first,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProviderProfileScreen(providerId: provider.id),
        ),
      );
    } else {
      final facility = HealthcareFacilityService.getFacilityByName(title);
      if (facility != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FacilityProfileScreen(facilityId: facility.id),
          ),
        );
      }
    }
  }

  void _navigateToCategory(String title, List<Map<String, String>> items) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CategoryScreen(title: title, items: items, category: title),
      ),
    );
  }

  Widget _buildProvidersSection() {
    final providers = HealthcareProviderService.getAllProviders();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
            vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ResponsiveUtils.safeText(
                  'Doctors, Clinicians, Nutritionists and Physiotherapists',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      18,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToCategory(
                  'Doctors, Clinicians, Nutritionists and Physiotherapists',
                  providers
                      .map(
                        (p) => {
                          'title': '${p.name} - ${p.specialization}',
                          'rating': p.rating.toStringAsFixed(1),
                          'location': p.location,
                        },
                      )
                      .toList(),
                ),
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.getResponsiveSpacing(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: ResponsiveUtils.isSmallScreen(context) ? 18 : 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getResponsiveSpacing(context, 16),
            ),
            itemCount: providers.length > 8 ? 8 : providers.length,
            itemBuilder: (context, index) {
              final provider = providers[index];
              return _buildProviderCard(provider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProviderCard(provider) {
    return GestureDetector(
      onTap: () => _navigateToProviderProfile(provider.name, 'Doctors'),
      child: Container(
        width: 160,
        margin: EdgeInsets.only(
          right: ResponsiveUtils.getResponsiveSpacing(context, 16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: _buildProviderImage(provider),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 6)),
            ResponsiveUtils.safeText(
              provider.name,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 15),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              maxLines: 1,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 1)),
            ResponsiveUtils.safeText(
              provider.specialization,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
              maxLines: 1,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 2)),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: ResponsiveUtils.isSmallScreen(context) ? 12 : 14,
                  color: Colors.black,
                ),
                SizedBox(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 2),
                ),
                Flexible(
                  child: Text(
                    provider.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getResponsiveFontSize(
                        context,
                        15,
                      ),
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderImage(provider) {
    if (provider.profileImageUrl != null &&
        provider.profileImageUrl != 'https://via.placeholder.com/200' &&
        provider.profileImageUrl!.startsWith('/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(provider.profileImageUrl!),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultProviderAvatar(provider);
          },
        ),
      );
    } else if (provider.profileImageUrl != null &&
        provider.profileImageUrl != 'https://via.placeholder.com/200') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          provider.profileImageUrl!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultProviderAvatar(provider);
          },
        ),
      );
    } else {
      return _buildDefaultProviderAvatar(provider);
    }
  }

  Widget _buildDefaultProviderAvatar(provider) {
    return Center(
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.blue[100],
        child: Text(
          provider.name.split(' ').map((e) => e[0]).take(2).join(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: ResponsiveUtils.getResponsiveSpacing(context, 8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.calendar_today, 'Appointments', 1),
              _buildNavItem(Icons.inbox, 'Inbox', 2),
              _buildNavItem(Icons.person, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 3) {
          // Profile - open drawer
          _scaffoldKey.currentState?.openEndDrawer();
        } else {
          setState(() {
            _selectedNavIndex = index;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.red : Colors.grey[600],
            size: ResponsiveUtils.isSmallScreen(context) ? 22 : 26,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.grey[600],
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 11),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalsSection() {
    final hospitals = HealthcareFacilityService.getFacilitiesByType(
      FacilityType.hospital,
    );
    final clinics = HealthcareFacilityService.getFacilitiesByType(
      FacilityType.clinic,
    );
    final allHospitalsAndClinics = [...hospitals, ...clinics];

    return _buildSection(
      title: 'Hospitals and Clinics',
      items: allHospitalsAndClinics
          .map(
            (facility) => {
              'title': facility.name,
              'rating': facility.rating.toStringAsFixed(2),
              'imageUrl': facility.imageUrl,
              'location': (facility.location['county'] ?? '').toString(),
            },
          )
          .toList(),
    );
  }

  Widget _buildPharmaciesSection() {
    final pharmacies = HealthcareFacilityService.getFacilitiesByType(
      FacilityType.pharmacy,
    );

    return _buildSection(
      title: 'Pharmacies',
      items: pharmacies
          .map(
            (facility) => {
              'title': facility.name,
              'rating': facility.rating.toStringAsFixed(2),
              'imageUrl': facility.imageUrl,
              'location': (facility.location['county'] ?? '').toString(),
            },
          )
          .toList(),
    );
  }

  Widget _buildLaboratoriesSection() {
    final laboratories = HealthcareFacilityService.getFacilitiesByType(
      FacilityType.laboratory,
    );

    return _buildSection(
      title: 'Laboratories',
      items: laboratories
          .map(
            (facility) => {
              'title': facility.name,
              'rating': facility.rating.toStringAsFixed(2),
              'imageUrl': facility.imageUrl,
              'location': (facility.location['county'] ?? '').toString(),
            },
          )
          .toList(),
    );
  }
}
