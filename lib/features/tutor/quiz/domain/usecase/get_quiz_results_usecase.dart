import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';

class GetQuizResultsUsecase {
  QuestionsRepository questionsRepository;
  GetQuizResultsUsecase(this.questionsRepository);
  Future<List<Map<String, dynamic>>> call(String id) async {
    return await questionsRepository.fetchResults(id);
  }
}
