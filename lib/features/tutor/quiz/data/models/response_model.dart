import 'package:class_app/features/tutor/quiz/data/models/answer_model.dart';

class ResponseModel {
  final String id;
  final String userId;
  final List<AnswerModel> answers;
  final DateTime submittedAt;
  final int score;

  ResponseModel({
    required this.id,
    required this.userId,
    required this.answers,
    required this.submittedAt,
    required this.score,
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
      score: json['score'] ?? 0, // Default to 0 if score is not provided
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'submittedAt': submittedAt.toIso8601String(),
    'answers': answers.map((a) => a.toJson()).toList(),
    'score': score,
  };
}
