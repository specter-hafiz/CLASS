import 'package:class_app/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:class_app/features/auth/presentation/screens/login_screen.dart';
import 'package:class_app/features/auth/presentation/screens/register_screen.dart';
import 'package:class_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:class_app/features/base/base_screen.dart';
import 'package:class_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/assessment_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/change_password_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext context)> appRoutes = {
  '/onboarding': (context) => OnboardingScreen(),
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),
  '/forgotPassword': (context) => ForgotPasswordScreen(),
  '/resetPassword': (context) => ResetPasswordScreen(),
  '/changePassword': (context) => ChangePasswordScreen(),
  '/assessment':
      (context) => AssessmentScreen(), // Placeholder for assessment screen
  // '/remarks': (context) => RemarksScreen(), // Placeholder for remarks screen
  '/editProfile': (context) => EditProfileScreen(),

  '/base': (context) => BaseScreen(),
  // Placeholder for transcript audio screen
  // Placeholder for audio recorder
};
