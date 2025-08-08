import 'package:class_app/features/tutor/quiz/data/models/question_model.dart';
import 'package:class_app/features/tutor/quiz/data/models/quiz_model.dart';
import 'package:class_app/features/tutor/quiz/data/models/submitted_response_model.dart';
import 'package:equatable/equatable.dart';

class QuestionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QuestionInitialState extends QuestionState {}

class QuestionLoadingState extends QuestionState {}

class FetchingQuizzesState extends QuestionState {}

class FetchQuizzesErrorState extends QuestionState {
  final String message;
  FetchQuizzesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GeneratingQuizzesState extends QuestionState {}

class SubmittingAssessmentState extends QuestionState {}

class SubmittedAssessmentState extends QuestionState {
  final int score;
  final int numberOfQuestions;

  SubmittedAssessmentState(this.score, this.numberOfQuestions);

  @override
  List<Object?> get props => [score, numberOfQuestions];
}

class SubmittingAssessmentError extends QuestionState {
  final String message;

  SubmittingAssessmentError(this.message);

  @override
  List<Object?> get props => [message];
}

class QuestionGeneratedState extends QuestionState {
  final List<Question> questions;

  QuestionGeneratedState(this.questions);

  @override
  List<Object?> get props => [questions];
}

class QuestionsGeneratedCompletedState extends QuestionState {}

class QuestionSharedState extends QuestionState {
  final List<Question> sharedQuestions;
  final String duration;
  final String startedAt;
  final String sharedLinkId;
  final String id;

  QuestionSharedState(
    this.sharedQuestions,
    this.duration,
    this.startedAt,
    this.sharedLinkId,
    this.id,
  );

  @override
  List<Object?> get props => [
    sharedQuestions,
    duration,
    startedAt,
    sharedLinkId,
    id,
  ];
}

class SubmitAssessmentState extends QuestionState {
  final Map<String, dynamic> response;

  SubmitAssessmentState(this.response);

  @override
  List<Object?> get props => [response];
}

class QuizzesFetchedState extends QuestionState {
  final List<Quiz> quizzes;

  QuizzesFetchedState(this.quizzes);

  @override
  List<Object?> get props => [quizzes];
}

class FetchingResponsesState extends QuestionState {}

class FetchedSubmittedResponsesState extends QuestionState {
  final List<SubmittedResponseModel> responses;

  FetchedSubmittedResponsesState(this.responses);

  @override
  List<Object?> get props => [responses];
}

class FetchingResponsesErrorState extends QuestionState {
  final String message;

  FetchingResponsesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class QuestionErrorState extends QuestionState {
  final String message;

  QuestionErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GetAnalyticsLoadingState extends QuestionState {}

class GetAnalyticsLoadedState extends QuestionState {
  final List<Map<String, dynamic>> analytics;

  GetAnalyticsLoadedState(this.analytics);

  @override
  List<Object?> get props => [analytics];
}

class GetQuizAnalyticsLoadedState extends QuestionState {
  final List<Map<String, dynamic>> analytics;

  GetQuizAnalyticsLoadedState(this.analytics);

  @override
  List<Object?> get props => [analytics];
}

class GetQuizAnalyticsLoadingState extends QuestionState {}

class GetQuizAnalyticsErrorState extends QuestionState {
  final String message;

  GetQuizAnalyticsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class GetAnalyticsErrorState extends QuestionState {
  final String message;

  GetAnalyticsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class FetchQuizResultsSuccessState extends QuestionState {
  final List<Map<String, dynamic>> results;
  FetchQuizResultsSuccessState(this.results);
  @override
  List<Object?> get props => [results];
}

class FetchingQuizResultsState extends QuestionState {}

class FetchQuizResultsErrorState extends QuestionState {
  final String message;
  FetchQuizResultsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
