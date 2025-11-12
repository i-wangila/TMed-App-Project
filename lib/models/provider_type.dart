enum ProviderCategory { individual, facility }

class ProviderType {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final ProviderCategory category;
  final List<String> examples;
  final List<String> requirements;
  final String estimatedSetupTime;

  ProviderType({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.category,
    required this.examples,
    required this.requirements,
    required this.estimatedSetupTime,
  });
}

class ProviderTypeService {
  static final List<ProviderType> _providerTypes = [
    // Individual Healthcare Providers
    ProviderType(
      id: 'doctor',
      name: 'Doctor/Physician',
      description:
          'Licensed medical doctors providing consultations, diagnoses, and treatments',
      iconPath: 'assets/icons/doctor.png',
      category: ProviderCategory.individual,
      examples: [
        'General Practitioner',
        'Cardiologist',
        'Pediatrician',
        'Surgeon',
        'Psychiatrist',
      ],
      requirements: [
        'Medical License',
        'Professional Certification',
        'Valid ID',
      ],
      estimatedSetupTime: '15-20 minutes',
    ),
    ProviderType(
      id: 'nurse',
      name: 'Nurse/Nursing Services',
      description:
          'Registered nurses providing patient care, health education, and medical support',
      iconPath: 'assets/icons/nurse.png',
      category: ProviderCategory.individual,
      examples: [
        'Registered Nurse',
        'Nurse Practitioner',
        'Home Care Nurse',
        'ICU Nurse',
      ],
      requirements: [
        'Nursing License',
        'Professional Certification',
        'Valid ID',
      ],
      estimatedSetupTime: '10-15 minutes',
    ),
    ProviderType(
      id: 'therapist',
      name: 'Therapist/Counselor',
      description:
          'Mental health professionals and physical therapists providing specialized care',
      iconPath: 'assets/icons/therapist.png',
      category: ProviderCategory.individual,
      examples: [
        'Physiotherapist',
        'Psychologist',
        'Occupational Therapist',
        'Speech Therapist',
      ],
      requirements: ['Professional License', 'Certification', 'Valid ID'],
      estimatedSetupTime: '10-15 minutes',
    ),
    ProviderType(
      id: 'nutritionist',
      name: 'Nutritionist/Dietitian',
      description:
          'Certified nutrition experts providing dietary guidance and meal planning',
      iconPath: 'assets/icons/nutritionist.png',
      category: ProviderCategory.individual,
      examples: [
        'Clinical Nutritionist',
        'Sports Nutritionist',
        'Pediatric Dietitian',
      ],
      requirements: [
        'Nutrition Certification',
        'Professional License',
        'Valid ID',
      ],
      estimatedSetupTime: '10-15 minutes',
    ),
    ProviderType(
      id: 'home_care',
      name: 'Home Care Services',
      description:
          'Professional caregivers providing in-home medical and personal care',
      iconPath: 'assets/icons/home_care.png',
      category: ProviderCategory.individual,
      examples: [
        'Home Health Aide',
        'Personal Care Assistant',
        'Medical Companion',
      ],
      requirements: ['Caregiver Certification', 'Background Check', 'Valid ID'],
      estimatedSetupTime: '15-20 minutes',
    ),

    // Healthcare Facilities
    ProviderType(
      id: 'hospital',
      name: 'Hospital',
      description:
          'Full-service medical facilities providing comprehensive healthcare services',
      iconPath: 'assets/icons/hospital.png',
      category: ProviderCategory.facility,
      examples: [
        'General Hospital',
        'Specialty Hospital',
        'Teaching Hospital',
        'Private Hospital',
      ],
      requirements: [
        'Hospital License',
        'Accreditation',
        'Business Registration',
      ],
      estimatedSetupTime: '30-45 minutes',
    ),
    ProviderType(
      id: 'clinic',
      name: 'Clinic/Medical Center',
      description:
          'Outpatient medical facilities providing specialized or general healthcare',
      iconPath: 'assets/icons/clinic.png',
      category: ProviderCategory.facility,
      examples: [
        'Family Clinic',
        'Specialty Clinic',
        'Urgent Care Center',
        'Medical Center',
      ],
      requirements: [
        'Clinic License',
        'Medical Permits',
        'Business Registration',
      ],
      estimatedSetupTime: '25-35 minutes',
    ),
    ProviderType(
      id: 'pharmacy',
      name: 'Pharmacy',
      description:
          'Licensed pharmacies dispensing medications and health products',
      iconPath: 'assets/icons/pharmacy.png',
      category: ProviderCategory.facility,
      examples: [
        'Retail Pharmacy',
        'Hospital Pharmacy',
        'Online Pharmacy',
        'Specialty Pharmacy',
      ],
      requirements: [
        'Pharmacy License',
        'Pharmacist License',
        'Business Registration',
      ],
      estimatedSetupTime: '20-30 minutes',
    ),
    ProviderType(
      id: 'laboratory',
      name: 'Medical Laboratory',
      description:
          'Diagnostic laboratories providing medical testing and analysis services',
      iconPath: 'assets/icons/laboratory.png',
      category: ProviderCategory.facility,
      examples: [
        'Clinical Laboratory',
        'Pathology Lab',
        'Imaging Center',
        'Diagnostic Center',
      ],
      requirements: [
        'Laboratory License',
        'Quality Certification',
        'Business Registration',
      ],
      estimatedSetupTime: '25-35 minutes',
    ),
    ProviderType(
      id: 'dental',
      name: 'Dental Practice',
      description:
          'Dental clinics and practices providing oral healthcare services',
      iconPath: 'assets/icons/dental.png',
      category: ProviderCategory.facility,
      examples: [
        'General Dentistry',
        'Orthodontics',
        'Oral Surgery',
        'Pediatric Dentistry',
      ],
      requirements: [
        'Dental License',
        'Practice License',
        'Business Registration',
      ],
      estimatedSetupTime: '20-30 minutes',
    ),
    ProviderType(
      id: 'wellness',
      name: 'Wellness Center',
      description:
          'Holistic health and wellness facilities promoting overall well-being',
      iconPath: 'assets/icons/wellness.png',
      category: ProviderCategory.facility,
      examples: [
        'Spa & Wellness',
        'Fitness Center',
        'Yoga Studio',
        'Meditation Center',
      ],
      requirements: ['Business License', 'Health Permits', 'Certification'],
      estimatedSetupTime: '15-25 minutes',
    ),
  ];

  static List<ProviderType> getAllProviderTypes() {
    return List.from(_providerTypes);
  }

  static List<ProviderType> getIndividualProviders() {
    return _providerTypes
        .where((type) => type.category == ProviderCategory.individual)
        .toList();
  }

  static List<ProviderType> getFacilityProviders() {
    return _providerTypes
        .where((type) => type.category == ProviderCategory.facility)
        .toList();
  }

  static ProviderType? getProviderTypeById(String id) {
    try {
      return _providerTypes.firstWhere((type) => type.id == id);
    } catch (e) {
      return null;
    }
  }
}
