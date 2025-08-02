import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';

class SubmitAssessmentUsecase {
  final QuestionsRepository repository;

  SubmitAssessmentUsecase(this.repository);

  Future<Map<String, dynamic>> call(
    String id,
    Map<String, dynamic> response,
  ) async {
    return await repository.submitAssessment(id: id, response: response);
  }
}
