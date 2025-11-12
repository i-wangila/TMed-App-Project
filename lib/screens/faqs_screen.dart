import 'package:flutter/material.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildFaqItem(
            'How do I book an appointment?',
            'You can book an appointment by browsing healthcare providers on the home screen, selecting a doctor or hospital, and clicking "Book Appointment". Choose your preferred date, time, and consultation type.',
          ),
          _buildFaqItem(
            'What payment methods are accepted?',
            'We accept payments through our integrated wallet system. You can top up your wallet using M-Pesa, Airtel Money, or Telkom mobile money services.',
          ),
          _buildFaqItem(
            'How do video consultations work?',
            'Video consultations are conducted through our secure platform. At your appointment time, click "Video Call" in your appointments section to connect with your healthcare provider.',
          ),
          _buildFaqItem(
            'Can I reschedule my appointment?',
            'Yes, you can reschedule appointments up to 2 hours before the scheduled time. Go to your appointments and click "Reschedule" to select a new time.',
          ),
          _buildFaqItem(
            'How do I access my prescriptions?',
            'Your prescriptions are available in the "Prescription Reports" section of your profile. You can view, download, and track the status of your prescriptions.',
          ),
          _buildFaqItem(
            'Is my medical information secure?',
            'Yes, all medical information is encrypted and stored securely. We comply with healthcare privacy regulations and never share your information without consent.',
          ),
          _buildFaqItem(
            'What if I have a medical emergency?',
            'TMed is not for medical emergencies. In case of emergency, call 999 or go to the nearest emergency room immediately.',
          ),
          _buildFaqItem(
            'How do I update my profile information?',
            'Go to your profile, click on "My Accounts" and then "Edit Profile" to update your personal information, contact details, and medical history.',
          ),
          _buildFaqItem(
            'Can I get a refund for consultations?',
            'Refunds are available if you cancel at least 24 hours before your appointment. Emergency cancellations are reviewed case by case.',
          ),
          _buildFaqItem(
            'How do I contact customer support?',
            'You can contact support through the "Contact Us" section in your profile, or email us at support@tmed.com, or call +254 700 123 456.',
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
