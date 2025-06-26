import 'package:class_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:class_app/features/auth/presentation/screens/login_screen.dart';
import 'package:class_app/features/auth/presentation/screens/register_screen.dart';
import 'package:class_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:class_app/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:class_app/features/base/base_screen.dart';
import 'package:class_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> appRoutes = {
  '/onboarding': (context) => OnboardingScreen(),
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),
  '/forgotPassword': (context) => ForgotPasswordScreen(),
  '/verifyOtp': (context) => VerifyOTPScreen(),
  '/resetPassword': (context) => ResetPasswordScreen(),
  // '/home': (context) => BaseScreen(), // Placeholder for home screen
  // '/profile': ProfileScreen(),
  // '/settings': SettingsScreen(),
  // '/notifications': NotificationsScreen(),
  // '/about': AboutScreen(),
  // '/terms': TermsScreen(),
  // '/privacy': PrivacyPolicyScreen(),
  // '/contact': ContactUsScreen(),
  '/base': (context) => BaseScreen(),
};
