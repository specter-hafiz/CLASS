import 'package:equatable/equatable.dart';

class QuestionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchQuestionsEvent extends QuestionEvent {}

class GenerateQuestionsEventRequest extends QuestionEvent {
  final String transcript;
  final int numberOfQuestions;
  final String title;
  final DateTime expiresAt;
  final String duration;
  final String accessPassword;

  GenerateQuestionsEventRequest({
    required this.expiresAt,
    required this.duration,
    required this.accessPassword,
    required this.transcript,
    this.numberOfQuestions = 5,
    required this.title,
  });

  @override
  List<Object?> get props => [transcript, numberOfQuestions, title];
}

class GetSharedQuestionsEvent extends QuestionEvent {
  final String id;
  final String sharedId;
  final String accessPassword;

  GetSharedQuestionsEvent(this.id, this.sharedId, this.accessPassword);

  @override
  List<Object?> get props => [id, sharedId, accessPassword];
}

class SubmitAssessmentEvent extends QuestionEvent {
  final String id;
  final String sharedId;
  final List<Map<String, dynamic>> response;

  SubmitAssessmentEvent({
    required this.id,
    required this.sharedId,
    required this.response,
  });

  @override
  List<Object?> get props => [id, response];
}

class FetchSubmittedResponsesEvent extends QuestionEvent {}

class FetchQuizzesEvent extends QuestionEvent {}
