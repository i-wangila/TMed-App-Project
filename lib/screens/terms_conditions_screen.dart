import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TMed Terms & Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${DateTime.now().year}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 24),
            _buildSection(
              '1. Acceptance of Terms',
              'By accessing and using TMed, you accept and agree to be bound by the terms and provision of this agreement.',
            ),
            _buildSection(
              '2. Medical Services',
              'TMed provides telemedicine services including video consultations, chat consultations, and appointment booking. These services are provided by licensed healthcare professionals.',
            ),
            _buildSection(
              '3. User Responsibilities',
              'Users are responsible for providing accurate medical information and following prescribed treatments. Users must not misuse the platform or provide false information.',
            ),
            _buildSection(
              '4. Privacy and Data Protection',
              'We are committed to protecting your privacy and medical information. All data is encrypted and stored securely in compliance with healthcare regulations.',
            ),
            _buildSection(
              '5. Payment Terms',
              'All consultation fees must be paid through the integrated wallet system. Refunds are available according to our refund policy.',
            ),
            _buildSection(
              '6. Limitation of Liability',
              'TMed is not liable for any damages arising from the use of our services. Emergency medical situations should be handled by calling emergency services.',
            ),
            _buildSection(
              '7. Modifications',
              'We reserve the right to modify these terms at any time. Users will be notified of significant changes.',
            ),
            const SizedBox(height: 32),
            const Text(
              'Contact Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Email: support@tmed.com'),
            const Text('Phone: +254 700 123 456'),
            const Text('Address: Nairobi, Kenya'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}
