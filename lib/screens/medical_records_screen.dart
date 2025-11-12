import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Records'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Recent Visits'),
          _buildMedicalRecord(
            date: DateTime.now().subtract(const Duration(days: 7)),
            provider: 'Dr. Sarah Mwangi',
            diagnosis: 'Hypertension Follow-up',
            notes: 'Blood pressure stable. Continue current medication.',
          ),
          _buildMedicalRecord(
            date: DateTime.now().subtract(const Duration(days: 30)),
            provider: 'Nairobi Hospital',
            diagnosis: 'Annual Physical Exam',
            notes: 'Overall health good. Recommended lifestyle changes.',
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Vital Signs'),
          _buildVitalSigns(),
          const SizedBox(height: 24),
          _buildSectionHeader('Allergies'),
          _buildAllergyList(),
          const SizedBox(height: 24),
          _buildSectionHeader('Current Medications'),
          _buildMedicationList(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMedicalRecord({
    required DateTime date,
    required String provider,
    required String diagnosis,
    required String notes,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  provider,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              diagnosis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              notes,
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalSigns() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildVitalRow('Blood Pressure', '120/80 mmHg', Icons.favorite),
            _buildVitalRow('Heart Rate', '72 bpm', Icons.monitor_heart),
            _buildVitalRow('Temperature', '98.6°F', Icons.thermostat),
            _buildVitalRow('Weight', '70 kg', Icons.scale),
            _buildVitalRow('Height', '175 cm', Icons.height),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 15))),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyList() {
    final allergies = ['Penicillin', 'Peanuts', 'Shellfish'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: allergies.map((allergy) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 20),
                  const SizedBox(width: 12),
                  Text(allergy, style: const TextStyle(fontSize: 15)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMedicationList() {
    final medications = [
      {'name': 'Lisinopril', 'dosage': '10mg', 'frequency': 'Once daily'},
      {'name': 'Metformin', 'dosage': '500mg', 'frequency': 'Twice daily'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: medications.map((med) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.medication, color: Colors.blue, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${med['name']} ${med['dosage']}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          med['frequency']!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
