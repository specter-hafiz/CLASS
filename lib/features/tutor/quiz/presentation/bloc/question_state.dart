import 'package:class_app/features/tutor/quiz/data/models/question_model.dart';
import 'package:equatable/equatable.dart';

class QuestionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuestionInitialState extends QuestionState {}

class QuestionLoadingState extends QuestionState {}

class QuestionGeneratedState extends QuestionState {
  final List<Question> questions;

  QuestionGeneratedState(this.questions);

  @override
  List<Object?> get props => [questions];
}

class QuestionsGeneratedCompletedState extends QuestionState {}

class QuestionSharedState extends QuestionState {
  final Map<String, dynamic> sharedQuestions;

  QuestionSharedState(this.sharedQuestions);

  @override
  List<Object?> get props => [sharedQuestions];
}

class SubmitAssessmentState extends QuestionState {
  final Map<String, dynamic> response;

  SubmitAssessmentState(this.response);

  @override
  List<Object?> get props => [response];
}

class QuizzesFetchedState extends QuestionState {
  final List<Map<String, dynamic>> quizzes;

  QuizzesFetchedState(this.quizzes);

  @override
  List<Object?> get props => [quizzes];
}

class QuestionErrorState extends QuestionState {
  final String message;

  QuestionErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
