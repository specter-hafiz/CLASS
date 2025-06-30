import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/assessment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CopyShareQuizUrl extends StatelessWidget {
  const CopyShareQuizUrl({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      screenWidth: SizeConfig.screenWidth!,
      screenHeight: SizeConfig.screenHeight!,
      height:
          SizeConfig.orientation(context) == Orientation.portrait
              ? SizeConfig.blockSizeVertical! * 43
              : SizeConfig.blockSizeHorizontal! * 60,
      onLeftButtonPressed: () {},
      leftButtonText: copyText,
      rightButtonText: shareText,
      onRightButtonPressed: () {},
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            successImage,
            width: SizeConfig.blockSizeHorizontal! * 10,
            height: SizeConfig.blockSizeVertical! * 10,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 1),
          Text(
            successText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal! * 6
                      : SizeConfig.blockSizeVertical! * 6,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 1),
          Text(
            successSubText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeHorizontal! * 5
                      : SizeConfig.blockSizeVertical! * 5,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 1),
          CustomTextField(
            hintText: "https://quixapp.io/quiz/abc12389.",
            controller: TextEditingController(),
            readOnly: true,
            showTitle: false,
            showSuffixIcon: false,
            underlineInputBorder: true,
          ),
        ],
      ),
    );
  }
}
