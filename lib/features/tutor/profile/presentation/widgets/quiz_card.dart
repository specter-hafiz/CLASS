import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/answer_widget.dart'
    show AnswersWidget;
import 'package:class_app/features/tutor/profile/presentation/widgets/question_widget.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/stack_container.dart';
import 'package:class_app/features/tutor/quiz/data/models/question_model.dart';
import 'package:flutter/material.dart';

class QuizCard extends StatelessWidget {
  const QuizCard({
    super.key,
    required this.questionIndex,
    required this.onOptionSelected,
    required this.selectedIndex,
    required this.questionText,
    required this.options,
    required this.quizQuestions,
  });

  final int questionIndex;
  final ValueChanged<int> onOptionSelected;
  final int? selectedIndex;
  final String questionText;
  final List<Question> quizQuestions;
  final List<String> options;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // background containers...
        StackContainer(
          bottomDisplacement:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? (-SizeConfig.blockSizeHorizontal! * 6)
                  : (-SizeConfig.blockSizeHorizontal! * 3),
          color: hospitalBlue,
        ),
        StackContainer(
          bottomDisplacement:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? (-SizeConfig.blockSizeHorizontal! * 3)
                  : (-SizeConfig.blockSizeHorizontal! * 1.5),
          color: blueColor,
        ),
        Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal! * 3),
          decoration: BoxDecoration(
            color: Color(whiteColor),
            borderRadius: BorderRadius.circular(
              SizeConfig.blockSizeHorizontal! * 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuestionWidget(
                        questionNumber: questionIndex + 1,
                        totalQuestions: quizQuestions.length,
                        questionText: questionText,
                      ),
                      AnswersWidget(
                        answersList: options,
                        selectedIndex: selectedIndex,
                        onChanged: onOptionSelected,
                      ),
                    ],
                  )
                  : Row(
                    children: [
                      Expanded(
                        child: QuestionWidget(
                          questionNumber: questionIndex + 1,
                          totalQuestions: quizQuestions.length,
                          questionText: questionText,
                        ),
                      ),
                      Expanded(
                        child: AnswersWidget(
                          answersList: options,
                          selectedIndex: selectedIndex,
                          onChanged: onOptionSelected,
                        ),
                      ),
                    ],
                  ),
        ),
      ],
    );
  }
}
