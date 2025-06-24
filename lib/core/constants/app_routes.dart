import 'package:class_app/features/base/base_screen.dart';
import 'package:class_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> appRoutes = {
  '/onboarding': (context) => OnboardingScreen(),
  // '/login': LoginScreen(),
  // '/register': RegisterScreen(),
  // '/home': HomeScreen(),
  // '/profile': ProfileScreen(),
  // '/settings': SettingsScreen(),
  // '/notifications': NotificationsScreen(),
  // '/about': AboutScreen(),
  // '/terms': TermsScreen(),
  // '/privacy': PrivacyPolicyScreen(),
  // '/contact': ContactUsScreen(),
  '/base': (context) => BaseScreen(),
};
