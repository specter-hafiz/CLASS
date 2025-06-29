import 'package:class_app/core/utilities/size_config.dart';
import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
    super.key,
    required this.questionNumber,
    required this.totalQuestions,
    required this.questionText,
  });
  final int questionNumber;
  final int totalQuestions;
  final String questionText;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "Question $questionNumber/$totalQuestions",
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 5
                    : SizeConfig.blockSizeVertical! * 5,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 2),
        Text(
          questionText,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeHorizontal! * 5
                    : SizeConfig.blockSizeVertical! * 5,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical! * 3),
      ],
    );
  }
}
