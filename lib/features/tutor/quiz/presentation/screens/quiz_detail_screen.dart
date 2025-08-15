import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/quiz_export_service.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/answer_widget.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/question_widget.dart';
import 'package:class_app/features/tutor/quiz/data/models/quiz_model.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class QuizDetailScreen extends StatelessWidget {
  const QuizDetailScreen({super.key, required this.quiz});
  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
        automaticallyImplyLeading: false,
        title: Text(
          quiz.title,
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
                  icon: const Icon(Icons.download_outlined),
                  onPressed:
                      quiz.questions.isEmpty
                          ? null
                          : () async {
                            final path = await QuizExportService.exportToPdf(
                              quiz,
                              fileName: quiz.title,
                            );
                            if (path != null) {
                              final messenger = ScaffoldMessenger.of(context);

                              messenger.showSnackBar(
                                SnackBar(
                                  duration: const Duration(
                                    seconds: 3,
                                  ), // basically won't auto-dismiss
                                  content: Text(
                                    'File downloaded successfully.',
                                  ),
                                  action: SnackBarAction(
                                    textColor: Color(whiteColor),
                                    label: 'Open',
                                    onPressed: () {
                                      OpenFile.open(path);
                                    },
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Permission denied or failed.'),
                                ),
                              );
                            }
                          },
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
        child:
            quiz.questions.isEmpty
                ? Center(
                  child: Text(
                    noQuestionsText,
                    style: TextStyle(
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal! * 5
                              : SizeConfig.blockSizeVertical! * 3,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
                : ListView.builder(
                  itemCount: quiz.questions.length,
                  itemBuilder: (context, index) {
                    final question = quiz.questions[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuestionWidget(
                          questionNumber: index + 1,
                          totalQuestions: quiz.questions.length,
                          questionText: question.question,
                        ),
                        AnswersWidget(
                          answersList: question.options,
                          selectedIndex: question.options.indexOf(
                            question.answer,
                          ),
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
