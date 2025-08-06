import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';

class GenerateQuestionsUsecase {
  final QuestionsRepository repository;

  GenerateQuestionsUsecase(this.repository);

  Future<Map<String, dynamic>> call({
    required String transcript,
    required int numberOfQuestions,
    String title = "Generated Questions",
    required DateTime expiresAt,
    required String duration,
    required String accessPassword,
  }) async {
    return await repository.generateQuestions(
      transcript: transcript,
      numberOfQuestions: numberOfQuestions,
      title: title,
      expiresAt: expiresAt,
      duration: duration,
      accessPassword: accessPassword,
    );
  }
}
