import '../models/healthcare_facility.dart';
import 'review_service.dart';

class HealthcareFacilityService {
  static final List<HealthcareFacility> _facilities = [
    // Hospitals
    HealthcareFacility(
      id: 'nairobi_hospital',
      name: 'Nairobi Hospital',
      type: FacilityType.hospital,
      rating: 4.93,
      reviewCount: 1247,
      description:
          'The Nairobi Hospital is a leading private healthcare institution in Kenya, providing comprehensive medical services with state-of-the-art facilities and experienced medical professionals.',
      address: 'Argwings Kodhek Road, Hurlingham, Nairobi',
      phone: '+254 20 2845000',
      email: 'info@nairobihospital.org',
      website: 'www.nairobihospital.org',
      services: [
        'Emergency Services',
        'Inpatient Care',
        'Outpatient Services',
        'Surgery',
        'Maternity Services',
        'Pediatrics',
        'Radiology',
        'Laboratory Services',
        'Pharmacy',
        'Physiotherapy',
      ],
      workingHours: {
        'Monday': '24 Hours',
        'Tuesday': '24 Hours',
        'Wednesday': '24 Hours',
        'Thursday': '24 Hours',
        'Friday': '24 Hours',
        'Saturday': '24 Hours',
        'Sunday': '24 Hours',
      },
      departments: [
        'Cardiology',
        'Neurology',
        'Oncology',
        'Orthopedics',
        'Pediatrics',
        'Obstetrics & Gynecology',
        'Internal Medicine',
        'Surgery',
        'Emergency Medicine',
        'Radiology',
      ],
      specialties: [
        'Heart Surgery',
        'Brain Surgery',
        'Cancer Treatment',
        'Joint Replacement',
        'Maternity Care',
        'Pediatric Care',
      ],
      facilities: [
        'ICU',
        'Operating Theaters',
        'CT Scan',
        'MRI',
        'X-Ray',
        'Ultrasound',
        'Blood Bank',
        'Pharmacy',
        'Cafeteria',
        'Chapel',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'CIC Insurance',
        'Madison Insurance',
        'Britam',
        'APA Insurance',
      ],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2921,
        'longitude': 36.8219,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'ISO 9001:2015 Certified',
        'Joint Commission International Accredited',
        'Kenya Medical Practitioners Board Licensed',
      ],
      establishedYear: '1954',
      bedCapacity: 240,
      contactPersons: [
        {
          'name': 'Dr. James Nyong\'o',
          'position': 'Chief Executive Officer',
          'phone': '+254 20 2845001',
          'email': 'ceo@nairobihospital.org',
        },
        {
          'name': 'Mary Wanjiku',
          'position': 'Customer Service Manager',
          'phone': '+254 20 2845050',
          'email': 'customerservice@nairobihospital.org',
        },
      ],
    ),

    HealthcareFacility(
      id: 'aga_khan_hospital',
      name: 'Aga Khan University Hospital',
      type: FacilityType.hospital,
      rating: 4.85,
      reviewCount: 892,
      description:
          'Aga Khan University Hospital is a premier healthcare institution offering world-class medical services with cutting-edge technology and internationally trained medical staff.',
      address: '3rd Parklands Avenue, Nairobi',
      phone: '+254 20 3662000',
      email: 'info@aku.edu',
      website: 'www.aku.edu',
      services: [
        'Emergency Services',
        'Cardiac Services',
        'Cancer Care',
        'Neurosciences',
        'Orthopedics',
        'Maternity Services',
        'Pediatrics',
        'Diagnostic Imaging',
        'Laboratory Services',
      ],
      workingHours: {
        'Monday': '24 Hours',
        'Tuesday': '24 Hours',
        'Wednesday': '24 Hours',
        'Thursday': '24 Hours',
        'Friday': '24 Hours',
        'Saturday': '24 Hours',
        'Sunday': '24 Hours',
      },
      departments: [
        'Cardiology',
        'Oncology',
        'Neurology',
        'Orthopedics',
        'Pediatrics',
        'Obstetrics & Gynecology',
        'Emergency Medicine',
      ],
      specialties: [
        'Cardiac Surgery',
        'Cancer Treatment',
        'Neurosurgery',
        'Organ Transplant',
        'Minimally Invasive Surgery',
      ],
      facilities: [
        'Cardiac Catheterization Lab',
        'Linear Accelerator',
        'MRI',
        'CT Scan',
        'PET Scan',
        'Operating Theaters',
        'ICU',
        'NICU',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'Resolution Insurance',
        'Madison Insurance',
      ],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2634,
        'longitude': 36.8084,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'JCI Accredited',
        'ISO 15189 Laboratory Certification',
        'COHSASA Accredited',
      ],
      establishedYear: '1958',
      bedCapacity: 254,
      contactPersons: [
        {
          'name': 'Dr. Shehnaaz Suliman',
          'position': 'Chief Executive Officer',
          'phone': '+254 20 3662001',
          'email': 'ceo@aku.edu',
        },
      ],
    ),

    // Pharmacies
    HealthcareFacility(
      id: 'goodlife_pharmacy',
      name: 'Goodlife Pharmacy',
      type: FacilityType.pharmacy,
      rating: 4.91,
      reviewCount: 567,
      description:
          'Goodlife Pharmacy is Kenya\'s leading retail pharmacy chain, providing quality pharmaceutical products and healthcare services across multiple locations.',
      address: 'Multiple Locations Across Kenya',
      phone: '+254 709 691000',
      email: 'info@goodlife.co.ke',
      website: 'www.goodlife.co.ke',
      services: [
        'Prescription Dispensing',
        'Over-the-Counter Medications',
        'Health Consultations',
        'Blood Pressure Monitoring',
        'Diabetes Testing',
        'Vaccination Services',
        'Health Screenings',
        'Medical Equipment Sales',
        'Home Delivery',
      ],
      workingHours: {
        'Monday': '8:00 AM - 10:00 PM',
        'Tuesday': '8:00 AM - 10:00 PM',
        'Wednesday': '8:00 AM - 10:00 PM',
        'Thursday': '8:00 AM - 10:00 PM',
        'Friday': '8:00 AM - 10:00 PM',
        'Saturday': '8:00 AM - 10:00 PM',
        'Sunday': '9:00 AM - 9:00 PM',
      },
      departments: [
        'Prescription Department',
        'OTC Department',
        'Health & Wellness',
        'Medical Equipment',
        'Beauty & Personal Care',
      ],
      specialties: [
        'Chronic Disease Management',
        'Pediatric Medications',
        'Geriatric Care',
        'Women\'s Health',
        'Men\'s Health',
      ],
      facilities: [
        'Consultation Rooms',
        'Blood Pressure Monitors',
        'Glucose Testing',
        'Weight Scales',
        'Refrigerated Storage',
        'Drive-Through Service',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'Madison Insurance',
        'Resolution Insurance',
      ],
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2921,
        'longitude': 36.8219,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'Pharmacy and Poisons Board Licensed',
        'ISO 9001:2015 Certified',
        'Good Pharmacy Practice Certified',
      ],
      establishedYear: '2003',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Peter Kuria',
          'position': 'Chief Pharmacist',
          'phone': '+254 709 691001',
          'email': 'chief.pharmacist@goodlife.co.ke',
        },
      ],
    ),

    // Laboratories
    HealthcareFacility(
      id: 'lancet_kenya',
      name: 'Lancet Kenya',
      type: FacilityType.laboratory,
      rating: 4.81,
      reviewCount: 423,
      description:
          'Lancet Kenya is a leading medical laboratory providing comprehensive diagnostic services with state-of-the-art equipment and qualified laboratory professionals.',
      address: 'Mombasa Road, Industrial Area, Nairobi',
      phone: '+254 20 3540000',
      email: 'info@lancet.co.ke',
      website: 'www.lancet.co.ke',
      services: [
        'Blood Tests',
        'Urine Analysis',
        'Microbiology',
        'Histopathology',
        'Cytology',
        'Molecular Diagnostics',
        'Immunology',
        'Clinical Chemistry',
        'Hematology',
        'Home Sample Collection',
      ],
      workingHours: {
        'Monday': '6:00 AM - 6:00 PM',
        'Tuesday': '6:00 AM - 6:00 PM',
        'Wednesday': '6:00 AM - 6:00 PM',
        'Thursday': '6:00 AM - 6:00 PM',
        'Friday': '6:00 AM - 6:00 PM',
        'Saturday': '7:00 AM - 4:00 PM',
        'Sunday': '8:00 AM - 2:00 PM',
      },
      departments: [
        'Clinical Chemistry',
        'Hematology',
        'Microbiology',
        'Immunology',
        'Histopathology',
        'Molecular Biology',
      ],
      specialties: [
        'Cancer Screening',
        'Infectious Disease Testing',
        'Genetic Testing',
        'Hormone Testing',
        'Cardiac Markers',
        'Allergy Testing',
      ],
      facilities: [
        'Automated Analyzers',
        'PCR Machines',
        'Microscopy Lab',
        'Sample Collection Centers',
        'Cold Chain Storage',
        'Quality Control Lab',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'CIC Insurance',
        'Madison Insurance',
      ],
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.3197,
        'longitude': 36.8510,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'ISO 15189 Accredited',
        'KENAS Accredited',
        'CAP Proficiency Testing',
      ],
      establishedYear: '1998',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Sarah Macharia',
          'position': 'Laboratory Director',
          'phone': '+254 20 3540001',
          'email': 'director@lancet.co.ke',
        },
      ],
    ),
  ];

  /// Get all healthcare facilities with updated ratings
  static List<HealthcareFacility> getAllFacilities() {
    return _facilities
        .map((facility) => _updateFacilityRating(facility))
        .toList();
  }

  /// Update facility rating from review service
  static HealthcareFacility _updateFacilityRating(HealthcareFacility facility) {
    final facilityRating = ReviewService.getProviderRating(facility.id);
    return facility.copyWith(
      rating: facilityRating.averageRating > 0
          ? facilityRating.averageRating
          : facility.rating,
      reviewCount: facilityRating.totalReviews > 0
          ? facilityRating.totalReviews
          : facility.reviewCount,
    );
  }

  /// Get facility by ID with updated rating
  static HealthcareFacility? getFacilityById(String id) {
    try {
      final facility = _facilities.firstWhere((facility) => facility.id == id);
      return _updateFacilityRating(facility);
    } catch (e) {
      return null;
    }
  }

  /// Get facility by name (for navigation from home screen)
  static HealthcareFacility? getFacilityByName(String name) {
    try {
      return _facilities.firstWhere(
        (facility) => facility.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get facilities by type
  static List<HealthcareFacility> getFacilitiesByType(FacilityType type) {
    return _facilities.where((facility) => facility.type == type).toList();
  }

  /// Search facilities
  static List<HealthcareFacility> searchFacilities(String query) {
    if (query.isEmpty) return getAllFacilities();

    final lowercaseQuery = query.toLowerCase();
    return _facilities
        .where(
          (facility) =>
              facility.name.toLowerCase().contains(lowercaseQuery) ||
              facility.description.toLowerCase().contains(lowercaseQuery) ||
              facility.services.any(
                (service) => service.toLowerCase().contains(lowercaseQuery),
              ) ||
              facility.specialties.any(
                (specialty) => specialty.toLowerCase().contains(lowercaseQuery),
              ),
        )
        .toList();
  }

  /// Toggle favorite status
  static void toggleFavorite(String facilityId) {
    final index = _facilities.indexWhere(
      (facility) => facility.id == facilityId,
    );
    if (index != -1) {
      _facilities[index].isFavorite = !_facilities[index].isFavorite;
    }
  }

  /// Get favorite facilities
  static List<HealthcareFacility> getFavoriteFacilities() {
    return _facilities.where((facility) => facility.isFavorite).toList();
  }

  /// Get facilities by rating
  static List<HealthcareFacility> getFacilitiesByRating(double minRating) {
    return _facilities
        .where((facility) => facility.rating >= minRating)
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  /// Get facilities with emergency services
  static List<HealthcareFacility> getEmergencyFacilities() {
    return _facilities.where((facility) => facility.emergencyServices).toList();
  }

  /// Get facilities by insurance
  static List<HealthcareFacility> getFacilitiesByInsurance(String insurance) {
    return _facilities
        .where(
          (facility) => facility.insuranceAccepted.any(
            (ins) => ins.toLowerCase().contains(insurance.toLowerCase()),
          ),
        )
        .toList();
  }
}
