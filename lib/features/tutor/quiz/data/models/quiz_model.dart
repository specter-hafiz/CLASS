import 'package:class_app/features/tutor/quiz/data/models/question_model.dart';

class Quiz {
  final String id;
  final String title;
  final String createdBy;
  final String expiresAt;
  final String duration;
  final String accessPassword;
  final String sharedLinkId;
  final List<Question> questions;

  Quiz({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.expiresAt,
    required this.duration,
    required this.accessPassword,
    required this.sharedLinkId,
    required this.questions,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
      expiresAt: json['expiresAt']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      accessPassword: json['accessPassword']?.toString() ?? '',
      sharedLinkId: json['sharedLinkId']?.toString() ?? '',
      questions:
          (json['questions'] as List?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'createdBy': createdBy,
      'expiresAt': expiresAt,
      'duration': duration,
      'accessPassword': accessPassword,
      'sharedLinkId': sharedLinkId,
      'questions': questions,
    };
  }

  Quiz copyWith({
    String? id,
    String? title,
    String? createdBy,
    String? expiresAt,
    String? duration,
    String? accessPassword,
    String? sharedLinkId,
    List<Map<String, dynamic>>? questions,
  }) {
    return Quiz(
      id: id ?? this.id,
      title: title ?? this.title,
      createdBy: createdBy ?? this.createdBy,
      expiresAt: expiresAt ?? this.expiresAt,
      duration: duration ?? this.duration,
      accessPassword: accessPassword ?? this.accessPassword,
      sharedLinkId: sharedLinkId ?? this.sharedLinkId,
      questions:
          questions != null
              ? questions.map((q) => Question.fromJson(q)).toList()
              : this.questions,
    );
  }
}
