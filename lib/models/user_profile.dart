enum UserType { patient, provider }

class UserProfile {
  String name;
  String email;
  String phone;
  String? password; // For authentication
  String? profilePicturePath;
  UserType userType;
  String? specialization; // For providers
  String? licenseNumber; // For providers
  bool isOnline;
  String dateOfBirth;
  String gender;
  String address;
  String emergencyContact;
  String bloodType;
  String? weight; // in kg
  String? height; // in cm
  List<String> allergies;
  List<String> medications;
  List<String> medicalConditions;
  DateTime createdAt;
  DateTime updatedAt;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.password,
    this.profilePicturePath,
    this.userType = UserType.patient,
    this.specialization,
    this.licenseNumber,
    this.isOnline = false,
    this.dateOfBirth = '',
    this.gender = '',
    this.address = '',
    this.emergencyContact = '',
    this.bloodType = '',
    this.weight,
    this.height,
    this.allergies = const [],
    this.medications = const [],
    this.medicalConditions = const [],
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'profilePicturePath': profilePicturePath,
      'userType': userType.toString(),
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'isOnline': isOnline,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'address': address,
      'emergencyContact': emergencyContact,
      'bloodType': bloodType,
      'weight': weight,
      'height': height,
      'allergies': allergies,
      'medications': medications,
      'medicalConditions': medicalConditions,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'],
      profilePicturePath: json['profilePicturePath'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == json['userType'],
        orElse: () => UserType.patient,
      ),
      specialization: json['specialization'],
      licenseNumber: json['licenseNumber'],
      isOnline: json['isOnline'] ?? false,
      dateOfBirth: json['dateOfBirth'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      emergencyContact: json['emergencyContact'] ?? '',
      bloodType: json['bloodType'] ?? '',
      weight: json['weight'],
      height: json['height'],
      allergies: List<String>.from(json['allergies'] ?? []),
      medications: List<String>.from(json['medications'] ?? []),
      medicalConditions: List<String>.from(json['medicalConditions'] ?? []),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // Copy with method for updates
  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? password,
    String? profilePicturePath,
    UserType? userType,
    String? specialization,
    String? licenseNumber,
    bool? isOnline,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? emergencyContact,
    String? bloodType,
    String? weight,
    String? height,
    List<String>? allergies,
    List<String>? medications,
    List<String>? medicalConditions,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      userType: userType ?? this.userType,
      specialization: specialization ?? this.specialization,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      isOnline: isOnline ?? this.isOnline,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      bloodType: bloodType ?? this.bloodType,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}
