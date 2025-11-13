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

    // Additional Clinics
    HealthcareFacility(
      id: 'westlands_clinic',
      name: 'Westlands Medical Clinic',
      type: FacilityType.clinic,
      rating: 4.67,
      reviewCount: 234,
      description:
          'A modern medical clinic providing comprehensive outpatient services in the heart of Westlands.',
      address: 'Westlands Road, Nairobi',
      phone: '+254 20 4440000',
      email: 'info@westlandsmedical.co.ke',
      website: 'www.westlandsmedical.co.ke',
      services: [
        'General Consultation',
        'Specialist Services',
        'Health Screenings',
        'Vaccinations',
        'Minor Procedures',
      ],
      workingHours: {
        'Monday': '8:00 AM - 6:00 PM',
        'Tuesday': '8:00 AM - 6:00 PM',
        'Wednesday': '8:00 AM - 6:00 PM',
        'Thursday': '8:00 AM - 6:00 PM',
        'Friday': '8:00 AM - 6:00 PM',
        'Saturday': '9:00 AM - 4:00 PM',
        'Sunday': 'Closed',
      },
      departments: ['General Medicine', 'Pediatrics', 'Gynecology'],
      specialties: ['Family Medicine', 'Preventive Care'],
      facilities: ['Consultation Rooms', 'Minor Surgery Suite', 'Pharmacy'],
      insuranceAccepted: ['NHIF', 'AAR', 'Jubilee Insurance'],
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2676,
        'longitude': 36.8108,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: ['Kenya Medical Practitioners Board Licensed'],
      establishedYear: '2010',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Michael Ochieng',
          'position': 'Medical Director',
          'phone': '+254 20 4440001',
          'email': 'director@westlandsmedical.co.ke',
        },
      ],
    ),

    // More Hospitals
    HealthcareFacility(
      id: 'kenyatta_hospital',
      name: 'Kenyatta National Hospital',
      type: FacilityType.hospital,
      rating: 4.72,
      reviewCount: 1856,
      description:
          'Kenya\'s largest referral and teaching hospital providing comprehensive healthcare services.',
      address: 'Hospital Road, Upper Hill, Nairobi',
      phone: '+254 20 2726300',
      email: 'info@knh.or.ke',
      website: 'www.knh.or.ke',
      services: [
        'Emergency Services',
        'Specialized Surgery',
        'Cancer Treatment',
        'Kidney Transplant',
        'Heart Surgery',
        'Neurosurgery',
        'Maternity Services',
        'Pediatric Care',
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
        'Nephrology',
        'Pediatrics',
        'Surgery',
        'Emergency Medicine',
      ],
      specialties: [
        'Organ Transplant',
        'Cancer Treatment',
        'Heart Surgery',
        'Brain Surgery',
        'Kidney Dialysis',
      ],
      facilities: [
        'ICU',
        'Operating Theaters',
        'CT Scan',
        'MRI',
        'Dialysis Unit',
        'Blood Bank',
        'Pharmacy',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'CIC Insurance',
        'Madison Insurance',
      ],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.3018,
        'longitude': 36.8073,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'Ministry of Health Licensed',
        'ISO 9001:2015 Certified',
      ],
      establishedYear: '1901',
      bedCapacity: 1800,
      contactPersons: [
        {
          'name': 'Dr. Evanson Kamuri',
          'position': 'Chief Executive Officer',
          'phone': '+254 20 2726301',
          'email': 'ceo@knh.or.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'mp_shah_hospital',
      name: 'MP Shah Hospital',
      type: FacilityType.hospital,
      rating: 4.68,
      reviewCount: 743,
      description:
          'A leading private hospital in Nairobi providing quality healthcare services for over 80 years.',
      address: 'Shivachi Road, Parklands, Nairobi',
      phone: '+254 20 3742763',
      email: 'info@mpshahhosp.org',
      website: 'www.mpshahhosp.org',
      services: [
        'Emergency Services',
        'Surgery',
        'Maternity Services',
        'Cardiology',
        'Orthopedics',
        'Radiology',
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
        'Orthopedics',
        'Pediatrics',
        'Surgery',
        'Radiology',
        'Emergency Medicine',
      ],
      specialties: [
        'Heart Surgery',
        'Joint Replacement',
        'Maternity Care',
        'Emergency Medicine',
      ],
      facilities: [
        'ICU',
        'Operating Theaters',
        'CT Scan',
        'X-Ray',
        'Ultrasound',
        'Pharmacy',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'Resolution Insurance',
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
        'Ministry of Health Licensed',
        'Joint Commission International Standards',
      ],
      establishedYear: '1931',
      bedCapacity: 180,
      contactPersons: [
        {
          'name': 'Dr. Kiran Patel',
          'position': 'Medical Director',
          'phone': '+254 20 3742764',
          'email': 'medical.director@mpshahhosp.org',
        },
      ],
    ),

    // More Clinics
    HealthcareFacility(
      id: 'karen_hospital',
      name: 'Karen Hospital',
      type: FacilityType.hospital,
      rating: 4.78,
      reviewCount: 567,
      description:
          'A modern hospital in Karen providing comprehensive healthcare services in a serene environment.',
      address: 'Karen Road, Karen, Nairobi',
      phone: '+254 20 6600000',
      email: 'info@karenhospital.org',
      website: 'www.karenhospital.org',
      services: [
        'Emergency Services',
        'Surgery',
        'Maternity Services',
        'Pediatrics',
        'Radiology',
        'Laboratory Services',
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
        'General Medicine',
        'Surgery',
        'Pediatrics',
        'Obstetrics & Gynecology',
        'Radiology',
      ],
      specialties: [
        'Minimally Invasive Surgery',
        'Maternity Care',
        'Pediatric Care',
        'Emergency Medicine',
      ],
      facilities: [
        'Operating Theaters',
        'CT Scan',
        'Ultrasound',
        'Laboratory',
        'Pharmacy',
        'Physiotherapy Unit',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'Madison Insurance',
      ],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.3197,
        'longitude': 36.7073,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'Ministry of Health Licensed',
        'ISO 9001:2015 Certified',
      ],
      establishedYear: '1994',
      bedCapacity: 120,
      contactPersons: [
        {
          'name': 'Dr. Dan Gikonyo',
          'position': 'Medical Director',
          'phone': '+254 20 6600001',
          'email': 'medical.director@karenhospital.org',
        },
      ],
    ),

    // More Pharmacies
    HealthcareFacility(
      id: 'haltons_pharmacy',
      name: 'Haltons Pharmacy',
      type: FacilityType.pharmacy,
      rating: 4.94,
      reviewCount: 892,
      description:
          'A trusted pharmacy chain providing quality pharmaceutical products and healthcare services.',
      address: 'Multiple Locations Across Kenya',
      phone: '+254 20 2712345',
      email: 'info@haltons.co.ke',
      website: 'www.haltons.co.ke',
      services: [
        'Prescription Dispensing',
        'Over-the-Counter Medications',
        'Health Consultations',
        'Medical Equipment',
        'Health Screenings',
        'Vaccination Services',
        'Home Delivery',
      ],
      workingHours: {
        'Monday': '8:00 AM - 9:00 PM',
        'Tuesday': '8:00 AM - 9:00 PM',
        'Wednesday': '8:00 AM - 9:00 PM',
        'Thursday': '8:00 AM - 9:00 PM',
        'Friday': '8:00 AM - 9:00 PM',
        'Saturday': '8:00 AM - 9:00 PM',
        'Sunday': '9:00 AM - 8:00 PM',
      },
      departments: [
        'Prescription Department',
        'OTC Department',
        'Medical Equipment',
        'Beauty & Wellness',
      ],
      specialties: [
        'Chronic Disease Management',
        'Pediatric Medications',
        'Women\'s Health',
        'Elderly Care',
      ],
      facilities: [
        'Consultation Rooms',
        'Blood Pressure Monitoring',
        'Diabetes Testing',
        'Weight Management',
        'Cold Storage',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'Madison Insurance',
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
        'Good Pharmacy Practice Certified',
      ],
      establishedYear: '1992',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Rajesh Patel',
          'position': 'Chief Pharmacist',
          'phone': '+254 20 2712346',
          'email': 'chief.pharmacist@haltons.co.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'mediplus_pharmacy',
      name: 'Mediplus Pharmacy',
      type: FacilityType.pharmacy,
      rating: 4.78,
      reviewCount: 456,
      description:
          'Your neighborhood pharmacy providing personalized healthcare solutions and quality medications.',
      address: 'Kimathi Street, Nairobi CBD',
      phone: '+254 20 2234567',
      email: 'info@mediplus.co.ke',
      website: 'www.mediplus.co.ke',
      services: [
        'Prescription Dispensing',
        'Health Consultations',
        'Blood Pressure Monitoring',
        'Diabetes Testing',
        'Medical Supplies',
        'Health Products',
      ],
      workingHours: {
        'Monday': '8:00 AM - 8:00 PM',
        'Tuesday': '8:00 AM - 8:00 PM',
        'Wednesday': '8:00 AM - 8:00 PM',
        'Thursday': '8:00 AM - 8:00 PM',
        'Friday': '8:00 AM - 8:00 PM',
        'Saturday': '9:00 AM - 6:00 PM',
        'Sunday': '10:00 AM - 4:00 PM',
      },
      departments: [
        'Prescription Services',
        'Health & Wellness',
        'Medical Devices',
      ],
      specialties: [
        'Medication Counseling',
        'Health Monitoring',
        'Chronic Care Support',
      ],
      facilities: [
        'Private Consultation Room',
        'Health Monitoring Equipment',
        'Refrigerated Storage',
      ],
      insuranceAccepted: ['NHIF', 'AAR', 'Jubilee Insurance'],
      emergencyServices: false,
      parkingAvailable: false,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2864,
        'longitude': 36.8172,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: ['Pharmacy and Poisons Board Licensed'],
      establishedYear: '2005',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Grace Muthoni',
          'position': 'Pharmacist in Charge',
          'phone': '+254 20 2234568',
          'email': 'pharmacist@mediplus.co.ke',
        },
      ],
    ),

    // More Laboratories
    HealthcareFacility(
      id: 'pathologists_lancet',
      name: 'Pathologists Lancet Kenya',
      type: FacilityType.laboratory,
      rating: 5.0,
      reviewCount: 678,
      description:
          'Leading pathology laboratory providing accurate and timely diagnostic services.',
      address: 'Argwings Kodhek Road, Hurlingham, Nairobi',
      phone: '+254 20 2717077',
      email: 'info@pathologists.co.ke',
      website: 'www.pathologists.co.ke',
      services: [
        'Histopathology',
        'Cytology',
        'Clinical Chemistry',
        'Hematology',
        'Microbiology',
        'Immunology',
        'Molecular Diagnostics',
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
        'Histopathology',
        'Clinical Chemistry',
        'Hematology',
        'Microbiology',
        'Immunology',
      ],
      specialties: [
        'Cancer Diagnosis',
        'Infectious Disease Testing',
        'Hormone Analysis',
        'Genetic Testing',
      ],
      facilities: [
        'Advanced Microscopy',
        'Automated Analyzers',
        'PCR Laboratory',
        'Flow Cytometry',
        'Tissue Processing',
      ],
      insuranceAccepted: ['NHIF', 'AAR', 'Jubilee Insurance', 'CIC Insurance'],
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
        'ISO 15189 Accredited',
        'CAP Proficiency Testing',
        'KENAS Accredited',
      ],
      establishedYear: '1985',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Kiprotich Bett',
          'position': 'Chief Pathologist',
          'phone': '+254 20 2717078',
          'email': 'chief.pathologist@pathologists.co.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'ampath_laboratory',
      name: 'Ampath Laboratory',
      type: FacilityType.laboratory,
      rating: 4.67,
      reviewCount: 334,
      description:
          'Comprehensive laboratory services with a focus on quality and patient care.',
      address: 'Eldoret Road, Nairobi',
      phone: '+254 20 2345678',
      email: 'info@ampath.co.ke',
      website: 'www.ampath.co.ke',
      services: [
        'Blood Tests',
        'Urine Analysis',
        'Stool Analysis',
        'Microbiology',
        'Clinical Chemistry',
        'Serology',
        'Home Sample Collection',
      ],
      workingHours: {
        'Monday': '6:30 AM - 5:30 PM',
        'Tuesday': '6:30 AM - 5:30 PM',
        'Wednesday': '6:30 AM - 5:30 PM',
        'Thursday': '6:30 AM - 5:30 PM',
        'Friday': '6:30 AM - 5:30 PM',
        'Saturday': '7:00 AM - 3:00 PM',
        'Sunday': 'Closed',
      },
      departments: [
        'Clinical Chemistry',
        'Hematology',
        'Microbiology',
        'Serology',
      ],
      specialties: [
        'Routine Blood Work',
        'Infectious Disease Testing',
        'Diabetes Monitoring',
        'Lipid Profiles',
      ],
      facilities: [
        'Sample Collection Centers',
        'Automated Analyzers',
        'Quality Control Lab',
        'Cold Chain Storage',
      ],
      insuranceAccepted: ['NHIF', 'AAR', 'Madison Insurance'],
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2500,
        'longitude': 36.8000,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: ['ISO 15189 Accredited', 'KENAS Accredited'],
      establishedYear: '2001',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Samuel Rotich',
          'position': 'Laboratory Director',
          'phone': '+254 20 2345679',
          'email': 'director@ampath.co.ke',
        },
      ],
    ),

    // Specialized Clinics
    HealthcareFacility(
      id: 'avenue_healthcare',
      name: 'Avenue Healthcare',
      type: FacilityType.clinic,
      rating: 4.76,
      reviewCount: 289,
      description:
          'A modern healthcare facility offering specialized medical services and wellness programs.',
      address: '6th Avenue, Parklands, Nairobi',
      phone: '+254 20 3748000',
      email: 'info@avenuehealthcare.co.ke',
      website: 'www.avenuehealthcare.co.ke',
      services: [
        'General Medicine',
        'Specialist Consultations',
        'Health Screenings',
        'Wellness Programs',
        'Occupational Health',
        'Travel Medicine',
      ],
      workingHours: {
        'Monday': '7:00 AM - 7:00 PM',
        'Tuesday': '7:00 AM - 7:00 PM',
        'Wednesday': '7:00 AM - 7:00 PM',
        'Thursday': '7:00 AM - 7:00 PM',
        'Friday': '7:00 AM - 7:00 PM',
        'Saturday': '8:00 AM - 5:00 PM',
        'Sunday': '9:00 AM - 3:00 PM',
      },
      departments: [
        'General Medicine',
        'Cardiology',
        'Dermatology',
        'Wellness Center',
      ],
      specialties: [
        'Executive Health Checkups',
        'Preventive Medicine',
        'Travel Health',
        'Occupational Medicine',
      ],
      facilities: [
        'Executive Suites',
        'Wellness Center',
        'Diagnostic Center',
        'Pharmacy',
        'Cafeteria',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'Madison Insurance',
        'Britam',
      ],
      emergencyServices: false,
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
        'Ministry of Health Licensed',
        'ISO 9001:2015 Certified',
      ],
      establishedYear: '2008',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Priya Sharma',
          'position': 'Medical Director',
          'phone': '+254 20 3748001',
          'email': 'medical.director@avenuehealthcare.co.ke',
        },
      ],
    ),

    // Dental Clinic
    HealthcareFacility(
      id: 'smile_dental_clinic',
      name: 'Smile Dental Clinic',
      type: FacilityType.clinic,
      rating: 4.89,
      reviewCount: 156,
      description:
          'A state-of-the-art dental clinic providing comprehensive oral healthcare services.',
      address: 'Moi Avenue, Nairobi CBD',
      phone: '+254 20 2345000',
      email: 'info@smiledentalke.com',
      website: 'www.smiledentalke.com',
      services: [
        'General Dentistry',
        'Cosmetic Dentistry',
        'Orthodontics',
        'Oral Surgery',
        'Teeth Whitening',
        'Dental Implants',
      ],
      workingHours: {
        'Monday': '8:00 AM - 6:00 PM',
        'Tuesday': '8:00 AM - 6:00 PM',
        'Wednesday': '8:00 AM - 6:00 PM',
        'Thursday': '8:00 AM - 6:00 PM',
        'Friday': '8:00 AM - 6:00 PM',
        'Saturday': '9:00 AM - 4:00 PM',
        'Sunday': 'Closed',
      },
      departments: [
        'General Dentistry',
        'Orthodontics',
        'Oral Surgery',
        'Cosmetic Dentistry',
      ],
      specialties: [
        'Smile Makeovers',
        'Invisible Braces',
        'Dental Implants',
        'Root Canal Treatment',
      ],
      facilities: [
        'Digital X-Ray',
        'Laser Dentistry',
        'Sterilization Center',
        'Patient Lounge',
      ],
      insuranceAccepted: ['NHIF', 'AAR', 'Jubilee Insurance'],
      emergencyServices: false,
      parkingAvailable: false,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2864,
        'longitude': 36.8172,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'Kenya Dental Association Approved',
        'Infection Control Certified',
      ],
      establishedYear: '2012',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Ahmed Hassan',
          'position': 'Chief Dentist',
          'phone': '+254 20 2345001',
          'email': 'chief.dentist@smiledentalke.com',
        },
      ],
    ),

    // Additional Laboratories
    HealthcareFacility(
      id: 'quest_diagnostics',
      name: 'Quest Diagnostics Kenya',
      type: FacilityType.laboratory,
      rating: 4.72,
      reviewCount: 567,
      description:
          'Leading diagnostic laboratory offering comprehensive testing services with advanced technology and accurate results.',
      address: 'Westlands Square, Westlands, Nairobi',
      phone: '+254 20 4448000',
      email: 'info@questdiagnostics.co.ke',
      website: 'www.questdiagnostics.co.ke',
      services: [
        'Blood Tests',
        'Urine Analysis',
        'Stool Tests',
        'Hormonal Tests',
        'Cardiac Markers',
        'Liver Function Tests',
        'Kidney Function Tests',
        'Diabetes Tests',
        'Thyroid Tests',
        'Cancer Markers',
        'Pregnancy Tests',
        'STD Testing',
        'Drug Testing',
        'Genetic Testing',
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
        'Molecular Diagnostics',
      ],
      specialties: [
        'Advanced Molecular Testing',
        'Genetic Screening',
        'Specialized Cancer Markers',
        'Infectious Disease Testing',
      ],
      facilities: [
        'Sample Collection Centers',
        'Advanced Laboratory Equipment',
        'Quality Control Lab',
        'Patient Waiting Area',
        'Parking',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'CIC Insurance',
        'Madison Insurance',
        'Britam',
      ],
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2676,
        'longitude': 36.8108,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'ISO 15189 Accredited',
        'KENAS Accredited',
        'Ministry of Health Licensed',
      ],
      establishedYear: '2010',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Sarah Kimani',
          'position': 'Laboratory Director',
          'phone': '+254 20 4448001',
          'email': 'director@questdiagnostics.co.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'metroplex_laboratory',
      name: 'Metroplex Laboratory Services',
      type: FacilityType.laboratory,
      rating: 4.85,
      reviewCount: 423,
      description:
          'Modern laboratory facility providing fast, accurate diagnostic services with state-of-the-art equipment and experienced technologists.',
      address: 'Mombasa Road, Industrial Area, Nairobi',
      phone: '+254 20 6789000',
      email: 'info@metroplexlab.co.ke',
      website: 'www.metroplexlab.co.ke',
      services: [
        'Complete Blood Count',
        'Chemistry Panel',
        'Lipid Profile',
        'Liver Panel',
        'Kidney Panel',
        'Electrolyte Panel',
        'Coagulation Studies',
        'Tumor Markers',
        'Allergy Testing',
        'Autoimmune Tests',
        'Vitamin Levels',
        'Trace Elements',
        'Toxicology',
        'Pathology Services',
      ],
      workingHours: {
        'Monday': '5:30 AM - 7:00 PM',
        'Tuesday': '5:30 AM - 7:00 PM',
        'Wednesday': '5:30 AM - 7:00 PM',
        'Thursday': '5:30 AM - 7:00 PM',
        'Friday': '5:30 AM - 7:00 PM',
        'Saturday': '6:00 AM - 5:00 PM',
        'Sunday': '7:00 AM - 3:00 PM',
      },
      departments: [
        'Clinical Pathology',
        'Biochemistry',
        'Hematology',
        'Serology',
        'Histopathology',
      ],
      specialties: [
        'Rapid Testing',
        'Point-of-Care Testing',
        'Specialized Pathology',
        'Corporate Health Packages',
      ],
      facilities: [
        'Multiple Collection Points',
        'Automated Analyzers',
        'Digital Reporting System',
        'Customer Service Center',
        'Free Parking',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'Madison Insurance',
        'APA Insurance',
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
        'ISO 15189 Certified',
        'KENAS Accredited',
        'CAP Accredited',
      ],
      establishedYear: '2015',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Michael Ochieng',
          'position': 'Chief Pathologist',
          'phone': '+254 20 6789001',
          'email': 'pathologist@metroplexlab.co.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'precision_diagnostics',
      name: 'Precision Diagnostics Center',
      type: FacilityType.laboratory,
      rating: 4.91,
      reviewCount: 678,
      description:
          'Premium diagnostic center offering comprehensive laboratory services with cutting-edge technology and personalized patient care.',
      address: 'Karen Shopping Center, Karen, Nairobi',
      phone: '+254 20 3456000',
      email: 'info@precisiondiagnostics.co.ke',
      website: 'www.precisiondiagnostics.co.ke',
      services: [
        'Routine Blood Work',
        'Specialized Testing',
        'Molecular Diagnostics',
        'Cytogenetics',
        'Flow Cytometry',
        'Immunohistochemistry',
        'PCR Testing',
        'ELISA Testing',
        'Western Blot',
        'Karyotyping',
        'FISH Analysis',
        'Next Generation Sequencing',
        'Pharmacogenomics',
        'Nutrigenomics',
      ],
      workingHours: {
        'Monday': '6:00 AM - 8:00 PM',
        'Tuesday': '6:00 AM - 8:00 PM',
        'Wednesday': '6:00 AM - 8:00 PM',
        'Thursday': '6:00 AM - 8:00 PM',
        'Friday': '6:00 AM - 8:00 PM',
        'Saturday': '7:00 AM - 6:00 PM',
        'Sunday': '8:00 AM - 4:00 PM',
      },
      departments: [
        'Molecular Biology',
        'Genetics',
        'Advanced Immunology',
        'Specialized Chemistry',
        'Research Laboratory',
      ],
      specialties: [
        'Genetic Counseling',
        'Personalized Medicine',
        'Research Collaboration',
        'Executive Health Screening',
      ],
      facilities: [
        'VIP Collection Suites',
        'Research Facilities',
        'Genetic Counseling Rooms',
        'Conference Facilities',
        'Valet Parking',
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
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.3197,
        'longitude': 36.7073,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'ISO 15189 Accredited',
        'CAP Accredited',
        'CLIA Certified',
        'Research Ethics Approved',
      ],
      establishedYear: '2018',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Grace Wanjiku',
          'position': 'Medical Director',
          'phone': '+254 20 3456001',
          'email': 'director@precisiondiagnostics.co.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'biolab_diagnostics',
      name: 'BioLab Diagnostics',
      type: FacilityType.laboratory,
      rating: 4.68,
      reviewCount: 389,
      description:
          'Comprehensive diagnostic laboratory providing reliable testing services with quick turnaround times and affordable pricing.',
      address: 'Thika Road Mall, Kasarani, Nairobi',
      phone: '+254 20 5678000',
      email: 'info@biolabdiagnostics.co.ke',
      website: 'www.biolabdiagnostics.co.ke',
      services: [
        'Basic Blood Tests',
        'Urinalysis',
        'Stool Analysis',
        'Pregnancy Tests',
        'Diabetes Screening',
        'Cholesterol Tests',
        'Hepatitis Screening',
        'HIV Testing',
        'Malaria Tests',
        'Typhoid Tests',
        'Blood Grouping',
        'Cross Matching',
        'Semen Analysis',
        'Pap Smear',
      ],
      workingHours: {
        'Monday': '6:00 AM - 6:00 PM',
        'Tuesday': '6:00 AM - 6:00 PM',
        'Wednesday': '6:00 AM - 6:00 PM',
        'Thursday': '6:00 AM - 6:00 PM',
        'Friday': '6:00 AM - 6:00 PM',
        'Saturday': '7:00 AM - 4:00 PM',
        'Sunday': 'Closed',
      },
      departments: [
        'General Laboratory',
        'Microbiology',
        'Parasitology',
        'Blood Bank',
      ],
      specialties: [
        'Affordable Testing',
        'Community Health Screening',
        'School Health Programs',
        'Corporate Packages',
      ],
      facilities: [
        'Community Collection Centers',
        'Mobile Laboratory Services',
        'Online Results Portal',
        'Customer Care Center',
      ],
      insuranceAccepted: ['NHIF', 'AAR', 'Madison Insurance'],
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2297,
        'longitude': 36.8925,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: ['Ministry of Health Licensed', 'KENAS Accredited'],
      establishedYear: '2012',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Peter Mwangi',
          'position': 'Laboratory Manager',
          'phone': '+254 20 5678001',
          'email': 'manager@biolabdiagnostics.co.ke',
        },
      ],
    ),

    // Additional Pharmacies
    HealthcareFacility(
      id: 'wellness_pharmacy',
      name: 'Wellness Pharmacy',
      type: FacilityType.pharmacy,
      rating: 4.87,
      reviewCount: 734,
      description:
          'Your neighborhood pharmacy providing quality medications, health products, and professional pharmaceutical services.',
      address: 'Sarit Center, Westlands, Nairobi',
      phone: '+254 20 4567000',
      email: 'info@wellnesspharmacy.co.ke',
      website: 'www.wellnesspharmacy.co.ke',
      services: [
        'Prescription Dispensing',
        'Over-the-Counter Medications',
        'Health Consultations',
        'Blood Pressure Monitoring',
        'Blood Sugar Testing',
        'Weight Management',
        'Vaccination Services',
        'Medical Equipment Sales',
        'Home Delivery',
        'Insurance Claims Processing',
        'Medication Therapy Management',
        'Health Screenings',
        'First Aid Supplies',
        'Baby Care Products',
      ],
      workingHours: {
        'Monday': '8:00 AM - 9:00 PM',
        'Tuesday': '8:00 AM - 9:00 PM',
        'Wednesday': '8:00 AM - 9:00 PM',
        'Thursday': '8:00 AM - 9:00 PM',
        'Friday': '8:00 AM - 9:00 PM',
        'Saturday': '8:00 AM - 8:00 PM',
        'Sunday': '9:00 AM - 6:00 PM',
      },
      departments: [
        'Prescription Department',
        'OTC Department',
        'Health & Wellness',
        'Medical Devices',
      ],
      specialties: [
        'Chronic Disease Management',
        'Pediatric Medications',
        'Geriatric Care',
        'Travel Health',
      ],
      facilities: [
        'Drive-Through Service',
        'Consultation Rooms',
        'Health Screening Area',
        'Customer Parking',
        'Wheelchair Access',
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
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2676,
        'longitude': 36.8108,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'Pharmacy and Poisons Board Licensed',
        'ISO 9001:2015 Certified',
        'Good Pharmacy Practice Certified',
      ],
      establishedYear: '2005',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Pharm. Jane Wanjiru',
          'position': 'Chief Pharmacist',
          'phone': '+254 20 4567001',
          'email': 'chief.pharmacist@wellnesspharmacy.co.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'careplus_pharmacy',
      name: 'CarePlus Pharmacy',
      type: FacilityType.pharmacy,
      rating: 4.93,
      reviewCount: 892,
      description:
          'Modern pharmacy chain offering comprehensive pharmaceutical services with multiple locations across Nairobi.',
      address: 'Junction Mall, Ngong Road, Nairobi',
      phone: '+254 20 7890000',
      email: 'info@carepluspharmacy.co.ke',
      website: 'www.carepluspharmacy.co.ke',
      services: [
        'Prescription Medications',
        'Generic Alternatives',
        'Specialty Medications',
        'Compounding Services',
        'Medication Synchronization',
        'Adherence Packaging',
        'Health Monitoring',
        'Immunizations',
        'Travel Clinic',
        'Diabetes Care',
        'Hypertension Management',
        'Cholesterol Screening',
        'Online Ordering',
        'Mobile App Services',
      ],
      workingHours: {
        'Monday': '7:00 AM - 10:00 PM',
        'Tuesday': '7:00 AM - 10:00 PM',
        'Wednesday': '7:00 AM - 10:00 PM',
        'Thursday': '7:00 AM - 10:00 PM',
        'Friday': '7:00 AM - 10:00 PM',
        'Saturday': '8:00 AM - 9:00 PM',
        'Sunday': '9:00 AM - 7:00 PM',
      },
      departments: [
        'Retail Pharmacy',
        'Clinical Services',
        'Specialty Pharmacy',
        'Wellness Center',
      ],
      specialties: [
        'Medication Therapy Management',
        'Clinical Pharmacy Services',
        'Specialty Drug Management',
        'Health and Wellness Programs',
      ],
      facilities: [
        'Multiple Locations',
        'Clinical Consultation Rooms',
        'Health Screening Stations',
        'Online Platform',
        'Mobile App',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'CIC Insurance',
        'Madison Insurance',
        'Britam',
        'APA Insurance',
        'Resolution Insurance',
      ],
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.3031,
        'longitude': 36.7827,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'Pharmacy and Poisons Board Licensed',
        'ISO 9001:2015 Certified',
        'Good Pharmacy Practice Certified',
        'NABP Accredited',
      ],
      establishedYear: '2008',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Pharm. David Kiprotich',
          'position': 'Regional Manager',
          'phone': '+254 20 7890001',
          'email': 'regional.manager@carepluspharmacy.co.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'healthmart_pharmacy',
      name: 'HealthMart Pharmacy',
      type: FacilityType.pharmacy,
      rating: 4.76,
      reviewCount: 567,
      description:
          'Community-focused pharmacy providing personalized pharmaceutical care and health services to local residents.',
      address: 'Eastleigh Section 1, Nairobi',
      phone: '+254 20 8901000',
      email: 'info@healthmartpharmacy.co.ke',
      website: 'www.healthmartpharmacy.co.ke',
      services: [
        'Prescription Services',
        'Health Consultations',
        'Medication Reviews',
        'Blood Pressure Checks',
        'Diabetes Monitoring',
        'Cholesterol Testing',
        'BMI Calculations',
        'Medication Disposal',
        'Health Education',
        'Chronic Care Management',
        'Pediatric Services',
        'Elderly Care',
        'Emergency Contraception',
        'Smoking Cessation',
      ],
      workingHours: {
        'Monday': '8:00 AM - 8:00 PM',
        'Tuesday': '8:00 AM - 8:00 PM',
        'Wednesday': '8:00 AM - 8:00 PM',
        'Thursday': '8:00 AM - 8:00 PM',
        'Friday': '8:00 AM - 8:00 PM',
        'Saturday': '8:00 AM - 6:00 PM',
        'Sunday': '10:00 AM - 4:00 PM',
      },
      departments: [
        'Community Pharmacy',
        'Health Services',
        'Wellness Products',
        'Medical Supplies',
      ],
      specialties: [
        'Community Health Programs',
        'Medication Adherence Support',
        'Health Education Workshops',
        'Chronic Disease Support Groups',
      ],
      facilities: [
        'Community Health Center',
        'Private Consultation Rooms',
        'Health Education Area',
        'Medication Storage Facility',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Madison Insurance',
        'Jubilee Insurance',
      ],
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2921,
        'longitude': 36.8447,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'Pharmacy and Poisons Board Licensed',
        'Good Pharmacy Practice Certified',
        'Community Health Certified',
      ],
      establishedYear: '2010',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Pharm. Amina Hassan',
          'position': 'Pharmacy Manager',
          'phone': '+254 20 8901001',
          'email': 'manager@healthmartpharmacy.co.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'prime_pharmacy',
      name: 'Prime Pharmacy',
      type: FacilityType.pharmacy,
      rating: 4.82,
      reviewCount: 445,
      description:
          'Premium pharmacy offering high-quality medications and specialized pharmaceutical services with professional care.',
      address: 'Yaya Center, Kilimani, Nairobi',
      phone: '+254 20 9012000',
      email: 'info@primepharmacy.co.ke',
      website: 'www.primepharmacy.co.ke',
      services: [
        'Premium Medications',
        'Imported Pharmaceuticals',
        'Specialty Drugs',
        'Compounding Pharmacy',
        'Nutritional Supplements',
        'Cosmeceuticals',
        'Medical Devices',
        'Home Healthcare Products',
        'Prescription Delivery',
        'Medication Counseling',
        'Drug Interaction Screening',
        'Therapeutic Monitoring',
        'Health Assessments',
        'Wellness Programs',
      ],
      workingHours: {
        'Monday': '8:00 AM - 9:00 PM',
        'Tuesday': '8:00 AM - 9:00 PM',
        'Wednesday': '8:00 AM - 9:00 PM',
        'Thursday': '8:00 AM - 9:00 PM',
        'Friday': '8:00 AM - 9:00 PM',
        'Saturday': '9:00 AM - 7:00 PM',
        'Sunday': '10:00 AM - 5:00 PM',
      },
      departments: [
        'Premium Pharmacy',
        'Compounding Lab',
        'Wellness Center',
        'Medical Equipment',
      ],
      specialties: [
        'Pharmaceutical Compounding',
        'Specialty Medication Management',
        'Nutritional Counseling',
        'Premium Healthcare Products',
      ],
      facilities: [
        'Compounding Laboratory',
        'Private Consultation Suites',
        'Premium Product Showcase',
        'VIP Customer Area',
        'Secure Storage Facilities',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'CIC Insurance',
        'Madison Insurance',
        'Britam',
        'APA Insurance',
        'Resolution Insurance',
      ],
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2921,
        'longitude': 36.7827,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'Pharmacy and Poisons Board Licensed',
        'ISO 9001:2015 Certified',
        'Good Pharmacy Practice Certified',
        'Compounding Pharmacy Certified',
      ],
      establishedYear: '2013',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Pharm. Robert Maina',
          'position': 'Chief Pharmacist',
          'phone': '+254 20 9012001',
          'email': 'chief.pharmacist@primepharmacy.co.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'community_pharmacy',
      name: 'Community Care Pharmacy',
      type: FacilityType.pharmacy,
      rating: 4.69,
      reviewCount: 323,
      description:
          'Affordable community pharmacy serving local neighborhoods with essential medications and basic health services.',
      address: 'Githurai 45, Kiambu Road, Nairobi',
      phone: '+254 20 1234000',
      email: 'info@communitycarepharmacy.co.ke',
      website: 'www.communitycarepharmacy.co.ke',
      services: [
        'Essential Medications',
        'Generic Drugs',
        'Basic Health Screening',
        'First Aid Supplies',
        'Baby Care Products',
        'Family Planning',
        'Malaria Treatment',
        'Deworming Services',
        'Basic Wound Care',
        'Health Education',
        'Medication Reminders',
        'Community Outreach',
        'School Health Programs',
        'Affordable Healthcare',
      ],
      workingHours: {
        'Monday': '7:00 AM - 7:00 PM',
        'Tuesday': '7:00 AM - 7:00 PM',
        'Wednesday': '7:00 AM - 7:00 PM',
        'Thursday': '7:00 AM - 7:00 PM',
        'Friday': '7:00 AM - 7:00 PM',
        'Saturday': '8:00 AM - 6:00 PM',
        'Sunday': '9:00 AM - 3:00 PM',
      },
      departments: [
        'Essential Medicines',
        'Community Health',
        'Basic Care Services',
        'Health Education',
      ],
      specialties: [
        'Affordable Healthcare',
        'Community Health Education',
        'Basic Health Screening',
        'Preventive Care Programs',
      ],
      facilities: [
        'Community Health Center',
        'Basic Screening Area',
        'Health Education Space',
        'Affordable Medicine Section',
      ],
      insuranceAccepted: ['NHIF', 'Community Health Insurance'],
      emergencyServices: false,
      parkingAvailable: false,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.1503,
        'longitude': 36.9147,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [
        'Pharmacy and Poisons Board Licensed',
        'Community Health Certified',
      ],
      establishedYear: '2016',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Pharm. Mary Njeri',
          'position': 'Community Pharmacist',
          'phone': '+254 20 1234001',
          'email': 'pharmacist@communitycarepharmacy.co.ke',
        },
      ],
    ),

    // MOMBASA COUNTY FACILITIES
    HealthcareFacility(
      id: 'coast_general_hospital',
      name: 'Coast General Teaching and Referral Hospital',
      type: FacilityType.hospital,
      rating: 4.65,
      reviewCount: 892,
      description:
          'The largest public hospital in the Coast region providing comprehensive healthcare services.',
      address: 'Hospital Road, Mombasa',
      phone: '+254 41 2314201',
      email: 'info@coastgeneral.go.ke',
      website: 'www.coastgeneral.go.ke',
      services: [
        'Emergency Services',
        'Surgery',
        'Maternity Services',
        'Pediatrics',
        'Radiology',
        'Laboratory Services',
        'Pharmacy',
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
        'Emergency Medicine',
        'Surgery',
        'Pediatrics',
        'Obstetrics & Gynecology',
        'Internal Medicine',
      ],
      specialties: [
        'Emergency Care',
        'Maternal Health',
        'Pediatric Care',
        'General Surgery',
      ],
      facilities: [
        'ICU',
        'Operating Theaters',
        'CT Scan',
        'X-Ray',
        'Laboratory',
        'Pharmacy',
      ],
      insuranceAccepted: ['NHIF', 'AAR', 'Jubilee Insurance'],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -4.0435,
        'longitude': 39.6682,
        'city': 'Mombasa',
        'county': 'Mombasa',
      },
      certifications: ['Ministry of Health Licensed'],
      establishedYear: '1952',
      bedCapacity: 650,
      contactPersons: [
        {
          'name': 'Dr. Ali Hassan',
          'position': 'Medical Superintendent',
          'phone': '+254 41 2314202',
          'email': 'superintendent@coastgeneral.go.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'pandya_memorial_hospital',
      name: 'Pandya Memorial Hospital',
      type: FacilityType.hospital,
      rating: 4.72,
      reviewCount: 567,
      description:
          'A leading private hospital in Mombasa offering quality healthcare services.',
      address: 'Dedan Kimathi Avenue, Mombasa',
      phone: '+254 41 2222191',
      email: 'info@pandyahospital.org',
      website: 'www.pandyahospital.org',
      services: [
        'Emergency Services',
        'Surgery',
        'Maternity Services',
        'Cardiology',
        'Orthopedics',
        'Radiology',
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
        'Orthopedics',
        'Surgery',
        'Pediatrics',
        'Radiology',
      ],
      specialties: [
        'Heart Care',
        'Joint Replacement',
        'Emergency Medicine',
        'Maternity Care',
      ],
      facilities: [
        'ICU',
        'Operating Theaters',
        'CT Scan',
        'Ultrasound',
        'Laboratory',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'Madison Insurance',
      ],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -4.0547,
        'longitude': 39.6636,
        'city': 'Mombasa',
        'county': 'Mombasa',
      },
      certifications: [
        'Ministry of Health Licensed',
        'ISO 9001:2015 Certified',
      ],
      establishedYear: '1958',
      bedCapacity: 150,
      contactPersons: [
        {
          'name': 'Dr. Rajesh Shah',
          'position': 'Medical Director',
          'phone': '+254 41 2222192',
          'email': 'director@pandyahospital.org',
        },
      ],
    ),

    HealthcareFacility(
      id: 'mombasa_hospital',
      name: 'Mombasa Hospital',
      type: FacilityType.hospital,
      rating: 4.68,
      reviewCount: 445,
      description:
          'A modern private hospital providing comprehensive healthcare services in Mombasa.',
      address: 'Moi Avenue, Mombasa',
      phone: '+254 41 2227710',
      email: 'info@mombasahospital.com',
      website: 'www.mombasahospital.com',
      services: [
        'Emergency Services',
        'Surgery',
        'Maternity Services',
        'Pediatrics',
        'Radiology',
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
        'General Medicine',
        'Surgery',
        'Pediatrics',
        'Obstetrics & Gynecology',
      ],
      specialties: [
        'Emergency Care',
        'Surgical Services',
        'Maternity Care',
        'Child Health',
      ],
      facilities: [
        'Operating Theaters',
        'Ultrasound',
        'X-Ray',
        'Laboratory',
        'Pharmacy',
      ],
      insuranceAccepted: ['NHIF', 'AAR', 'Jubilee Insurance'],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -4.0561,
        'longitude': 39.6631,
        'city': 'Mombasa',
        'county': 'Mombasa',
      },
      certifications: ['Ministry of Health Licensed'],
      establishedYear: '1995',
      bedCapacity: 100,
      contactPersons: [
        {
          'name': 'Dr. Fatma Mohammed',
          'position': 'Medical Director',
          'phone': '+254 41 2227711',
          'email': 'director@mombasahospital.com',
        },
      ],
    ),

    // KISUMU COUNTY FACILITIES
    HealthcareFacility(
      id: 'jaramogi_oginga_odinga_hospital',
      name: 'Jaramogi Oginga Odinga Teaching and Referral Hospital',
      type: FacilityType.hospital,
      rating: 4.58,
      reviewCount: 734,
      description:
          'The largest referral hospital in Nyanza region providing specialized healthcare services.',
      address: 'Kakamega Road, Kisumu',
      phone: '+254 57 2023471',
      email: 'info@jootrh.go.ke',
      website: 'www.jootrh.go.ke',
      services: [
        'Emergency Services',
        'Surgery',
        'Maternity Services',
        'Pediatrics',
        'Oncology',
        'Radiology',
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
        'Emergency Medicine',
        'Surgery',
        'Oncology',
        'Pediatrics',
        'Obstetrics & Gynecology',
      ],
      specialties: [
        'Cancer Treatment',
        'Emergency Care',
        'Maternal Health',
        'Pediatric Care',
      ],
      facilities: [
        'ICU',
        'Operating Theaters',
        'CT Scan',
        'X-Ray',
        'Laboratory',
        'Pharmacy',
      ],
      insuranceAccepted: ['NHIF', 'AAR', 'Jubilee Insurance'],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -0.0917,
        'longitude': 34.7680,
        'city': 'Kisumu',
        'county': 'Kisumu',
      },
      certifications: ['Ministry of Health Licensed'],
      establishedYear: '1957',
      bedCapacity: 500,
      contactPersons: [
        {
          'name': 'Dr. George Rae',
          'position': 'Medical Superintendent',
          'phone': '+254 57 2023472',
          'email': 'superintendent@jootrh.go.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'aga_khan_kisumu',
      name: 'Aga Khan Hospital Kisumu',
      type: FacilityType.hospital,
      rating: 4.75,
      reviewCount: 456,
      description:
          'A premier private hospital in Kisumu offering quality healthcare services.',
      address: 'Aga Khan Road, Kisumu',
      phone: '+254 57 2023740',
      email: 'kisumu@aku.edu',
      website: 'www.aku.edu',
      services: [
        'Emergency Services',
        'Surgery',
        'Maternity Services',
        'Pediatrics',
        'Cardiology',
        'Radiology',
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
        'Surgery',
        'Pediatrics',
        'Obstetrics & Gynecology',
      ],
      specialties: [
        'Heart Care',
        'Emergency Medicine',
        'Maternity Care',
        'Child Health',
      ],
      facilities: [
        'ICU',
        'Operating Theaters',
        'CT Scan',
        'Ultrasound',
        'Laboratory',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'Madison Insurance',
      ],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -0.0917,
        'longitude': 34.7680,
        'city': 'Kisumu',
        'county': 'Kisumu',
      },
      certifications: ['JCI Accredited', 'Ministry of Health Licensed'],
      establishedYear: '1952',
      bedCapacity: 120,
      contactPersons: [
        {
          'name': 'Dr. Amina Juma',
          'position': 'Medical Director',
          'phone': '+254 57 2023741',
          'email': 'director.kisumu@aku.edu',
        },
      ],
    ),

    HealthcareFacility(
      id: 'avenue_kisumu',
      name: 'Avenue Healthcare Kisumu',
      type: FacilityType.clinic,
      rating: 4.70,
      reviewCount: 234,
      description:
          'A modern healthcare clinic providing quality outpatient services in Kisumu.',
      address: 'Oginga Odinga Road, Kisumu',
      phone: '+254 57 2025000',
      email: 'kisumu@avenuehealthcare.co.ke',
      website: 'www.avenuehealthcare.co.ke',
      services: [
        'General Consultation',
        'Specialist Services',
        'Health Screenings',
        'Vaccinations',
        'Laboratory Services',
      ],
      workingHours: {
        'Monday': '8:00 AM - 6:00 PM',
        'Tuesday': '8:00 AM - 6:00 PM',
        'Wednesday': '8:00 AM - 6:00 PM',
        'Thursday': '8:00 AM - 6:00 PM',
        'Friday': '8:00 AM - 6:00 PM',
        'Saturday': '9:00 AM - 4:00 PM',
        'Sunday': 'Closed',
      },
      departments: ['General Medicine', 'Pediatrics', 'Laboratory'],
      specialties: ['Family Medicine', 'Preventive Care'],
      facilities: ['Consultation Rooms', 'Laboratory', 'Pharmacy'],
      insuranceAccepted: ['NHIF', 'AAR', 'Jubilee Insurance'],
      emergencyServices: false,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -0.0917,
        'longitude': 34.7680,
        'city': 'Kisumu',
        'county': 'Kisumu',
      },
      certifications: ['Ministry of Health Licensed'],
      establishedYear: '2015',
      bedCapacity: 0,
      contactPersons: [
        {
          'name': 'Dr. Peter Omondi',
          'position': 'Medical Director',
          'phone': '+254 57 2025001',
          'email': 'director.kisumu@avenuehealthcare.co.ke',
        },
      ],
    ),

    // NAKURU COUNTY FACILITIES
    HealthcareFacility(
      id: 'nakuru_level_5_hospital',
      name: 'Nakuru Level 5 Hospital',
      type: FacilityType.hospital,
      rating: 4.62,
      reviewCount: 678,
      description:
          'The main public hospital in Nakuru County providing comprehensive healthcare services.',
      address: 'Hospital Road, Nakuru',
      phone: '+254 51 2211102',
      email: 'info@nakuruhospital.go.ke',
      website: 'www.nakuruhospital.go.ke',
      services: [
        'Emergency Services',
        'Surgery',
        'Maternity Services',
        'Pediatrics',
        'Radiology',
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
        'Emergency Medicine',
        'Surgery',
        'Pediatrics',
        'Obstetrics & Gynecology',
        'Internal Medicine',
      ],
      specialties: [
        'Emergency Care',
        'Maternal Health',
        'Pediatric Care',
        'General Surgery',
      ],
      facilities: [
        'ICU',
        'Operating Theaters',
        'X-Ray',
        'Ultrasound',
        'Laboratory',
        'Pharmacy',
      ],
      insuranceAccepted: ['NHIF', 'AAR', 'Jubilee Insurance'],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -0.3031,
        'longitude': 36.0800,
        'city': 'Nakuru',
        'county': 'Nakuru',
      },
      certifications: ['Ministry of Health Licensed'],
      establishedYear: '1948',
      bedCapacity: 400,
      contactPersons: [
        {
          'name': 'Dr. James Mwangi',
          'position': 'Medical Superintendent',
          'phone': '+254 51 2211103',
          'email': 'superintendent@nakuruhospital.go.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'war_memorial_hospital',
      name: 'War Memorial Hospital',
      type: FacilityType.hospital,
      rating: 4.70,
      reviewCount: 445,
      description:
          'A well-established private hospital in Nakuru offering quality healthcare services.',
      address: 'Kenyatta Avenue, Nakuru',
      phone: '+254 51 2212718',
      email: 'info@warmemorial.co.ke',
      website: 'www.warmemorial.co.ke',
      services: [
        'Emergency Services',
        'Surgery',
        'Maternity Services',
        'Pediatrics',
        'Radiology',
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
        'Surgery',
        'Pediatrics',
        'Obstetrics & Gynecology',
        'Radiology',
      ],
      specialties: [
        'Surgical Services',
        'Maternity Care',
        'Child Health',
        'Emergency Medicine',
      ],
      facilities: [
        'Operating Theaters',
        'CT Scan',
        'Ultrasound',
        'Laboratory',
        'Pharmacy',
      ],
      insuranceAccepted: [
        'NHIF',
        'AAR',
        'Jubilee Insurance',
        'Madison Insurance',
      ],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -0.2827,
        'longitude': 36.0667,
        'city': 'Nakuru',
        'county': 'Nakuru',
      },
      certifications: [
        'Ministry of Health Licensed',
        'ISO 9001:2015 Certified',
      ],
      establishedYear: '1927',
      bedCapacity: 180,
      contactPersons: [
        {
          'name': 'Dr. Susan Kamau',
          'position': 'Medical Director',
          'phone': '+254 51 2212719',
          'email': 'director@warmemorial.co.ke',
        },
      ],
    ),

    HealthcareFacility(
      id: 'nakuru_west_hospital',
      name: 'Nakuru West Hospital',
      type: FacilityType.hospital,
      rating: 4.65,
      reviewCount: 312,
      description:
          'A modern private hospital providing comprehensive healthcare services in Nakuru.',
      address: 'Lanet Road, Nakuru',
      phone: '+254 51 2215000',
      email: 'info@nakuruwest.co.ke',
      website: 'www.nakuruwest.co.ke',
      services: [
        'Emergency Services',
        'Surgery',
        'Maternity Services',
        'Pediatrics',
        'Radiology',
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
        'General Medicine',
        'Surgery',
        'Pediatrics',
        'Obstetrics & Gynecology',
      ],
      specialties: ['Emergency Care', 'Surgical Services', 'Maternity Care'],
      facilities: [
        'Operating Theaters',
        'Ultrasound',
        'X-Ray',
        'Laboratory',
        'Pharmacy',
      ],
      insuranceAccepted: ['NHIF', 'AAR', 'Jubilee Insurance'],
      emergencyServices: true,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -0.2827,
        'longitude': 36.0667,
        'city': 'Nakuru',
        'county': 'Nakuru',
      },
      certifications: ['Ministry of Health Licensed'],
      establishedYear: '2010',
      bedCapacity: 100,
      contactPersons: [
        {
          'name': 'Dr. David Kiprop',
          'position': 'Medical Director',
          'phone': '+254 51 2215001',
          'email': 'director@nakuruwest.co.ke',
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

  /// Update existing healthcare facility
  static Future<bool> updateFacility(HealthcareFacility updatedFacility) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _facilities.indexWhere((f) => f.id == updatedFacility.id);
      if (index != -1) {
        _facilities[index] = updatedFacility;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Add new healthcare facility (for registration)
  static Future<bool> addNewFacility(HealthcareFacility newFacility) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Check if facility with same email already exists
      final existingFacility = _facilities.any(
        (f) => f.email == newFacility.email,
      );
      if (existingFacility) {
        return false; // Facility already exists
      }

      // Add the new facility
      _facilities.add(newFacility);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Create facility from registration data
  static HealthcareFacility createFacilityFromRegistration({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String specialization,
    required String bio,
    required List<String> services,
    required List<String> workingDays,
    required String facilityTypeId,
    String? profileImagePath,
  }) {
    // Generate unique ID
    final id = 'facility_${DateTime.now().millisecondsSinceEpoch}';

    // Map facility type ID to FacilityType enum
    FacilityType facilityType;
    switch (facilityTypeId) {
      case 'hospital':
        facilityType = FacilityType.hospital;
        break;
      case 'clinic':
        facilityType = FacilityType.clinic;
        break;
      case 'pharmacy':
        facilityType = FacilityType.pharmacy;
        break;
      case 'laboratory':
        facilityType = FacilityType.laboratory;
        break;
      default:
        facilityType = FacilityType.clinic;
    }

    // Create working hours map
    Map<String, String> workingHours = {};
    for (String day in workingDays) {
      workingHours[day] = '9:00 AM - 5:00 PM';
    }

    return HealthcareFacility(
      id: id,
      name: name,
      type: facilityType,
      rating: 0.0, // New facilities start with no rating
      reviewCount: 0,
      description: bio,
      address: address,
      phone: phone,
      email: email,
      website: '', // Will be updated later
      services: services,
      workingHours: workingHours,
      departments: [specialization], // Use specialization as main department
      specialties: [specialization],
      facilities: [], // Will be updated after verification
      insuranceAccepted: ['NHIF'], // Default insurance
      emergencyServices: facilityType == FacilityType.hospital,
      parkingAvailable: true,
      wheelchairAccessible: true,
      imageUrl: profileImagePath ?? 'https://via.placeholder.com/400x200',
      location: {
        'latitude': -1.2921,
        'longitude': 36.8219,
        'city': 'Nairobi',
        'county': 'Nairobi',
      },
      certifications: [], // Will be updated after document verification
      establishedYear: DateTime.now().year.toString(),
      bedCapacity: facilityType == FacilityType.hospital ? 50 : 0,
      contactPersons: [
        {
          'name': name,
          'position': 'Administrator',
          'phone': phone,
          'email': email,
        },
      ],
    );
  }

  /// Get facility by email
  static HealthcareFacility? getFacilityByEmail(String email) {
    try {
      final facility = _facilities.firstWhere(
        (facility) => facility.email.toLowerCase() == email.toLowerCase(),
      );
      return _updateFacilityRating(facility);
    } catch (e) {
      return null;
    }
  }
}
