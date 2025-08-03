import 'package:class_app/features/tutor/quiz/data/models/question_model.dart';
import 'package:class_app/features/tutor/quiz/data/models/response_model.dart';

class SubmittedResponseModel {
  final String title;
  final ResponseModel response;
  final List<Question> questions;

  SubmittedResponseModel({
    required this.title,
    required this.response,
    required this.questions,
  });

  factory SubmittedResponseModel.fromJson(Map<String, dynamic> json) {
    return SubmittedResponseModel(
      title: json['title'],
      response: ResponseModel.fromJson(json['response']),
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'response': response.toJson(),
    'questions': questions.map((q) => q.toJson()).toList(),
  };
}
