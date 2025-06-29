import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RemarksScreen extends StatelessWidget {
  const RemarksScreen({super.key, required this.score});
  final String score;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(blueColor),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              congratulationsImage,
              height:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeVertical! * 20
                      : SizeConfig.blockSizeHorizontal! * 20,
              width:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeVertical! * 20
                      : SizeConfig.blockSizeHorizontal! * 20,
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 2),
            Text(
              "Congratulations!",
              style: TextStyle(
                fontSize:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 8
                        : SizeConfig.blockSizeVertical! * 7,
                fontWeight: FontWeight.w600,
                color: Color(whiteColor), // hintColor
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 2),
            Text(
              "$score% Score",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 10
                        : SizeConfig.blockSizeVertical! * 5,
                fontWeight: FontWeight.w500,
                color: Color(yellowColor), // hintColor
              ),
            ),
            Text(
              "You have successfully completed the quiz.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 6
                        : SizeConfig.blockSizeVertical! * 4,
                fontWeight: FontWeight.w500,
                color: Color(whiteColor), // hintColor
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 4),
            CustomElevatedButton(
              backgroundColor: whiteColor,
              textColor: blueColor,
              buttonText: reviewText,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
