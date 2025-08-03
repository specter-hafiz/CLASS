import 'package:class_app/features/tutor/quiz/data/models/answer_model.dart';

class ResponseModel {
  final String id;
  final String userId;
  final List<AnswerModel> answers;
  final DateTime submittedAt;

  ResponseModel({
    required this.id,
    required this.userId,
    required this.answers,
    required this.submittedAt,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      id: json['id'],
      userId: json['userId'],
      submittedAt: DateTime.parse(json['submittedAt']),
      answers:
          (json['answers'] as List)
              .map((a) => AnswerModel.fromJson(a))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'submittedAt': submittedAt.toIso8601String(),
    'answers': answers.map((a) => a.toJson()).toList(),
  };
}
