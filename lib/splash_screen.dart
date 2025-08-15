import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';
import 'package:class_app/core/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color(whiteColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/logo.png', // Replace with your logo
            width: SizeConfig.blockSizeHorizontal! * 30,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 2),
          Text(
            "Welcome to CLASS",
            style: TextStyle(
              fontSize: SizeConfig.blockSizeHorizontal! * 5,
              fontWeight: FontWeight.bold,
              color: Color(blackColor),
            ),
          ),
        ],
      ),
    );
  }
}
