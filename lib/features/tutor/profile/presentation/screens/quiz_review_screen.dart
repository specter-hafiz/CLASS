import 'dart:math';

import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/tutor/profile/data/question.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/answer_widget.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/question_widget.dart';
import 'package:flutter/material.dart';

class QuizReviewScreen extends StatelessWidget {
  const QuizReviewScreen({super.key});

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
            child: IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {},
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
                  correctIndex: question['correctIndex'] as int?,
                  answersList: question['options'] as List<String>,
                  selectedIndex: Random().nextInt(question['options'].length),
                  onChanged: null,
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
