import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/app_routes.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLASS',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(whiteColor),
        appBarTheme: AppBarTheme(
          surfaceTintColor: Colors.transparent,

          backgroundColor: Color(whiteColor),
          elevation: 0,
          iconTheme: IconThemeData(color: Color(blackColor)),
        ),
        popupMenuTheme: PopupMenuThemeData(color: Color(whiteColor)),
        fontFamily: "Poppins",
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w400),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Builder(
        builder: (context) {
          SizeConfig().init(context);
          return OnboardingScreen();
        },
      ),
      routes: appRoutes,
    );
  }
}
