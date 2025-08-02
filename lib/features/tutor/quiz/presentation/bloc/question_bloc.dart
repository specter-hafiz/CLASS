import 'package:class_app/features/tutor/quiz/data/models/question_model.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/fetch_quizzes_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/generate_questions_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/get_shared_questions_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/submit_assessment_usecase.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_events.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionBloc extends Bloc<QuestionEvent, QuestionState> {
  final FetchQuizzesUsecase fetchQuizzesUsecase;
  final GetSharedQuestionsUsecase getSharedQuestionsUsecase;
  final SubmitAssessmentUsecase submitAssessmentUsecase;
  final GenerateQuestionsUsecase generateQuestionsUsecase;

  QuestionBloc(
    this.fetchQuizzesUsecase,
    this.getSharedQuestionsUsecase,
    this.submitAssessmentUsecase,
    this.generateQuestionsUsecase,
  ) : super(QuestionInitialState()) {
    on<GenerateQuestionsEventRequest>((event, emit) async {
      emit(QuestionLoadingState());
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
      emit(QuestionLoadingState());
      try {
        final quizzes = await fetchQuizzesUsecase();
        emit(QuizzesFetchedState(quizzes['quizzes']));
      } catch (e) {
        emit(QuestionErrorState(e.toString()));
      }
    });

    on<GetSharedQuestionsEvent>((event, emit) async {
      emit(QuestionLoadingState());
      try {
        final sharedQuestions = await getSharedQuestionsUsecase(event.id);
        emit(QuestionSharedState(sharedQuestions));
      } catch (e) {
        emit(QuestionErrorState(e.toString()));
      }
    });
    on<SubmitAssessmentEvent>((event, emit) async {
      emit(QuestionLoadingState());
      try {
        final response = await submitAssessmentUsecase(
          event.id,
          event.response,
        );
        emit(SubmitAssessmentState(response));
      } catch (e) {
        emit(QuestionErrorState(e.toString()));
      }
    });
  }
}
