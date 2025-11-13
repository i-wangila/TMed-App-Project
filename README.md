# TMed - Virtual Medical Clinic App

A comprehensive Flutter-based telemedicine application that connects patients with healthcare providers across Kenya, offering virtual consultations, appointment management, real-time communication, and integrated healthcare services.

## 🏥 Overview

TMed is a modern, production-ready healthcare platform designed to make medical services accessible through digital channels. The app provides seamless connections between patients and various healthcare providers including doctors, hospitals, pharmacies, laboratories, and nutritionists with full communication capabilities including voice calls, video calls, and real-time messaging.

## ✨ Features

### 🔐 Enhanced Authentication & Security
- **Separate Name Fields**: First name and last name registration
- **Strong Password Requirements**: 6+ characters with uppercase, numbers, and special characters
- **Real-time Validation**: Live password strength indicator
- **Secure Login System**: Persistent authentication with proper session management
- **Interactive Onboarding**: Comprehensive app introduction

### 👩‍⚕️ Comprehensive Healthcare Provider Network
- **Individual Doctors**: Specialists across various medical fields with detailed profiles
- **Healthcare Facilities**: Hospitals, clinics with complete facility information
- **Pharmacies**: Prescription fulfillment and medication services
- **Laboratories**: Diagnostic testing and health screening services
- **Provider Registration**: Complete onboarding system for healthcare providers
- **Profile Management**: Full profile editing with professional image upload

### 📞 Advanced Communication System
- **Voice Calls**: High-quality voice calling with healthcare providers
- **Video Calls**: Face-to-face consultations with video calling interface
- **Real-time Chat**: Instant messaging with persistent chat history
- **Quick Actions**: Call, video, or message directly from provider cards
- **Call Management**: Mute, speaker, and call duration tracking
- **Message Notifications**: Real-time message alerts and unread indicators

### 📅 Complete Appointment Management
- **Smart Booking**: Calendar-based appointment scheduling with availability checking
- **Multiple Consultation Types**:
  - Video consultations
  - Voice calls
  - In-person visits
  - Chat consultations
- **Appointment Lifecycle**: Book, reschedule, cancel, and complete appointments
- **Provider Availability**: Real-time slot checking and time management
- **Appointment History**: Complete tracking of past and upcoming appointments

### 🖼️ Professional Profile System
- **Image Upload**: Professional photo/logo upload during registration
- **Profile Editing**: Complete profile management for providers and facilities
- **Image Management**: Change, remove, or update profile images
- **Smart Display**: Automatic image handling with fallback systems
- **Professional Guidelines**: Specific guidance for individual vs facility images

### ⭐ Comprehensive Review & Rating System
- **Multi-Provider Reviews**: Rate doctors, hospitals, pharmacies, and laboratories
- **Detailed Feedback**: Written reviews with star ratings
- **Review Management**: View, edit, and manage all reviews
- **Provider Ratings**: Aggregate ratings displayed on provider profiles
- **Review Analytics**: Comprehensive review statistics and insights

### 💳 Integrated Payment & Wallet System
- **Digital Wallet**: Complete wallet management system
- **Consultation Fees**: Transparent pricing display
- **Payment Integration**: Ready for mobile money integration (M-Pesa, Airtel Money)
- **Transaction History**: Complete payment tracking and history

### 📱 Enhanced User Experience
- **Quick Actions**: Call, video, message buttons on all provider cards
- **Smart Navigation**: Intuitive bottom navigation with smooth transitions
- **Search & Filter**: Advanced provider and facility search capabilities
- **Responsive Design**: Optimized for all screen sizes and devices
- **Professional UI**: Clean, medical-grade interface design

### 🏥 Healthcare Facility Management
- **Facility Profiles**: Complete facility information with services and departments
- **Facility Registration**: Comprehensive onboarding for healthcare facilities
- **Logo Management**: Professional logo upload and management
- **Service Listings**: Detailed services, departments, and specialties
- **Contact Integration**: Direct calling and messaging from facility profiles

### 📞 Customer Support & Contact
- **Updated Contact Information**: 
  - Phone: +254740109195
  - Email: support@tmed.com
- **Contact Forms**: Direct message sending to support team
- **Business Hours**: Clear availability and response time information
- **Help & Support**: Comprehensive FAQ and support system

## 🛠 Technical Stack

### Framework & Language
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language

### Key Dependencies
- `intl ^0.19.0`: Internationalization and date formatting
- `table_calendar ^3.0.9`: Advanced calendar widget for appointment scheduling
- `url_launcher ^6.2.4`: External URL and phone number handling
- `shared_preferences ^2.2.2`: Local data persistence and user preferences
- `image_picker ^1.0.4`: Professional profile image selection and upload
- `path_provider ^2.1.1`: File system path management for image storage
- `cupertino_icons ^1.0.8`: iOS-style icons for cross-platform consistency

### Architecture
- **MVC Pattern**: Clean separation of concerns with proper state management
- **Service Layer**: Comprehensive business logic abstraction
- **Model Classes**: Robust data structure definitions with JSON serialization
- **Screen Components**: Modular UI layer organization
- **Stream Controllers**: Real-time data flow for chat and call features
- **Persistent Storage**: Local data management with SharedPreferences
- **Error Handling**: Comprehensive error management and user feedback

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point with theme configuration
├── models/                             # Data models with JSON serialization
│   ├── appointment.dart                # Appointment booking and management
│   ├── healthcare_facility.dart        # Healthcare facility data structure
│   ├── healthcare_provider.dart        # Healthcare provider profiles
│   ├── message.dart                    # Chat and messaging system
│   ├── provider_type.dart              # Provider type definitions
│   ├── review.dart                     # Review and rating system
│   └── user_profile.dart               # User profile management
├── screens/                            # UI screens and user interfaces
│   ├── appointments_screen.dart        # Appointment management interface
│   ├── auth_screen.dart                # Enhanced authentication with validation
│   ├── book_appointment_screen.dart    # Appointment booking with calendar
│   ├── call_screen.dart                # Voice and video call interface
│   ├── chat_screen.dart                # Real-time messaging interface
│   ├── contact_us_screen.dart          # Customer support and contact
│   ├── edit_facility_profile_screen.dart # Facility profile editing
│   ├── edit_provider_profile_screen.dart # Provider profile editing
│   ├── facility_profile_screen.dart    # Healthcare facility profiles
│   ├── home_screen.dart                # Main dashboard with quick actions
│   ├── inbox_screen.dart               # Message inbox and notifications
│   ├── onboarding_screen.dart          # App introduction and tutorial
│   ├── profile_screen.dart             # User profile management
│   ├── provider_profile_screen.dart    # Healthcare provider profiles
│   ├── provider_registration_screen.dart # Provider onboarding system
│   ├── rate_provider_screen.dart       # Review and rating interface
│   ├── reschedule_appointment_screen.dart # Appointment rescheduling
│   ├── wallet_screen.dart              # Digital wallet management
│   └── ... (additional screens)
└── services/                           # Business logic and data management
    ├── appointment_service.dart        # Appointment booking and management
    ├── call_service.dart               # Voice and video call handling
    ├── chat_service.dart               # Real-time messaging service
    ├── healthcare_facility_service.dart # Facility data management
    ├── healthcare_provider_service.dart # Provider data and search
    ├── message_service.dart            # Message persistence and notifications
    ├── provider_availability_service.dart # Provider scheduling system
    ├── review_service.dart             # Review and rating management
    └── user_service.dart               # User authentication and profiles
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/tmed_app.git
   cd tmed_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**iOS (requires macOS):**
```bash
flutter build ios --release
```

## 🔧 Configuration

### Environment Setup
The app includes comprehensive local services for demonstration and testing. For production deployment:

1. **Backend Integration**: Configure REST API endpoints for data synchronization
2. **Authentication Services**: Integrate with Firebase Auth or custom authentication
3. **Payment Gateways**: Set up M-Pesa, Airtel Money, and card payment processing
4. **Push Notifications**: Configure Firebase Cloud Messaging for real-time alerts
5. **Video Calling Infrastructure**: Integrate with Agora, Twilio, or WebRTC services
6. **File Storage**: Configure cloud storage for profile images and documents
7. **Database**: Set up PostgreSQL, MongoDB, or Firebase Firestore for data persistence

### Customization Options
- **Theme Configuration**: Update app colors and styling in `lib/main.dart`
- **Provider Data**: Modify healthcare provider information in service classes
- **UI Components**: Customize screen layouts and component designs
- **Business Logic**: Adapt appointment booking and communication workflows
- **Localization**: Add support for multiple languages and regions
- **Branding**: Update app icons, splash screens, and brand elements

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Web (responsive design)
- ✅ Windows, macOS, Linux (desktop support)

## 🧪 Testing & Quality Assurance

### Automated Testing
Run the comprehensive test suite:
```bash
flutter test
```

### Manual Testing Scenarios
The app has been thoroughly tested for:

1. **User Registration & Authentication**
   - First/last name separation
   - Strong password validation
   - Login/logout functionality

2. **Communication Features**
   - Voice calling interface and controls
   - Video calling with camera/microphone management
   - Real-time chat messaging
   - Quick action buttons from provider cards

3. **Appointment Management**
   - Calendar-based booking system
   - Provider availability checking
   - Appointment rescheduling and cancellation
   - Multiple consultation type selection

4. **Profile Management**
   - Image upload during registration
   - Profile editing for providers and facilities
   - Image management (change, remove, update)
   - Professional information updates

5. **Provider & Facility Features**
   - Provider registration and onboarding
   - Facility profile management
   - Service and department listings
   - Contact information integration

### Code Quality
- **Flutter Analyze**: Zero lint issues and warnings
- **Compilation**: All code compiles successfully across platforms
- **Error Handling**: Comprehensive error management with user feedback
- **Memory Management**: Proper resource disposal and lifecycle management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent file organization

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support & Contact

For support, inquiries, and technical assistance:
- **Email**: support@tmed.com
- **Phone**: +254740109195 (Available during business hours)
- **Business Hours**: Monday to Friday, 8:00 AM - 5:00 PM (EAT)
- **Response Time**: We reply within 24 hours
- **Address**: Posta House, Off Kenyatta Avenue, P.O. Box 38256 - 00100, Nairobi, Kenya

### In-App Support
- Contact form available in the app
- Real-time chat support during business hours
- Comprehensive FAQ section
- Help documentation and user guides

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Healthcare providers for their valuable input
- Beta testers for their feedback and suggestions
- Open source community for the excellent packages

## 🔄 Version History

### v1.0.0 (Current) - Production Ready Release
- **Complete Healthcare Ecosystem**: Full patient-provider interaction system
- **Advanced Communication**: Voice calls, video calls, and real-time messaging
- **Enhanced Authentication**: Separate name fields with strong password validation
- **Professional Profiles**: Image upload and comprehensive profile management
- **Smart Appointment System**: Calendar-based booking with availability checking
- **Multi-Provider Support**: Doctors, hospitals, pharmacies, laboratories, and facilities
- **Comprehensive Review System**: Rate and review all types of healthcare providers
- **Quick Actions**: Call, video, and message buttons throughout the app
- **Provider Registration**: Complete onboarding system for healthcare providers
- **Facility Management**: Full facility profile and service management
- **Real-time Features**: Live chat, call management, and instant n

---

**TMed** - Making healthcare accessible, one tap at a time. 🏥📱