import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/auth/presentation/widgets/register_form.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/assessment_screen.dart';
import 'package:class_app/features/tutor/quiz/presentation/widgets/drop_down_widget.dart';
import 'package:flutter/material.dart';

class ExportQuizDialog extends StatelessWidget {
  const ExportQuizDialog({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return CustomAlertDialog(
      screenWidth: SizeConfig.screenWidth!,
      screenHeight: SizeConfig.screenHeight!,
      height:
          SizeConfig.orientation(context) == Orientation.portrait
              ? SizeConfig.blockSizeVertical! * 38
              : SizeConfig.blockSizeHorizontal! * 60,
      onLeftButtonPressed: () {
        Navigator.pop(context);
      },
      rightButtonText: exportText,

      onRightButtonPressed: () async {},
      body: Column(
        children: [
          Text(
            exportQuestionText,
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
          CustomTextField(
            controller: TextEditingController(),
            titleText: fileNameText,
            hintText: midsemesterText,
            showTitle: true,
            showSuffixIcon: false,
            underlineInputBorder: true,
          ),
          SizedBox(height: SizeConfig.blockSizeVertical! * 1),
          CustomDropDownTextField(
            options: [wordText, pdfText],
            controller: TextEditingController(),
            label: fileFormatText,
            hintText: chooseFileFormatText,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  includeAnswersText,
                  style: TextStyle(
                    fontSize:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeHorizontal! * 4
                            : SizeConfig.blockSizeVertical! * 4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
              CustomCheckBox(
                onChanged: (value) {
                  // Handle checkbox change
                  // You can implement the logic to include answers here
                  print("Include answers: $value");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
