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
  runApp(const TMedApp());
}

class TMedApp extends StatelessWidget {
  const TMedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E86AB)),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF2E86AB),
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
