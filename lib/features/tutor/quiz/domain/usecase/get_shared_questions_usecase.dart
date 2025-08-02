import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';

class GetSharedQuestionsUsecase {
  final QuestionsRepository repository;

  GetSharedQuestionsUsecase(this.repository);

  Future<Map<String, dynamic>> call(String id) async {
    return await repository.getSharedQuestions(id);
  }
}
