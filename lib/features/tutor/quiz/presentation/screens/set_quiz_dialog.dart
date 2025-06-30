import 'package:class_app/core/constants/strings.dart'
    show
        easyText,
        accessPassText,
        deadlineText,
        setQuizText,
        shareQuizText,
        timeAllowedText;
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/assessment_screen.dart';
import 'package:class_app/features/tutor/quiz/presentation/widgets/copy_share_quiz_url.dart';
import 'package:class_app/features/tutor/quiz/presentation/widgets/drop_down_widget.dart';
import 'package:flutter/material.dart';

class SetQuizDialog extends StatelessWidget {
  const SetQuizDialog({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return CustomAlertDialog(
      screenWidth: SizeConfig.screenWidth!,
      screenHeight: SizeConfig.screenHeight!,
      height:
          SizeConfig.orientation(context) == Orientation.portrait
              ? SizeConfig.blockSizeVertical! * 45
              : SizeConfig.blockSizeHorizontal! * 60,
      onLeftButtonPressed: () {
        Navigator.pop(context);
      },
      rightButtonText: setQuizText,
      onRightButtonPressed: () async {
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder: (context) => const CopyShareQuizUrl(),
        );
      },
      body: Column(
        children: [
          Text(
            shareQuizText,
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
          CustomDropDownTextField(
            options: ['30mins', '45mins', '1hr', '1.5hrs', '2hrs'],
            controller: TextEditingController(),
            label: timeAllowedText,
            hintText: "Time allowed for quiz",
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 1),
          CustomDropDownTextField(
            options: [
              'Next 30min',
              'Next 45min',
              'Next 1hr',
              'Next 1.5hrs',
              'Next 2hrs',
            ],
            controller: TextEditingController(),
            label: deadlineText,
            hintText: "Deadline for assessment",
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 1),
          CustomTextField(
            hintText: easyText,
            controller: TextEditingController(),
            showTitle: true,
            showSuffixIcon: true,
            titleText: accessPassText,
          ),
        ],
      ),
    );
  }
}
