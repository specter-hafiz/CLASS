import 'package:auto_size_text/auto_size_text.dart';
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
        title: AutoSizeText(
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
                    return AlertDialog(
                      backgroundColor: Color(whiteColor),
                      content: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 500,
                          ), // Prevent overflow in wide screens
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
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
                              const SizedBox(height: 12),
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
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomElevatedButton(
                                      buttonText: cancelText,
                                      isOutlineButton: true,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        SizeConfig.orientation(context) ==
                                                Orientation.portrait
                                            ? SizeConfig.blockSizeHorizontal! *
                                                2
                                            : SizeConfig.blockSizeVertical! * 2,
                                  ),
                                  Expanded(
                                    child: CustomElevatedButton(
                                      buttonText: startNowText,
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
            AutoSizeText(
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
                    onTap: () {},
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
