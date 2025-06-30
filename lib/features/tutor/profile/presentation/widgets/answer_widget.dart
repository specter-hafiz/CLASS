import 'package:class_app/features/tutor/profile/presentation/widgets/answer_container.dart';
import 'package:flutter/material.dart';

class AnswersWidget extends StatefulWidget {
  const AnswersWidget({
    super.key,
    required this.answersList,
    required this.selectedIndex,
    required this.onChanged,
    this.correctIndex,
  });

  final List<String> answersList;
  final int? selectedIndex;
  final ValueChanged<int>? onChanged;
  final int? correctIndex;
  @override
  State<AnswersWidget> createState() => _AnswersWidgetState();
}

class _AnswersWidgetState extends State<AnswersWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.answersList.length,
      itemBuilder: (context, index) {
        return AnswerContainer(
          correctIndex: widget.correctIndex,
          index: index,
          selectedIndex: widget.selectedIndex ?? -1,
          answerText: widget.answersList[index],
          onChanged: widget.onChanged,
        );
      },
    );
  }
}
