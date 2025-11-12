# TMed - Virtual Medical Clinic App

A comprehensive Flutter-based telemedicine application that connects patients with healthcare providers across Kenya, offering virtual consultations, appointment management, and integrated healthcare services.

## 🏥 Overview

TMed is a modern healthcare platform designed to make medical services accessible through digital channels. The app provides seamless connections between patients and various healthcare providers including doctors, hospitals, pharmacies, laboratories, and nutritionists.

## ✨ Features

### 🔐 Authentication & Onboarding
- User registration and secure login
- Interactive onboarding experience
- Profile management with medical history

### 👩‍⚕️ Healthcare Provider Network
- **Doctors**: Specialists across various medical fields
- **Hospitals**: Major healthcare facilities
- **Pharmacies**: Prescription fulfillment and medication delivery
- **Laboratories**: Diagnostic testing services
- **Nutritionists**: Dietary consultation and planning

### 📅 Appointment Management
- Book appointments with preferred providers
- Multiple consultation types:
  - Video calls
  - Voice calls
  - Text chat
  - In-person visits
- Reschedule and manage existing appointments
- Appointment history and status tracking

### 💬 Communication Features
- Real-time chat with healthcare providers
- Video and voice calling capabilities
- Secure messaging system
- Notification management

### ⭐ Review & Rating System
- Rate and review healthcare providers
- View provider ratings and patient feedback
- Comprehensive review management for all provider types

### 💳 Payment & Wallet
- Integrated wallet system
- Support for Kenyan mobile money (M-Pesa, Airtel Money)
- Transparent pricing and payment tracking

### 📱 Additional Features
- Medical records management
- Prescription tracking and reports
- Settings and preferences
- Terms & conditions, privacy policy
- Customer support and FAQs

## 🛠 Technical Stack

### Framework & Language
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language

### Key Dependencies
- `intl`: Internationalization and date formatting
- `table_calendar`: Calendar widget for appointment scheduling
- `url_launcher`: External URL and phone number handling
- `shared_preferences`: Local data persistence
- `image_picker`: Profile image selection
- `path_provider`: File system path management

### Architecture
- **MVC Pattern**: Clean separation of concerns
- **Service Layer**: Business logic abstraction
- **Model Classes**: Data structure definitions
- **Screen Components**: UI layer organization

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── appointment.dart
│   ├── healthcare_facility.dart
│   ├── healthcare_provider.dart
│   ├── message.dart
│   ├── provider_type.dart
│   ├── review.dart
│   └── user_profile.dart
├── screens/                  # UI screens
│   ├── appointments_screen.dart
│   ├── auth_screen.dart
│   ├── book_appointment_screen.dart
│   ├── call_screen.dart
│   ├── chat_screen.dart
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   └── ... (other screens)
└── services/                 # Business logic
    ├── appointment_service.dart
    ├── call_service.dart
    ├── chat_service.dart
    ├── healthcare_provider_service.dart
    ├── message_service.dart
    ├── review_service.dart
    └── user_service.dart
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
The app uses local services for demonstration. For production deployment:

1. Configure backend API endpoints
2. Set up authentication services
3. Integrate payment gateways
4. Configure push notifications
5. Set up video calling infrastructure

### Customization
- Update app colors in `lib/main.dart` theme configuration
- Modify provider data in service classes
- Customize UI components in screen files

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Web (responsive design)
- ✅ Windows, macOS, Linux (desktop support)

## 🧪 Testing

Run the test suite:
```bash
flutter test
```

The app includes widget tests for core functionality verification.

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

## 📞 Support

For support and inquiries:
- Email: support@tmed.com
- Phone: +254 700 123 456
- Website: [www.tmed.com](https://www.tmed.com)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Healthcare providers for their valuable input
- Beta testers for their feedback and suggestions
- Open source community for the excellent packages

## 🔄 Version History

### v1.0.0 (Current)
- Initial release
- Core appointment booking functionality
- Multi-provider support
- Review and rating system
- Integrated communication features
- Wallet and payment system

---

**TMed** - Making healthcare accessible, one tap at a time. 🏥📱