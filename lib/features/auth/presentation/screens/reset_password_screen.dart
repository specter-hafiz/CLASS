import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/auth/presentation/widgets/reset_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CustomBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                  resetPasswordImage,
                  height: SizeConfig.screenHeight! * 0.3,
                  width: SizeConfig.screenWidth!,
                ),
              ),
              Text(
                setNewPasswordText,
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
                setNewPasswordSubText,

                style: TextStyle(
                  fontSize:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.screenWidth! * 0.05
                          : SizeConfig.screenWidth! * 0.03,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              ResetPasswordForm(),

              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
            ],
          ),
        ),
      ),
    );
  }
}
