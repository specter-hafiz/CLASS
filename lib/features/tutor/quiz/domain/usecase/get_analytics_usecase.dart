import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';

class GetAnalyticsUsecase {
  final QuestionsRepository _questionsRepository;

  GetAnalyticsUsecase(this._questionsRepository);

  Future<List<Map<String, dynamic>>> call() async {
    return await _questionsRepository.fetchAnalytics();
  }
}
