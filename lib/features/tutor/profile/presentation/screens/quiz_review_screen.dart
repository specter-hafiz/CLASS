import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/answer_widget.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/question_widget.dart';
import 'package:class_app/features/tutor/quiz/data/models/question_model.dart';
import 'package:class_app/features/tutor/quiz/data/models/response_model.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class QuizReviewScreen extends StatelessWidget {
  const QuizReviewScreen({
    super.key,
    required this.questions,
    required this.response,
    required this.title,
  });
  final List<Question> questions;
  final String title;
  final ResponseModel response;

  String buildQuizSummary(List<Question> questions, ResponseModel response) {
    final buffer = StringBuffer();
    for (int i = 0; i < questions.length; i++) {
      final q = questions[i];
      buffer.writeln('Q${i + 1}: ${q.question}');
      for (int j = 0; j < q.options.length; j++) {
        final option = q.options[j];
        final isCorrect = option == q.answer;
        final isSelected =
            (response.answers.length > i &&
                response.answers[i].answer == option);
        buffer.writeln(
          '   ${String.fromCharCode(65 + j)}. $option'
          '${isCorrect ? "  (Correct)" : ""}'
          '${isSelected ? "  (Selected)" : ""}',
        );
      }
      buffer.writeln('');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        automaticallyImplyLeading: false,
        title: Text(
          title,
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
              onPressed: () async {
                final summary = buildQuizSummary(questions, response);
                SharePlus.instance.share(
                  ShareParams(text: summary, subject: title),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionWidget(
                  questionNumber: index + 1,
                  totalQuestions: questions.length,
                  questionText: questions[index].question,
                ),
                AnswersWidget(
                  correctIndex: questions[index].options.indexOf(
                    questions[index].answer,
                  ),
                  answersList: questions[index].options,
                  selectedIndex:
                      (response.answers.length > index &&
                              questions[index].options.contains(
                                response.answers[index].answer,
                              ))
                          ? questions[index].options.indexOf(
                            response.answers[index].answer,
                          )
                          : -1,

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
