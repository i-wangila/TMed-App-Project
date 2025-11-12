import 'package:flutter/material.dart';
import 'appointments_screen.dart';
import 'profile_drawer.dart';
import 'inbox_screen.dart';

import 'provider_profile_screen.dart';
import 'facility_profile_screen.dart';
import '../services/healthcare_provider_service.dart';
import '../services/healthcare_facility_service.dart';
import '../services/message_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNavIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: const ProfileDrawer(),
      body: _getSelectedScreen(),
      bottomNavigationBar: _buildBottomNavBar(),
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
        return _buildHomeContent(); // Keep showing home when profile is selected
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        children: [
          _buildHomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    title: 'Hospitals and Clinics',
                    items: [
                      {'title': 'Nairobi Hospital', 'rating': '4.93'},
                      {
                        'title': 'Aga Khan University Hospital',
                        'rating': '4.85',
                      },
                      {'title': 'Kenyatta National Hospital', 'rating': '4.72'},
                      {'title': 'MP Shah Hospital', 'rating': '4.68'},
                      {
                        'title': 'Gertrudes Children Hospital',
                        'rating': '4.91',
                      },
                      {'title': 'Karen Hospital', 'rating': '4.78'},
                      {'title': 'Mater Hospital', 'rating': '4.65'},
                      {'title': 'Coptic Hospital', 'rating': '4.82'},
                      {'title': 'Avenue Healthcare', 'rating': '4.76'},
                      {'title': 'Parklands Clinic', 'rating': '4.69'},
                    ],
                  ),
                  _buildSection(
                    title: 'Pharmacies',
                    items: [
                      {'title': 'Goodlife Pharmacy', 'rating': '4.91'},
                      {'title': 'Haltons Pharmacy', 'rating': '4.94'},
                      {'title': 'Mediplus Pharmacy', 'rating': '4.78'},
                      {'title': 'Carrefour Pharmacy', 'rating': '4.65'},
                      {'title': 'Dawa Life Pharmacy', 'rating': '4.82'},
                      {'title': 'Boots Pharmacy', 'rating': '4.77'},
                      {'title': 'Alpha Pharmacy', 'rating': '4.83'},
                      {'title': 'Wellness Pharmacy', 'rating': '4.71'},
                      {'title': 'City Pharmacy', 'rating': '4.66'},
                      {'title': 'Health Plus Pharmacy', 'rating': '4.89'},
                    ],
                  ),
                  _buildProvidersSection(),
                  _buildSection(
                    title: 'Laboratories',
                    items: [
                      {'title': 'Lancet Kenya', 'rating': '4.81'},
                      {'title': 'Pathologists Lancet Kenya', 'rating': '5.0'},
                      {'title': 'Metropol Laboratory', 'rating': '4.73'},
                      {'title': 'Ampath Laboratory', 'rating': '4.67'},
                      {'title': 'Quest Laboratory', 'rating': '4.84'},
                      {'title': 'Medlab East Africa', 'rating': '4.79'},
                      {'title': 'Diagnostic Laboratory', 'rating': '4.72'},
                      {'title': 'Healthline Laboratory', 'rating': '4.85'},
                      {'title': 'Precision Lab Services', 'rating': '4.76'},
                      {'title': 'Advanced Diagnostics', 'rating': '4.91'},
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TMed',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InboxScreen(),
                    ),
                  );
                },
              ),
              if (MessageService.getUnreadCount() > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${MessageService.getUnreadCount()}',
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
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _navigateToCategory(title, items),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 1),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return _buildHealthcareCard(
                title: items[index]['title']!,
                rating: items[index]['rating']!,
                category: title,
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
        width: 300,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!, width: 1),
                  ),
                  child: Center(
                    child: Icon(getIcon(), size: 80, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.black),
                const SizedBox(width: 2),
                Text(
                  rating,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToProviderProfile(String title, String category) {
    // For doctors, navigate to their profile
    if (category.contains('Doctors')) {
      // Extract provider name and find matching provider
      String providerName = title;
      final providers = HealthcareProviderService.getAllProviders();
      final provider = providers.firstWhere(
        (p) => p.name.toLowerCase().contains(
          providerName.toLowerCase().split(' - ')[0],
        ),
        orElse: () => providers.first, // Fallback to first provider
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProviderProfileScreen(providerId: provider.id),
        ),
      );
    } else {
      // For facilities (hospitals, pharmacies, labs), navigate to facility profile
      final facility = HealthcareFacilityService.getFacilityByName(title);

      if (facility != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                FacilityProfileScreen(facilityId: facility.id),
          ),
        );
      } else {
        // Fallback: show message or navigate to category detail
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$title profile coming soon'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
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
          // Open profile drawer for profile tab
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
            size: 26,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.grey[600],
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCategory(String title, List<Map<String, String>> items) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: items
              .map(
                (item) => ListTile(
                  title: Text(item['title'] ?? ''),
                  subtitle: Text(item['subtitle'] ?? ''),
                  onTap: () => Navigator.pop(context),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersSection() {
    final providers = HealthcareProviderService.getAllProviders();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Doctors, Clinicians, Nutritionists and Physiotherapists',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
                        },
                      )
                      .toList(),
                ),
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: providers.length,
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
        margin: const EdgeInsets.only(right: 16),
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
                  child: Center(
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        provider.name
                            .split(' ')
                            .map((e) => e[0])
                            .take(2)
                            .join(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${provider.name} - ${provider.specialization}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.star, size: 14, color: Colors.black),
                const SizedBox(width: 2),
                Text(
                  provider.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
