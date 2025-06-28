import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/forgot_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(whiteColor),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            backButtonImage,
            height: SizeConfig.blockSizeHorizontal! * 2,
            width: SizeConfig.blockSizeHorizontal! * 0.2,
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                  forgotPasswordImage,
                  height: SizeConfig.screenHeight! * 0.3,
                  width: SizeConfig.screenWidth!,
                ),
              ),
              Text(
                forgotPasswordText,
                style: TextStyle(
                  fontSize:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.screenWidth! * 0.09
                          : SizeConfig.screenWidth! * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 1),
              Text(
                forgotPasswordSubText,

                style: TextStyle(
                  fontSize:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.screenWidth! * 0.05
                          : SizeConfig.screenWidth! * 0.03,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 1),
              // Add your custom text field for email input here
              ForgotPasswordForm(),

              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
            ],
          ),
        ),
      ),
    );
  }
}
