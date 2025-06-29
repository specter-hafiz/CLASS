import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/tutor/profile/data/question.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/assessment_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/answer_widget.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/question_widget.dart';
import 'package:class_app/features/tutor/quiz/presentation/widgets/drop_down_widget.dart';
import 'package:flutter/material.dart';

class QuizDetailScreen extends StatelessWidget {
  const QuizDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          lectureWeekText,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 6
                    : SizeConfig.blockSizeVertical! * 7,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: SizeConfig.horizontalPadding(context),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) {
                        return CustomAlertDialog(
                          screenWidth: SizeConfig.screenWidth!,
                          screenHeight: SizeConfig.screenHeight!,
                          height:
                              SizeConfig.orientation(context) ==
                                      Orientation.portrait
                                  ? SizeConfig.blockSizeVertical! * 50
                                  : SizeConfig.blockSizeHorizontal! * 60,
                          onLeftButtonPressed: () {
                            Navigator.pop(context);
                          },
                          rightButtonText: setQuizText,
                          onRightButtonPressed: () {},
                          body: Column(
                            children: [
                              Text(
                                shareQuizText,
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
                              SizedBox(
                                height: SizeConfig.blockSizeVertical! * 1,
                              ),
                              CustomDropDownTextField(
                                options: [
                                  '30mins',
                                  '45mins',
                                  '1hr',
                                  '1.5hrs',
                                  '2hrs',
                                ],
                                controller: TextEditingController(),
                                label: timeAllowedText,
                                hintText: "Time allowed for quiz",
                              ),
                              SizedBox(
                                height: SizeConfig.blockSizeVertical! * 1,
                              ),
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
                              SizedBox(
                                height: SizeConfig.blockSizeVertical! * 1,
                              ),
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
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: ListView.builder(
          itemCount: quizQuestions.length,
          itemBuilder: (context, index) {
            final question = quizQuestions[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionWidget(
                  questionNumber: index + 1,
                  totalQuestions: quizQuestions.length,
                  questionText: question['question'] as String,
                ),
                AnswersWidget(
                  answersList: question['options'] as List<String>,
                  selectedIndex: question['correctIndex'] as int? ?? -1,
                  onChanged: (_) {},
                ),
                SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              ],
            );
          },
        ),
      ),
    );
  }
}
