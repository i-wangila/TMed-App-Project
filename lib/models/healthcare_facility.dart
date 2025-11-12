enum FacilityType { hospital, pharmacy, laboratory, clinic }

class HealthcareFacility {
  final String id;
  final String name;
  final FacilityType type;
  final double rating;
  final int reviewCount;
  final String description;
  final String address;
  final String phone;
  final String email;
  final String website;
  final List<String> services;
  final Map<String, String> workingHours;
  final List<String> departments;
  final List<String> specialties;
  final List<String> facilities;
  final List<String> insuranceAccepted;
  final bool emergencyServices;
  final bool parkingAvailable;
  final bool wheelchairAccessible;
  final String imageUrl;
  final Map<String, dynamic> location;
  final List<String> certifications;
  final String establishedYear;
  final int bedCapacity;
  final List<Map<String, dynamic>> contactPersons;
  bool isFavorite;

  HealthcareFacility({
    required this.id,
    required this.name,
    required this.type,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.services,
    required this.workingHours,
    required this.departments,
    required this.specialties,
    required this.facilities,
    required this.insuranceAccepted,
    required this.emergencyServices,
    required this.parkingAvailable,
    required this.wheelchairAccessible,
    required this.imageUrl,
    required this.location,
    required this.certifications,
    required this.establishedYear,
    required this.bedCapacity,
    required this.contactPersons,
    this.isFavorite = false,
  });

  String get typeDisplayName {
    switch (type) {
      case FacilityType.hospital:
        return 'Hospital';
      case FacilityType.pharmacy:
        return 'Pharmacy';
      case FacilityType.laboratory:
        return 'Laboratory';
      case FacilityType.clinic:
        return 'Clinic';
    }
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString(),
      'rating': rating,
      'reviewCount': reviewCount,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'services': services,
      'workingHours': workingHours,
      'departments': departments,
      'specialties': specialties,
      'facilities': facilities,
      'insuranceAccepted': insuranceAccepted,
      'emergencyServices': emergencyServices,
      'parkingAvailable': parkingAvailable,
      'wheelchairAccessible': wheelchairAccessible,
      'imageUrl': imageUrl,
      'location': location,
      'certifications': certifications,
      'establishedYear': establishedYear,
      'bedCapacity': bedCapacity,
      'contactPersons': contactPersons,
      'isFavorite': isFavorite,
    };
  }

  // Create from JSON
  factory HealthcareFacility.fromJson(Map<String, dynamic> json) {
    return HealthcareFacility(
      id: json['id'],
      name: json['name'],
      type: FacilityType.values.firstWhere((e) => e.toString() == json['type']),
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      services: List<String>.from(json['services']),
      workingHours: Map<String, String>.from(json['workingHours']),
      departments: List<String>.from(json['departments']),
      specialties: List<String>.from(json['specialties']),
      facilities: List<String>.from(json['facilities']),
      insuranceAccepted: List<String>.from(json['insuranceAccepted']),
      emergencyServices: json['emergencyServices'],
      parkingAvailable: json['parkingAvailable'],
      wheelchairAccessible: json['wheelchairAccessible'],
      imageUrl: json['imageUrl'],
      location: Map<String, dynamic>.from(json['location']),
      certifications: List<String>.from(json['certifications']),
      establishedYear: json['establishedYear'],
      bedCapacity: json['bedCapacity'],
      contactPersons: List<Map<String, dynamic>>.from(json['contactPersons']),
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  // Copy with method
  HealthcareFacility copyWith({
    String? id,
    String? name,
    FacilityType? type,
    double? rating,
    int? reviewCount,
    String? description,
    String? address,
    String? phone,
    String? email,
    String? website,
    List<String>? services,
    Map<String, String>? workingHours,
    List<String>? departments,
    List<String>? specialties,
    List<String>? facilities,
    List<String>? insuranceAccepted,
    bool? emergencyServices,
    bool? parkingAvailable,
    bool? wheelchairAccessible,
    String? imageUrl,
    Map<String, dynamic>? location,
    List<String>? certifications,
    String? establishedYear,
    int? bedCapacity,
    List<Map<String, dynamic>>? contactPersons,
    bool? isFavorite,
  }) {
    return HealthcareFacility(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description ?? this.description,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      services: services ?? this.services,
      workingHours: workingHours ?? this.workingHours,
      departments: departments ?? this.departments,
      specialties: specialties ?? this.specialties,
      facilities: facilities ?? this.facilities,
      insuranceAccepted: insuranceAccepted ?? this.insuranceAccepted,
      emergencyServices: emergencyServices ?? this.emergencyServices,
      parkingAvailable: parkingAvailable ?? this.parkingAvailable,
      wheelchairAccessible: wheelchairAccessible ?? this.wheelchairAccessible,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
      certifications: certifications ?? this.certifications,
      establishedYear: establishedYear ?? this.establishedYear,
      bedCapacity: bedCapacity ?? this.bedCapacity,
      contactPersons: contactPersons ?? this.contactPersons,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
