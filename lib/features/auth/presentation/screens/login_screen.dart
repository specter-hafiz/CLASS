import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/continue_with_widget.dart';
import 'package:class_app/features/auth/presentation/widgets/login_form.dart';
import 'package:class_app/features/auth/presentation/widgets/rich_text_widget.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.horizontalPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.screenHeight! * 0.05),
                Center(
                  child: Image.asset(
                    logoImage,
                    height:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.screenHeight! * 0.15
                            : SizeConfig.screenHeight! * 0.2,
                    width: SizeConfig.screenWidth! * 0.2,
                  ),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 1),

                Text(
                  loginText,
                  style: TextStyle(
                    fontSize:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.screenWidth! * 0.09
                            : SizeConfig.screenWidth! * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                Text(
                  loginToContinueText,
                  style: TextStyle(
                    fontSize:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.screenWidth! * 0.05
                            : SizeConfig.screenWidth! * 0.03,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),

                LoginForm(),

                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                ContinueWithWidget(),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                CustomElevatedButton(
                  buttonText: "Google",
                  showIcon: true,
                  onPressed: () {},
                  height:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 6
                          : SizeConfig.blockSizeHorizontal! * 5,
                  borderRadius:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeHorizontal! * 3
                          : SizeConfig.blockSizeHorizontal! * 1,
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                RichTextWidget(
                  text: "Don't have an account? ",
                  actionText: registerText,
                  onTap: () {
                    FocusScope.of(context).unfocus();

                    Navigator.pushNamed(context, '/register');
                  },
                ),
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizedBox.shrink()
                    : SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
