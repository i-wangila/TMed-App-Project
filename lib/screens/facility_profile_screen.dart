import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../models/healthcare_facility.dart';
import '../models/review.dart';
import '../services/healthcare_facility_service.dart';
import '../services/review_service.dart';
import 'provider_reviews_screen.dart';
import 'provider_reviews_list_screen.dart';
import 'rate_any_provider_screen.dart';

class FacilityProfileScreen extends StatefulWidget {
  final String facilityId;

  const FacilityProfileScreen({super.key, required this.facilityId});

  @override
  State<FacilityProfileScreen> createState() => _FacilityProfileScreenState();
}

class _FacilityProfileScreenState extends State<FacilityProfileScreen> {
  HealthcareFacility? facility;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFacility();
  }

  void _loadFacility() {
    setState(() {
      facility = HealthcareFacilityService.getFacilityById(widget.facilityId);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (facility == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Facility Not Found'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: const Center(child: Text('Facility not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildBasicInfo(),
                _buildContactInfo(),
                _buildWorkingHours(),
                _buildServicesSection(),
                if (facility!.departments.isNotEmpty)
                  _buildDepartmentsSection(),
                if (facility!.specialties.isNotEmpty)
                  _buildSpecialtiesSection(),
                _buildReviewsSection(),
                _buildFacilitiesSection(),
                _buildInsuranceSection(),
                _buildCertificationsSection(),
                if (facility!.contactPersons.isNotEmpty)
                  _buildContactPersonsSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildActionButtons(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      actions: [
        IconButton(
          icon: Icon(
            facility!.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: facility!.isFavorite ? Colors.red : Colors.black,
          ),
          onPressed: () {
            setState(() {
              HealthcareFacilityService.toggleFavorite(facility!.id);
              facility = HealthcareFacilityService.getFacilityById(
                facility!.id,
              );
            });
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue[50]!, Colors.white],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _getFacilityIcon(),
                  size: 60,
                  color: _getFacilityColor(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                facility!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                facility!.typeDisplayName,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${facility!.rating}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProviderReviewsScreen(
                            providerId: facility!.id,
                            providerName: facility!.name,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      '(${facility!.reviewCount} reviews)',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[600],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return _buildSection(
      'About',
      Icons.info,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            facility!.description,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (facility!.establishedYear.isNotEmpty)
            _buildInfoRow(
              Icons.calendar_today,
              'Established',
              facility!.establishedYear,
            ),
          if (facility!.bedCapacity > 0) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.bed,
              'Bed Capacity',
              '${facility!.bedCapacity} beds',
            ),
          ],
          const SizedBox(height: 12),
          _buildInfoRow(
            facility!.emergencyServices ? Icons.local_hospital : Icons.schedule,
            'Emergency Services',
            facility!.emergencyServices ? 'Available 24/7' : 'Not Available',
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return _buildSection(
      'Contact Information',
      Icons.contact_phone,
      Column(
        children: [
          _buildContactRow(
            Icons.location_on,
            'Address',
            facility!.address,
            () => _openMaps(),
          ),
          const SizedBox(height: 16),
          _buildContactRow(
            Icons.phone,
            'Phone',
            facility!.phone,
            () => _makeCall(facility!.phone),
          ),
          const SizedBox(height: 16),
          _buildContactRow(
            Icons.email,
            'Email',
            facility!.email,
            () => _sendEmail(facility!.email),
          ),
          if (facility!.website.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildContactRow(
              Icons.web,
              'Website',
              facility!.website,
              () => _openWebsite(facility!.website),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkingHours() {
    return _buildSection(
      'Working Hours',
      Icons.access_time,
      Column(
        children: facility!.workingHours.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  entry.value,
                  style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServicesSection() {
    return _buildSection(
      'Services Offered',
      Icons.medical_services,
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: facility!.services.map((service) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Text(
              service,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDepartmentsSection() {
    return _buildSection(
      'Departments',
      Icons.domain,
      Column(
        children: facility!.departments.map((department) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.green[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    department,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.green[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    return _buildSection(
      'Specialties',
      Icons.star_border,
      Column(
        children: facility!.specialties.map((specialty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    return _buildSection(
      'Facilities & Equipment',
      Icons.build,
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: facility!.facilities.map((facilityItem) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.purple[200]!),
            ),
            child: Text(
              facilityItem,
              style: TextStyle(
                fontSize: 14,
                color: Colors.purple[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInsuranceSection() {
    return _buildSection(
      'Insurance Accepted',
      Icons.security,
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: facility!.insuranceAccepted.map((insurance) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.teal[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.teal[200]!),
            ),
            child: Text(
              insurance,
              style: TextStyle(
                fontSize: 14,
                color: Colors.teal[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCertificationsSection() {
    return _buildSection(
      'Certifications & Accreditations',
      Icons.verified,
      Column(
        children: facility!.certifications.map((certification) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.verified, color: Colors.amber[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    certification,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.amber[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactPersonsSection() {
    return _buildSection(
      'Key Contacts',
      Icons.people,
      Column(
        children: facility!.contactPersons.map((person) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
                  person['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  person['position'],
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(person['phone']),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.email, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(person['email']),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final reviews = ReviewService.getReviewsByProvider(facility!.id);
    final providerRating = ReviewService.getProviderRating(facility!.id);

    return Container(
      margin: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, size: 22, color: Colors.black),
                  const SizedBox(width: 8),
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RateAnyProviderScreen(
                            providerId: facility!.id,
                            providerName: facility!.name,
                            providerType: _getFacilityProviderType(
                              facility!.type,
                            ),
                            description:
                                'Rate this ${facility!.typeDisplayName.toLowerCase()}',
                          ),
                        ),
                      );
                      _loadFacility();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit, size: 14, color: Colors.blue[600]),
                          const SizedBox(width: 4),
                          Text(
                            'Write Review',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (reviews.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProviderReviewsListScreen(
                              providerId: facility!.id,
                              providerName: facility!.name,
                              providerType: _getFacilityProviderType(
                                facility!.type,
                              ),
                            ),
                          ),
                        );
                        _loadFacility();
                      },
                      child: Text(
                        'View all',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (reviews.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'No reviews yet',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Be the first to leave a review!',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Rating summary
            Row(
              children: [
                Text(
                  providerRating.averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < providerRating.averageRating.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber[600],
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${providerRating.totalReviews} reviews',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Recent reviews (show up to 2)
            ...reviews.take(2).map((review) => _buildReviewCard(review)),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blue[100],
                child: Text(
                  review.patientName.split(' ').map((e) => e[0]).take(2).join(),
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.patientName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('MMM dd, yyyy').format(review.createdAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber[600],
                    size: 14,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blue[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.open_in_new, size: 16, color: Colors.grey[500]),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _makeCall(facility!.phone),
              icon: const Icon(Icons.phone),
              label: const Text('Call'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _openMaps(),
              icon: const Icon(Icons.directions),
              label: const Text('Directions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getFacilityIcon() {
    switch (facility!.type) {
      case FacilityType.hospital:
        return Icons.local_hospital;
      case FacilityType.pharmacy:
        return Icons.local_pharmacy;
      case FacilityType.laboratory:
        return Icons.science;
      case FacilityType.clinic:
        return Icons.medical_services;
    }
  }

  Color _getFacilityColor() {
    switch (facility!.type) {
      case FacilityType.hospital:
        return Colors.red;
      case FacilityType.pharmacy:
        return Colors.green;
      case FacilityType.laboratory:
        return Colors.blue;
      case FacilityType.clinic:
        return Colors.orange;
    }
  }

  void _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _sendEmail(String email) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _openWebsite(String website) async {
    String url = website;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final Uri launchUri = Uri.parse(url);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  void _openMaps() async {
    final location = facility!.location;
    final lat = location['latitude'];
    final lng = location['longitude'];
    final Uri launchUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  ProviderType _getFacilityProviderType(FacilityType facilityType) {
    switch (facilityType) {
      case FacilityType.hospital:
        return ProviderType.hospital;
      case FacilityType.pharmacy:
        return ProviderType.pharmacy;
      case FacilityType.laboratory:
        return ProviderType.laboratory;
      case FacilityType.clinic:
        return ProviderType.clinic;
    }
  }
}
