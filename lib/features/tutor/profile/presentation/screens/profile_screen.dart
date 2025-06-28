import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeVertical! * 0.8
                              : SizeConfig.blockSizeVertical! * 0.8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(whiteColor),
                          border: Border.all(
                            color: Color(blueColor),
                            width: SizeConfig.blockSizeVertical! * 0.5,
                          ),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeVertical! * 50,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            SizeConfig.blockSizeVertical! * 50,
                          ),
                          child: Image.asset(
                            'assets/images/image.png',
                            width:
                                SizeConfig.orientation(context) ==
                                        Orientation.portrait
                                    ? SizeConfig.screenWidth! * 0.5
                                    : SizeConfig.screenWidth! * 0.15,
                            height:
                                SizeConfig.orientation(context) ==
                                        Orientation.portrait
                                    ? SizeConfig.screenWidth! * 0.5
                                    : SizeConfig.screenWidth! * 0.15,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.blockSizeVertical! * 0.5
                                : SizeConfig.blockSizeHorizontal! * 0.2,
                        right:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.blockSizeVertical! * 0.5
                                : SizeConfig.blockSizeHorizontal! * 0.2,
                        child: IconButton.filled(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Color(blueColor),
                            ),
                          ),
                          color: Color(whiteColor),
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
                ),
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
                  iconPath: "assets/svgs/edit_profile.svg",
                  onTap: () {},
                ),
                ProfileButton(
                  text: changePasswordText,
                  iconPath: "assets/svgs/change_password.svg",
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

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.onTap,
    this.isLast,
  });

  final String text;
  final String iconPath;
  final void Function()? onTap;
  final bool? isLast;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: Color(greyColor)),
        SizedBox(
          height:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeVertical! * 0.2
                  : SizeConfig.blockSizeHorizontal! * 0.1,
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            SizeConfig.blockSizeVertical! * 1.2,
          ),
          splashColor: Color(lightBlue),
          child: Row(
            children: [
              Container(
                width:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.13
                        : SizeConfig.screenWidth! * 0.065,
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.13
                        : SizeConfig.screenWidth! * 0.065,
                decoration: BoxDecoration(
                  color: Color(blueColor),
                  borderRadius: BorderRadius.circular(
                    SizeConfig.blockSizeVertical! * 1.2,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    width:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.screenWidth! * 0.08
                            : SizeConfig.screenWidth! * 0.04,
                    height:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.screenWidth! * 0.08
                            : SizeConfig.screenWidth! * 0.04,
                  ),
                ),
              ),
              SizedBox(
                width:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 3
                        : SizeConfig.blockSizeHorizontal! * 1,
              ),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.screenWidth! * 0.05
                            : SizeConfig.screenWidth! * 0.025,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),

              SvgPicture.asset(
                "assets/svgs/forward.svg",
                width:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.1
                        : SizeConfig.screenWidth! * 0.03,
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.screenWidth! * 0.1
                        : SizeConfig.screenWidth! * 0.03,
              ),
            ],
          ),
        ),
        SizedBox(
          height:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeVertical! * 0.2
                  : SizeConfig.blockSizeHorizontal! * 0.1,
        ),
        isLast != null
            ? Divider(color: Color(greyColor))
            : const SizedBox.shrink(),
      ],
    );
  }
}
