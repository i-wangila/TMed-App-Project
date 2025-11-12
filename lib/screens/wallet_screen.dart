import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildWalletBalance(),
          const SizedBox(height: 24),
          _buildTransactionHistory(),
          const SizedBox(height: 24),
          _buildComingSoonMessage(),
        ],
      ),
    );
  }

  Widget _buildWalletBalance() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!, width: 1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Balance',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'KES 2,500.00',
            style: TextStyle(
              color: Colors.black,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _buildTransactionItem(
            'Consultation Payment',
            'Dr. Smith - Video Call',
            '-KES 1,500.00',
            DateTime.now().subtract(const Duration(days: 1)),
            Colors.red,
          ),
          _buildTransactionItem(
            'Wallet Top-up',
            'M-Pesa Payment',
            '+KES 5,000.00',
            DateTime.now().subtract(const Duration(days: 3)),
            Colors.green,
          ),
          _buildTransactionItem(
            'Prescription Payment',
            'Goodlife Pharmacy',
            '-KES 850.00',
            DateTime.now().subtract(const Duration(days: 5)),
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String subtitle,
    String amount,
    DateTime date,
    Color amountColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: amountColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              amountColor == Colors.green ? Icons.add : Icons.remove,
              color: amountColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
              Text(
                '${date.day}/${date.month}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(Icons.construction, size: 48, color: Colors.blue[600]),
          const SizedBox(height: 12),
          Text(
            'More Features Coming Soon',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'re working on adding more wallet features like mobile money integration, bill payments, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.blue[700]),
          ),
        ],
      ),
    );
  }
}
