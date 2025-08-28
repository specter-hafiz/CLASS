import 'package:class_app/core/constants/strings.dart'
    show
        accessPassText,
        deadlineText,
        easyText,
        setQuizText,
        shareQuizText,
        timeAllowedText,
        titleHintText,
        titleText;
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/assessment_screen.dart';
import 'package:class_app/features/tutor/quiz/presentation/widgets/drop_down_widget.dart';
import 'package:flutter/material.dart';

class SetQuizDialog extends StatefulWidget {
  const SetQuizDialog({super.key});

  @override
  State<SetQuizDialog> createState() => _SetQuizDialogState();
}

class _SetQuizDialogState extends State<SetQuizDialog> {
  TextEditingController timeAllowedController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();
  TextEditingController accessPasswordController = TextEditingController();
  TextEditingController numberOfQuestionsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    timeAllowedController.text = '30mins';
    titleController.text = '';
    deadlineController.text = 'Next 30min';
    accessPasswordController.text = '';
    numberOfQuestionsController.text = '10';
  }

  @override
  void dispose() {
    timeAllowedController.dispose();
    titleController.dispose();
    deadlineController.dispose();
    accessPasswordController.dispose();
    numberOfQuestionsController.dispose();
    super.dispose();
  }

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
        if (!_formKey.currentState!.validate()) {
          return;
        }

        Navigator.pop(context, {
          'title': titleController.text,
          'timeAllowed': timeAllowedController.text,
          'deadline': deadlineController.text,
          'accessPassword': accessPasswordController.text,
          'numberOfQuestions': numberOfQuestionsController.text,
        });
        // await showDialog(
        //   context: context,
        //   builder: (context) => const CopyShareQuizUrl(),
        // );
      },
      body: Form(
        key: _formKey,
        child: Column(
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
            SizedBox(height: SizeConfig.blockSizeVertical! * 2),

            CustomTextField(
              hintText: titleHintText,
              controller: titleController,
              showTitle: false,
              showSuffixIcon: false,
              titleText: titleText,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Title is required";
                }
                if (value.length < 5) {
                  return "Title must be at least 5 characters";
                }
                return null;
              },
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 1),
            CustomTextField(
              hintText: "Enter number of questions",
              controller: numberOfQuestionsController,
              showTitle: true,
              showSuffixIcon: false,
              titleText: "Number of Questions",
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a number";
                }
                final number = int.tryParse(value);
                if (number == null) {
                  return "Please enter a valid number";
                }
                if (number < 5 || number > 50) {
                  return "Number must be between 5 and 50";
                }
                return null;
              },
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 1),

            Row(
              children: [
                Expanded(
                  child: CustomDropDownTextField(
                    options: ['30mins', '45mins', '1hr', '1.5hrs', '2hrs'],
                    controller: timeAllowedController,
                    label: timeAllowedText,
                    hintText: "Time allowed for quiz",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Time allowed is required";
                      }
                      final time = convertToMinutes(value);
                      if (time <= 0) {
                        return "Please select a valid time";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeVertical! * 1),
                Expanded(
                  child: CustomDropDownTextField(
                    options: [
                      'Next 30min',
                      'Next 45min',
                      'Next 1hr',
                      'Next 1.5hrs',
                      'Next 2hrs',
                    ],
                    controller: deadlineController,
                    label: deadlineText,
                    hintText: "Deadline for assessment",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Deadline required";
                      }
                      final deadline = convertToMinutes(value);
                      final allowedTime = convertToMinutes(
                        timeAllowedController.text,
                      );
                      if (deadline < allowedTime) {
                        return "Deadline must be >= time allowed";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.blockSizeVertical! * 1),
            CustomTextField(
              hintText: easyText,
              controller: accessPasswordController,
              showTitle: true,
              showSuffixIcon: true,
              obscureText: true,
              titleText: accessPassText,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Access password is required";
                }
                if (value.length < 6) {
                  return "At least 6 characters";
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

int convertToMinutes(String input) {
  if (input.contains("30min")) return 30;
  if (input.contains("45min")) return 45;
  if (input.contains("1hr")) return 60;
  if (input.contains("1.5hr")) return 90;
  if (input.contains("2hr")) return 120;
  return 0;
}
