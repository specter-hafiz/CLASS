import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';

class GetQuizAnalyticsUsecase {
  final QuestionsRepository _questionsRepository;
  GetQuizAnalyticsUsecase(this._questionsRepository);
  Future<List<Map<String, dynamic>>> call(String id) async {
    return await _questionsRepository.getQuizAnalytics(id);
  }
}
