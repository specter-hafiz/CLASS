class AnswerModel {
  final String questionId;
  final String answer;

  AnswerModel({required this.questionId, required this.answer});

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(questionId: json['questionId'], answer: json['answer']);
  }

  Map<String, dynamic> toJson() => {'questionId': questionId, 'answer': answer};
}
