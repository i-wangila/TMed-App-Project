import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
              'TMed Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Effective Date: January 1, ${DateTime.now().year}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Information We Collect',
              'We collect personal information including name, email, phone number, medical history, and payment information to provide healthcare services.',
            ),
            _buildSection(
              'How We Use Your Information',
              'Your information is used to provide medical consultations, process payments, send appointment reminders, and improve our services.',
            ),
            _buildSection(
              'Data Security',
              'We implement industry-standard security measures including encryption, secure servers, and access controls to protect your medical information.',
            ),
            _buildSection(
              'Information Sharing',
              'We do not sell your personal information. We may share information with healthcare providers involved in your care and as required by law.',
            ),
            _buildSection(
              'Your Rights',
              'You have the right to access, update, or delete your personal information. You can also request a copy of your medical records.',
            ),
            _buildSection(
              'Cookies and Tracking',
              'We use cookies to improve user experience and analyze app usage. You can disable cookies in your browser settings.',
            ),
            _buildSection(
              'Children\'s Privacy',
              'Our services are not intended for children under 13. We do not knowingly collect information from children under 13.',
            ),
            _buildSection(
              'Changes to This Policy',
              'We may update this privacy policy periodically. We will notify users of significant changes via email or app notifications.',
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'If you have questions about this privacy policy:',
                  ),
                  const SizedBox(height: 8),
                  const Text('Email: privacy@tmed.com'),
                  const Text('Phone: +254740109195'),
                ],
              ),
            ),
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
