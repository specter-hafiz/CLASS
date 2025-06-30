import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/custom_container.dart';
import 'package:flutter/material.dart';

class AssessmentScreen extends StatelessWidget {
  const AssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        centerTitle: true,
        title: Text(
          assessmentText,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 6
                    : SizeConfig.blockSizeVertical! * 7,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeVertical! * 2
                      : SizeConfig.blockSizeHorizontal! * 2,
            ),
            CustomElevatedButton(
              iconPath: newAssessmentImage,
              showIcon: true,
              buttonText: newAssessmentText,
              onPressed: () async {
                // show dialog
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    final screenHeight = MediaQuery.of(context).size.height;
                    final screenWidth = MediaQuery.of(context).size.width;

                    return CustomAlertDialog(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                    );
                  },
                );
              },
            ),
            SizedBox(
              height:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeVertical! * 2
                      : SizeConfig.blockSizeHorizontal! * 2,
            ),
            Text(
              previusAssessmentText,
              style: TextStyle(
                fontSize:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 5
                        : SizeConfig.blockSizeVertical! * 6,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height:
                  SizeConfig.orientation(context) == Orientation.portrait
                      ? SizeConfig.blockSizeVertical! * 2
                      : SizeConfig.blockSizeHorizontal! * 2,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Example item count
                itemBuilder: (context, index) {
                  return CustomContainer(
                    iconPath: quizImage,
                    titleText: "Lecture week $index",
                    subText: "89/100",
                    onTap: () {
                      Navigator.pushNamed(context, 'quizReview');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    this.leftButtonText,
    this.rightButtonText,
    this.onLeftButtonPressed,
    this.onRightButtonPressed,
    this.width,
    this.height,
    this.body,
  });

  final double screenWidth;
  final double screenHeight;
  final String? leftButtonText;
  final String? rightButtonText;
  final void Function()? onLeftButtonPressed;

  final void Function()? onRightButtonPressed;
  final double? width;
  final double? height;
  final Column? body;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(whiteColor),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width:
            width ??
            (SizeConfig.orientation(context) == Orientation.portrait
                ? screenWidth * 0.9
                : screenWidth * 0.4), // optional: control width too
        height:
            height ??
            (SizeConfig.orientation(context) == Orientation.portrait
                ? screenHeight * 0.38
                : screenHeight * 0.8), // 👈 manually control height here

        child: SingleChildScrollView(
          child: Column(
            children: [
              body ??
                  Column(
                    children: [
                      Text(
                        detailsForAssessmentText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              SizeConfig.orientation(context) ==
                                      Orientation.portrait
                                  ? SizeConfig.blockSizeHorizontal! * 6
                                  : SizeConfig.blockSizeVertical! * 6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomTextField(
                        hintText: "12342",
                        controller: TextEditingController(),
                        showTitle: true,
                        showSuffixIcon: false,
                        titleText: idText,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: accessPassTextHint,
                        controller: TextEditingController(),
                        showTitle: true,
                        showSuffixIcon: true,
                        titleText: accessPassText,
                      ),
                    ],
                  ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      buttonText: leftButtonText ?? cancelText,
                      isOutlineButton: true,
                      onPressed:
                          onLeftButtonPressed ??
                          () {
                            Navigator.pop(context);
                          },
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                  Expanded(
                    child: CustomElevatedButton(
                      buttonText: rightButtonText ?? startNowText,
                      onPressed:
                          onRightButtonPressed ??
                          () {
                            Navigator.pushNamed(context, '/answerQuiz');
                          },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
