import 'package:class_app/features/tutor/quiz/data/source/questions_remote_data_source.dart';
import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';

class QuestionsRepoImpl implements QuestionsRepository {
  final QuestionsRemoteDataSource remoteDataSource;
  QuestionsRepoImpl(this.remoteDataSource);
  @override
  Future<Map<String, dynamic>> fetchQuizzes() async {
    return await remoteDataSource.fetchQuizzes();
  }

  @override
  Future<Map<String, dynamic>> generateQuestions({
    required String transcript,
    required int numberOfQuestions,
    required String title,
    required DateTime expiresAt,
    required String duration,
    required String accessPassword,
  }) async {
    return await remoteDataSource.generateQuestions(
      transcript: transcript,
      numberOfQuestions: numberOfQuestions,
      title: title,
      expiresAt: expiresAt,
      duration: duration,
      accessPassword: accessPassword,
    );
  }

  @override
  Future<Map<String, dynamic>> getSharedQuestions(
    String id,
    String sharedId,
    String accessPassword,
  ) async {
    return await remoteDataSource.getSharedQuestions(
      id,
      sharedId,
      accessPassword,
    );
  }

  @override
  Future<Map<String, dynamic>> submitAssessment({
    required String id,
    required String sharedId,
    required List<Map<String, dynamic>> response,
  }) async {
    return await remoteDataSource.submitAssessment(
      id: id,
      sharedId: sharedId,
      response: response,
    );
  }

  @override
  Future<Map<String, dynamic>> fetchSubmittedResponses() async {
    return await remoteDataSource.fetchSubmittedResponses();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAnalytics() async {
    return await remoteDataSource.fetchAnalytics();
  }

  @override
  Future<List<Map<String, dynamic>>> getQuizAnalytics(String id) async {
    return await remoteDataSource.getQuizAnalytics(id);
  }

  @override
  Future<List<Map<String, dynamic>>> fetchResults(String id) async {
    return await remoteDataSource.fetchResults(id);
  }
}
