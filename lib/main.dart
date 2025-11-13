import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'services/user_service.dart';
import 'services/message_service.dart';
import 'services/wallet_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserService.initialize();
  await MessageService.loadMessages();
  await WalletService.initialize();
  runApp(const KlinateApp());
}

class KlinateApp extends StatelessWidget {
  const KlinateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E86AB)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF2E86AB),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF2E86AB),
          selectionColor: Colors.transparent,
          selectionHandleColor: Color(0xFF2E86AB),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}
