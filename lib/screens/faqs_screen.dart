import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'FAQ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: ResponsiveUtils.getResponsivePadding(context),
        children: [
          _buildFAQItem(
            context,
            question: 'How do I book an appointment?',
            answer:
                'To book an appointment, navigate to the home screen, search for your preferred doctor or healthcare facility, tap on their profile, and select "Book Appointment". Choose your preferred date and time, then confirm your booking.',
          ),
          _buildFAQItem(
            context,
            question: 'How can I cancel or reschedule my appointment?',
            answer:
                'Go to the Appointments tab from the bottom navigation, find your appointment, and tap on it. You\'ll see options to either reschedule or cancel the appointment.',
          ),
          _buildFAQItem(
            context,
            question: 'What payment methods are accepted?',
            answer:
                'We accept M-Pesa, bank transfers, and credit/debit cards. You can also use your TMed wallet for quick and easy payments.',
          ),
          _buildFAQItem(
            context,
            question: 'How do I add money to my wallet?',
            answer:
                'Tap on the Profile icon, select Wallet, then tap "Top Up". Choose your preferred payment method (M-Pesa, Bank Transfer, or Card) and enter the amount you wish to add.',
          ),
          _buildFAQItem(
            context,
            question: 'Can I access my medical records?',
            answer:
                'Yes! Go to Settings > Manage My Account > Medical Records to view all your medical documents including lab results, prescriptions, and discharge summaries shared by healthcare providers.',
          ),
          _buildFAQItem(
            context,
            question: 'How do I search for doctors or hospitals?',
            answer:
                'Use the search bar on the home screen to find doctors, hospitals, clinics, pharmacies, or laboratories. You can search by name, specialization, or location.',
          ),
          _buildFAQItem(
            context,
            question: 'How do I filter healthcare facilities by county?',
            answer:
                'When viewing a category (Hospitals, Pharmacies, etc.), tap the three-dot menu icon at the top right and select "Filter by County". Choose your preferred county to see facilities in that area.',
          ),
          _buildFAQItem(
            context,
            question: 'Can I chat with my doctor?',
            answer:
                'Yes! After booking an appointment, you can message your doctor through the Inbox tab. You can also initiate video or voice calls if the doctor is available.',
          ),
          _buildFAQItem(
            context,
            question: 'How do I become a healthcare provider on TMed?',
            answer:
                'Tap on the Profile icon, then select "Become a Healthcare Provider". Fill in your professional details, upload your credentials, and submit for verification. Our team will review and approve your application.',
          ),
          _buildFAQItem(
            context,
            question: 'Is my personal information secure?',
            answer:
                'Absolutely! We use industry-standard encryption to protect your data. Your medical records and personal information are stored securely and only shared with healthcare providers you authorize.',
          ),
          _buildFAQItem(
            context,
            question: 'How do I update my profile information?',
            answer:
                'Go to Settings > Manage My Account. Here you can update your personal information, medical details, and profile picture.',
          ),
          _buildFAQItem(
            context,
            question: 'What should I do if I forget my password?',
            answer:
                'On the login screen, tap "Forgot Password". Enter your registered email address, and we\'ll send you instructions to reset your password.',
          ),
          _buildFAQItem(
            context,
            question: 'Can I rate and review healthcare providers?',
            answer:
                'Yes! After your appointment, you can rate your experience and leave a review. This helps other users make informed decisions.',
          ),
          _buildFAQItem(
            context,
            question: 'How do I contact customer support?',
            answer:
                'Tap on the Profile icon and select "Contact Us". You can reach us via email, phone, or through the in-app contact form. Our support team is available 24/7.',
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
        ],
      ),
    );
  }

  static Widget _buildFAQItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 16),
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.all(
            ResponsiveUtils.getResponsiveSpacing(context, 16),
          ),
          childrenPadding: EdgeInsets.fromLTRB(
            ResponsiveUtils.getResponsiveSpacing(context, 16),
            0,
            ResponsiveUtils.getResponsiveSpacing(context, 16),
            ResponsiveUtils.getResponsiveSpacing(context, 16),
          ),
          title: Text(
            question,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          iconColor: Colors.black,
          collapsedIconColor: Colors.grey[600],
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
