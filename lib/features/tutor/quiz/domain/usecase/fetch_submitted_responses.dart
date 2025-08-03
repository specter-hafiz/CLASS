import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';

class FetchSubmittedResponsesUsecase {
  QuestionsRepository repository;
  FetchSubmittedResponsesUsecase(this.repository);
  Future<Map<String, dynamic>> call() async {
    return await repository.fetchSubmittedResponses();
  }
}
