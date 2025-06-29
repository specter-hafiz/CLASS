import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/profile_button.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/profile_picture.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding(context),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 2
                          : SizeConfig.blockSizeVertical! * 0.3,
                ),
                Text(
                  profileText,
                  style: TextStyle(
                    fontSize:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.screenWidth! * 0.09
                            : SizeConfig.screenWidth! * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                SizedBox(
                  height:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 5
                          : SizeConfig.blockSizeHorizontal! * 0.1,
                ),
                ProfilePicture(),
                SizedBox(
                  height:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 1
                          : SizeConfig.blockSizeHorizontal! * 0.5,
                ),
                Center(
                  child: Text(
                    "Frimpong",
                    style: TextStyle(
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.screenWidth! * 0.07
                              : SizeConfig.screenWidth! * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 1
                          : SizeConfig.blockSizeHorizontal! * 0.5,
                ),

                ProfileButton(
                  text: assessmentText,
                  iconPath: "assets/svgs/assessment.svg",
                  onTap: () {
                    Navigator.pushNamed(context, '/assessment');
                  },
                ),
                ProfileButton(
                  text: editProfileText,
                  iconPath: editProfileImage,
                  onTap: () {
                    Navigator.pushNamed(context, '/editProfile');
                  },
                ),
                ProfileButton(
                  text: changePasswordText,
                  iconPath: changePasswordImage,
                  onTap: () {
                    Navigator.pushNamed(context, '/changePassword');
                  },
                  isLast: true,
                ),
                SizedBox(
                  height:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 1
                          : SizeConfig.blockSizeHorizontal! * 0.5,
                ),
                CustomElevatedButton(
                  buttonText: logoutText,
                  onPressed: () {},
                  iconPath: logoutImage,
                  showIcon: true,
                ),
                SizedBox(
                  height:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 0
                          : SizeConfig.blockSizeHorizontal! * 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
