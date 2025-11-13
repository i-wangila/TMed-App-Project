import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/healthcare_provider.dart';
import '../models/review.dart';
import '../models/message.dart';
import '../services/healthcare_provider_service.dart';
import '../services/review_service.dart';
import '../services/call_service.dart';
import '../services/message_service.dart';
import 'book_appointment_screen.dart';
import 'provider_reviews_screen.dart';
import 'provider_reviews_list_screen.dart';
import 'rate_any_provider_screen.dart';
import 'call_screen.dart';
import 'chat_screen.dart';

class ProviderProfileScreen extends StatefulWidget {
  final String providerId;

  const ProviderProfileScreen({super.key, required this.providerId});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  HealthcareProvider? provider;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProvider();
  }

  void _loadProvider() {
    setState(() {
      provider = HealthcareProviderService.getProviderById(widget.providerId);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (provider == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Provider Not Found'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: const Center(child: Text('Provider not found')),
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
                _buildProviderInfo(),
                _buildAboutSection(),
                _buildQualificationsSection(),
                _buildCertificationsSection(),
                _buildServicesSection(),
                _buildReviewsSection(),
                _buildAvailabilitySection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildBookAppointmentButton(),
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
            provider!.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: provider!.isFavorite ? Colors.red : Colors.black,
          ),
          onPressed: () {
            setState(() {
              HealthcareProviderService.toggleFavorite(provider!.id);
              provider = HealthcareProviderService.getProviderById(
                provider!.id,
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
              Builder(
                builder: (context) {
                  final profileImage = _getProviderProfileImage();
                  return CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue[100],
                    backgroundImage: profileImage,
                    onBackgroundImageError: profileImage != null
                        ? (exception, stackTrace) {}
                        : null,
                    child: _shouldShowInitials()
                        ? Text(
                            provider!.name
                                .split(' ')
                                .map((e) => e[0])
                                .take(2)
                                .join(),
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          )
                        : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                provider!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                provider!.specialization,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${provider!.rating}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProviderReviewsScreen(
                            providerId: provider!.id,
                            providerName: provider!.name,
                          ),
                        ),
                      );
                      // Refresh provider data when returning
                      _loadProvider();
                    },
                    child: Text(
                      '(${provider!.reviewCount} reviews)',
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

  Widget _buildProviderInfo() {
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
        children: [
          _buildInfoRow(Icons.location_on, 'Location', provider!.location),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.phone, 'Phone', provider!.phone),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.email, 'Email', provider!.email),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.work,
            'Experience',
            '${provider!.experienceYears} years',
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.language,
            'Languages',
            provider!.languages.join(', '),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.attach_money,
            'Consultation Fee',
            'KES ${provider!.consultationFee.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
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
                  fontSize: 16,
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

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _startVoiceCall,
            icon: const Icon(Icons.phone, size: 18),
            label: const Text('Call'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _startChat,
            icon: const Icon(Icons.message, size: 18),
            label: const Text('Message'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange,
              side: const BorderSide(color: Colors.orange),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _getDirections,
            icon: const Icon(Icons.directions, size: 18),
            label: const Text('Directions'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _startVoiceCall() async {
    try {
      final callSession = await CallService.startCall(
        providerId: provider!.id,
        providerName: provider!.name,
        callType: CallType.voice,
        patientId: 'current_user_id', // Replace with actual user ID
        patientName: 'Current User', // Replace with actual user name
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallScreen(callSession: callSession),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to start call. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _getDirections() {
    // Show directions options
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
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
                Row(
                  children: [
                    const Icon(Icons.directions, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Get Directions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'To: ${provider!.location}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                _buildDirectionOption(
                  icon: Icons.map,
                  title: 'Google Maps',
                  subtitle: 'Open in Google Maps app',
                  onTap: () => _openInGoogleMaps(),
                ),
                const SizedBox(height: 12),
                _buildDirectionOption(
                  icon: Icons.navigation,
                  title: 'Apple Maps',
                  subtitle: 'Open in Apple Maps (iOS)',
                  onTap: () => _openInAppleMaps(),
                ),
                const SizedBox(height: 12),
                _buildDirectionOption(
                  icon: Icons.copy,
                  title: 'Copy Address',
                  subtitle: 'Copy location to clipboard',
                  onTap: () => _copyAddress(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDirectionOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.green[700], size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _openInGoogleMaps() {
    Navigator.pop(context);
    // In a real app, you would use url_launcher to open Google Maps
    // For now, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Google Maps for: ${provider!.location}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _openInAppleMaps() {
    Navigator.pop(context);
    // In a real app, you would use url_launcher to open Apple Maps
    // For now, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Apple Maps for: ${provider!.location}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _copyAddress() {
    Navigator.pop(context);
    // In a real app, you would use Clipboard.setData to copy the address
    // For now, show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Address copied: ${provider!.location}'),
        backgroundColor: Colors.grey[700],
      ),
    );
  }

  void _startChat() async {
    try {
      // Create a message that will appear in the inbox
      final message = Message(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        senderId: provider!.id,
        senderName: provider!.name,
        content: 'Hello! I would like to start a conversation with you.',
        timestamp: DateTime.now(),
        type: MessageType.text,
        category:
            MessageCategory.healthcareProvider, // Ensures it's interactive
        isRead: false,
      );

      // Add the message to the inbox so it appears when user navigates to inbox
      await MessageService.addProviderMessage(
        provider!.id,
        provider!.name,
        'Hello! I would like to start a conversation with you.',
      );

      // Navigate to chat screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(message: message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to start chat. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildAboutSection() {
    return _buildSection(
      'About',
      Icons.person,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider!.bio,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualificationsSection() {
    return _buildSection(
      'Qualifications',
      Icons.school,
      Column(
        children: provider!.qualifications.map((qualification) {
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
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    qualification,
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

  Widget _buildCertificationsSection() {
    return _buildSection(
      'Certifications',
      Icons.verified,
      Column(
        children: provider!.certifications.map((certification) {
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
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    certification,
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

  Widget _buildServicesSection() {
    return _buildSection(
      'Services Offered',
      Icons.medical_services,
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: provider!.services.map((service) {
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

  Widget _buildAvailabilitySection() {
    return _buildSection(
      'Availability',
      Icons.schedule,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                provider!.openingHours,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Working Days:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: provider!.workingDays.map((day) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final reviews = ReviewService.getReviewsByProvider(provider!.id);
    final providerRating = ReviewService.getProviderRating(provider!.id);

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
                            providerId: provider!.id,
                            providerName: provider!.name,
                            providerType: ProviderType.doctor,
                            description: 'Rate this provider',
                          ),
                        ),
                      );
                      // Refresh provider data when returning
                      _loadProvider();
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
                              providerId: provider!.id,
                              providerName: provider!.name,
                              providerType: ProviderType.doctor,
                            ),
                          ),
                        );
                        // Refresh provider data when returning
                        _loadProvider();
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

  Widget _buildBookAppointmentButton() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookAppointmentScreen(provider: provider!),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.black, width: 1),
          ),
        ),
        child: const Text(
          'Book Appointment',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  ImageProvider? _getProviderProfileImage() {
    if (provider?.profileImageUrl != null &&
        provider!.profileImageUrl.isNotEmpty &&
        provider!.profileImageUrl != 'https://via.placeholder.com/200') {
      if (provider!.profileImageUrl.startsWith('/')) {
        // Local file path
        return FileImage(File(provider!.profileImageUrl));
      } else {
        // Network URL
        return NetworkImage(provider!.profileImageUrl);
      }
    }
    return null;
  }

  bool _shouldShowInitials() {
    return provider?.profileImageUrl == null ||
        provider!.profileImageUrl.isEmpty ||
        provider!.profileImageUrl == 'https://via.placeholder.com/200';
  }
}
