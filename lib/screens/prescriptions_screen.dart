import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Reports'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPrescription(
            date: DateTime.now().subtract(const Duration(days: 3)),
            doctor: 'Dr. Sarah Mwangi',
            status: 'Ready for Pickup',
            pharmacy: 'Goodlife Pharmacy - Westlands',
            medications: [
              {
                'name': 'Amoxicillin',
                'dosage': '500mg',
                'quantity': '21 tablets',
              },
              {
                'name': 'Paracetamol',
                'dosage': '500mg',
                'quantity': '10 tablets',
              },
            ],
          ),
          _buildPrescription(
            date: DateTime.now().subtract(const Duration(days: 14)),
            doctor: 'Dr. James Kiprotich',
            status: 'Collected',
            pharmacy: 'Haltons Pharmacy - CBD',
            medications: [
              {
                'name': 'Lisinopril',
                'dosage': '10mg',
                'quantity': '30 tablets',
              },
            ],
          ),
          _buildPrescription(
            date: DateTime.now().subtract(const Duration(days: 30)),
            doctor: 'Dr. Grace Wanjiku',
            status: 'Expired',
            pharmacy: 'Mediplus Pharmacy',
            medications: [
              {
                'name': 'Metformin',
                'dosage': '500mg',
                'quantity': '60 tablets',
              },
              {'name': 'Aspirin', 'dosage': '75mg', 'quantity': '30 tablets'},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrescription({
    required DateTime date,
    required String doctor,
    required String status,
    required String pharmacy,
    required List<Map<String, String>> medications,
  }) {
    return Builder(
      builder: (context) {
        Color statusColor = _getStatusColor(status);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Prescription #${date.millisecondsSinceEpoch.toString().substring(8)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInfoRow('Prescribed by', doctor),
                _buildInfoRow('Date', DateFormat('MMM dd, yyyy').format(date)),
                _buildInfoRow('Pharmacy', pharmacy),
                const SizedBox(height: 12),
                const Text(
                  'Medications:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                ...medications.map((med) => _buildMedicationRow(med)),
                const SizedBox(height: 12),
                if (status == 'Ready for Pickup')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showPickupDialog(context, pharmacy),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Mark as Collected'),
                    ),
                  ),
                if (status == 'Collected')
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showReorderDialog(context),
                      child: const Text('Reorder Prescription'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildMedicationRow(Map<String, String> medication) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.medication, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${medication['name']} ${medication['dosage']} - ${medication['quantity']}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ready for pickup':
        return Colors.orange;
      case 'collected':
        return Colors.green;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showPickupDialog(BuildContext context, String pharmacy) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Pickup'),
        content: Text('Mark prescription as collected from $pharmacy?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prescription marked as collected'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showReorderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reorder Prescription'),
        content: const Text('Would you like to reorder this prescription?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prescription reorder request sent'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Reorder'),
          ),
        ],
      ),
    );
  }
}
