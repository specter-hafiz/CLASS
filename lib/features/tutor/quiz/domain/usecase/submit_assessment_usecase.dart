import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';

class SubmitAssessmentUsecase {
  final QuestionsRepository repository;

  SubmitAssessmentUsecase(this.repository);

  Future<Map<String, dynamic>> call(
    String id,
    List<Map<String, dynamic>> response,
    String sharedId,
  ) async {
    return await repository.submitAssessment(
      id: id,
      sharedId: sharedId,
      response: response,
    );
  }
}
