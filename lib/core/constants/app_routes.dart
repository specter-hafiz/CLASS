import 'package:class_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:class_app/features/auth/presentation/screens/login_screen.dart';
import 'package:class_app/features/auth/presentation/screens/register_screen.dart';
import 'package:class_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:class_app/features/auth/presentation/screens/verify_otp_screen.dart';
import 'package:class_app/features/base/base_screen.dart';
import 'package:class_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/answer_quiz_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/assessment_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/change_password_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> appRoutes = {
  '/onboarding': (context) => OnboardingScreen(),
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),
  '/forgotPassword': (context) => ForgotPasswordScreen(),
  '/verifyOtp': (context) => VerifyOTPScreen(),
  '/resetPassword': (context) => ResetPasswordScreen(),
  '/changePassword': (context) => ChangePasswordScreen(),
  '/assessment':
      (context) => AssessmentScreen(), // Placeholder for assessment screen
  '/answerQuiz':
      (context) => AnswerQuizScreen(), // Placeholder for answer quiz screen
  // Add other routes here
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
