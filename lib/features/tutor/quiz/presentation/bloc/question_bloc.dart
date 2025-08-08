import 'package:class_app/features/tutor/quiz/data/models/question_model.dart';
import 'package:class_app/features/tutor/quiz/data/models/quiz_model.dart';
import 'package:class_app/features/tutor/quiz/data/models/submitted_response_model.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/fetch_quizzes_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/fetch_submitted_responses.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/generate_questions_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/get_analytics_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/get_quiz_analytics_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/get_quiz_results_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/get_shared_questions_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/submit_assessment_usecase.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_events.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final FetchQuizzesUsecase fetchQuizzesUsecase;
  final GetSharedQuestionsUsecase getSharedQuestionsUsecase;
  final SubmitAssessmentUsecase submitAssessmentUsecase;
  final FetchSubmittedResponsesUsecase fetchSubmittedResponsesUsecase;
  final GenerateQuestionsUsecase generateQuestionsUsecase;
  final GetAnalyticsUsecase getAnalyticsUsecase;
  final GetQuizAnalyticsUsecase getQuizAnalyticsUsecase;
  final GetQuizResultsUsecase getQuizResultsUsecase;
  QuestionBloc(
    this.fetchQuizzesUsecase,
    this.getSharedQuestionsUsecase,
    this.submitAssessmentUsecase,
    this.generateQuestionsUsecase,
    this.fetchSubmittedResponsesUsecase,
    this.getAnalyticsUsecase,
    this.getQuizAnalyticsUsecase,
    this.getQuizResultsUsecase,
  ) : super(QuestionInitialState()) {
    on<GenerateQuestionsEventRequest>((event, emit) async {
      emit(GeneratingQuizzesState());
      try {
        final questions = await generateQuestionsUsecase(
          transcript: event.transcript,
          numberOfQuestions: event.numberOfQuestions,
          title: event.title,
          expiresAt: event.expiresAt,
          duration: event.duration,
          accessPassword: event.accessPassword,
        );
        emit(
          QuestionGeneratedState(
            (questions['questions'] as List)
                .map((q) => Question.fromJson(q))
                .toList(),
          ),
        );
        emit(QuestionsGeneratedCompletedState());
      } catch (e) {
        emit(QuestionErrorState(e.toString()));
      }
    });
    on<FetchQuizzesEvent>((event, emit) async {
      emit(FetchingQuizzesState());
      try {
        final quizzes = await fetchQuizzesUsecase();
        emit(
          QuizzesFetchedState(
            (quizzes['quizzes'] as List)
                .map((q) => Quiz.fromJson(q as Map<String, dynamic>))
                .toList(),
          ),
        );
      } catch (e) {
        emit(FetchQuizzesErrorState(e.toString()));
      }
    });

    on<GetSharedQuestionsEvent>((event, emit) async {
      emit(QuestionLoadingState());
      try {
        final sharedQuestions = await getSharedQuestionsUsecase(
          event.id,
          event.sharedId,
          event.accessPassword,
        );
        emit(
          QuestionSharedState(
            (sharedQuestions['questions'] as List)
                .map((q) => Question.fromJson(q as Map<String, dynamic>))
                .toList(),
            sharedQuestions['duration'] as String,
            sharedQuestions['startedAt'] as String,
            sharedQuestions['sharedLinkId'] as String,
            sharedQuestions['id'] as String, // Ensure 'id' is included
          ),
        );
      } catch (e) {
        emit(QuestionErrorState(e.toString()));
      }
    });
    on<SubmitAssessmentEvent>((event, emit) async {
      emit(SubmittingAssessmentState());
      try {
        final response = await submitAssessmentUsecase(
          event.id,
          event.response,
          event.sharedId,
        );
        emit(
          SubmittedAssessmentState(
            response['score'] as int,
            response['totalQuestions'] as int,
          ),
        );
      } catch (e) {
        emit(SubmittingAssessmentError(e.toString()));
      }
    });

    on<FetchSubmittedResponsesEvent>((event, emit) async {
      emit(FetchingResponsesState());
      try {
        final responses = await fetchSubmittedResponsesUsecase();
        emit(
          FetchedSubmittedResponsesState(
            (responses['responses'] as List)
                .map(
                  (r) => SubmittedResponseModel.fromJson(
                    r as Map<String, dynamic>,
                  ),
                )
                .toList(),
          ),
        );
      } catch (e) {
        emit(FetchingResponsesErrorState(e.toString()));
      }
    });

    on<GetAnalyticsEvent>((event, emit) async {
      emit(GetAnalyticsLoadingState());
      try {
        final analytics = await getAnalyticsUsecase();
        emit(
          GetAnalyticsLoadedState(List<Map<String, dynamic>>.from(analytics)),
        );
      } catch (e) {
        emit(GetAnalyticsErrorState(e.toString()));
      }
    });

    on<GetQuizAnalyticsEvent>((event, emit) async {
      emit(GetQuizAnalyticsLoadingState());
      try {
        final analytics = await getQuizAnalyticsUsecase(event.id);
        emit(GetQuizAnalyticsLoadedState(analytics));
      } catch (e) {
        emit(GetQuizAnalyticsErrorState(e.toString()));
      }
    });

    on<FetchQuizResultsEvent>((event, emit) async {
      emit(FetchingQuizResultsState());
      try {
        final results = await getQuizResultsUsecase(event.id);
        emit(FetchQuizResultsSuccessState(results));
      } catch (e) {
        emit(FetchQuizResultsErrorState(e.toString()));
      }
    });
  }
}
