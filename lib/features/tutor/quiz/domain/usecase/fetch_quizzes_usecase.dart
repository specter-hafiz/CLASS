import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';

class FetchQuizzesUsecase {
  final QuestionsRepository repository;
  FetchQuizzesUsecase(this.repository);
  Future<Map<String, dynamic>> call() async {
    return await repository.fetchQuizzes();
  }
}
