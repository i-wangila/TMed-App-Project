import '../models/healthcare_provider.dart';
import 'review_service.dart';

class HealthcareProviderService {
  static final List<HealthcareProvider> _providers = [
    HealthcareProvider(
      id: 'dr_sarah_21',
      name: 'Dr. Sarah Mwangi',
      type: 'Doctor',
      specialization: 'Cardiologist',
      rating: 4.86,
      reviewCount: 127,
      location: 'Nairobi Hospital, Nairobi',
      phone: '+254 700 123 456',
      email: 'dr.sarah.mwangi@tmed.com',
      services: [
        'Cardiology Consultation',
        'ECG',
        'Heart Surgery',
        'Preventive Care',
      ],
      isAvailable: true,
      openingHours: '8:00 AM - 6:00 PM',
      bio:
          'Dr. Sarah Mwangi is a highly experienced cardiologist with over 15 years of practice. She specializes in interventional cardiology and has performed over 500 successful cardiac procedures. She is passionate about preventive cardiology and patient education.',
      qualifications: [
        'MBChB - University of Nairobi (2008)',
        'MMed Cardiology - University of Cape Town (2013)',
        'Fellowship in Interventional Cardiology - Johns Hopkins (2015)',
      ],
      certifications: [
        'Kenya Medical Practitioners Board License',
        'American Heart Association Certification',
        'European Society of Cardiology Member',
      ],
      experienceYears: 15,
      languages: ['English', 'Swahili', 'Kikuyu'],
      consultationFee: 2150.0,
      profileImageUrl: 'https://via.placeholder.com/200',
      workingDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      timeSlots: {
        'morning': '8:00 AM - 12:00 PM',
        'afternoon': '2:00 PM - 6:00 PM',
      },
    ),
    HealthcareProvider(
      id: 'dr_john_45',
      name: 'Dr. John Kamau',
      type: 'Doctor',
      specialization: 'General Practitioner',
      rating: 4.72,
      reviewCount: 89,
      location: 'Aga Khan Hospital, Nairobi',
      phone: '+254 700 234 567',
      email: 'dr.john.kamau@tmed.com',
      services: [
        'General Consultation',
        'Health Checkups',
        'Vaccinations',
        'Minor Procedures',
      ],
      isAvailable: true,
      openingHours: '9:00 AM - 5:00 PM',
      bio:
          'Dr. John Kamau is a dedicated general practitioner with a focus on family medicine and preventive healthcare. He believes in building long-term relationships with his patients and providing comprehensive care for all ages.',
      qualifications: [
        'MBChB - Moi University (2010)',
        'Diploma in Family Medicine - KMTC (2012)',
      ],
      certifications: [
        'Kenya Medical Practitioners Board License',
        'Family Medicine Certification',
      ],
      experienceYears: 12,
      languages: ['English', 'Swahili'],
      consultationFee: 1800.0,
      profileImageUrl: 'https://via.placeholder.com/200',
      workingDays: [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
      ],
      timeSlots: {
        'morning': '9:00 AM - 1:00 PM',
        'afternoon': '2:00 PM - 5:00 PM',
      },
    ),
    HealthcareProvider(
      id: 'mary_njeri_67',
      name: 'Mary Njeri',
      type: 'Nutritionist',
      specialization: 'Clinical Nutritionist',
      rating: 4.75,
      reviewCount: 64,
      location: 'Wellness Center, Westlands',
      phone: '+254 700 345 678',
      email: 'mary.njeri@tmed.com',
      services: [
        'Nutrition Counseling',
        'Diet Planning',
        'Weight Management',
        'Sports Nutrition',
      ],
      isAvailable: true,
      openingHours: '8:00 AM - 4:00 PM',
      bio:
          'Mary Njeri is a certified clinical nutritionist with expertise in therapeutic nutrition and lifestyle medicine. She helps clients achieve their health goals through personalized nutrition plans and sustainable lifestyle changes.',
      qualifications: [
        'BSc Nutrition and Dietetics - Kenyatta University (2015)',
        'MSc Clinical Nutrition - University of Nairobi (2018)',
      ],
      certifications: [
        'Kenya Nutritionists and Dietitians Institute License',
        'Certified Diabetes Educator',
      ],
      experienceYears: 8,
      languages: ['English', 'Swahili', 'Kikuyu'],
      consultationFee: 1200.0,
      profileImageUrl: 'https://via.placeholder.com/200',
      workingDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      timeSlots: {
        'morning': '8:00 AM - 12:00 PM',
        'afternoon': '1:00 PM - 4:00 PM',
      },
    ),
  ];

  /// Get all healthcare providers with updated ratings
  static List<HealthcareProvider> getAllProviders() {
    return _providers
        .map((provider) => _updateProviderRating(provider))
        .toList();
  }

  /// Update provider rating from review service
  static HealthcareProvider _updateProviderRating(HealthcareProvider provider) {
    final providerRating = ReviewService.getProviderRating(provider.id);
    return provider.copyWith(
      rating: providerRating.averageRating > 0
          ? providerRating.averageRating
          : provider.rating,
      reviewCount: providerRating.totalReviews > 0
          ? providerRating.totalReviews
          : provider.reviewCount,
    );
  }

  /// Get provider by ID with updated rating
  static HealthcareProvider? getProviderById(String id) {
    try {
      final provider = _providers.firstWhere((provider) => provider.id == id);
      return _updateProviderRating(provider);
    } catch (e) {
      return null;
    }
  }

  /// Get providers by type
  static List<HealthcareProvider> getProvidersByType(String type) {
    return _providers
        .where(
          (provider) =>
              provider.type.toLowerCase().contains(type.toLowerCase()),
        )
        .toList();
  }

  /// Get providers by specialization
  static List<HealthcareProvider> getProvidersBySpecialization(
    String specialization,
  ) {
    return _providers
        .where(
          (provider) => provider.specialization.toLowerCase().contains(
            specialization.toLowerCase(),
          ),
        )
        .toList();
  }

  /// Search providers by name or specialization
  static List<HealthcareProvider> searchProviders(String query) {
    if (query.isEmpty) return getAllProviders();

    final lowercaseQuery = query.toLowerCase();
    return _providers
        .where(
          (provider) =>
              provider.name.toLowerCase().contains(lowercaseQuery) ||
              provider.specialization.toLowerCase().contains(lowercaseQuery) ||
              provider.type.toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }

  /// Update provider profile (for provider editing)
  static bool updateProvider(HealthcareProvider updatedProvider) {
    final index = _providers.indexWhere(
      (provider) => provider.id == updatedProvider.id,
    );
    if (index != -1) {
      _providers[index] = updatedProvider;
      return true;
    }
    return false;
  }

  /// Toggle favorite status
  static void toggleFavorite(String providerId) {
    final index = _providers.indexWhere(
      (provider) => provider.id == providerId,
    );
    if (index != -1) {
      _providers[index].isFavorite = !_providers[index].isFavorite;
    }
  }

  /// Get favorite providers
  static List<HealthcareProvider> getFavoriteProviders() {
    return _providers.where((provider) => provider.isFavorite).toList();
  }

  /// Get available providers
  static List<HealthcareProvider> getAvailableProviders() {
    return _providers.where((provider) => provider.isAvailable).toList();
  }

  /// Get providers by rating range
  static List<HealthcareProvider> getProvidersByRating(double minRating) {
    return _providers.where((provider) => provider.rating >= minRating).toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }
}
