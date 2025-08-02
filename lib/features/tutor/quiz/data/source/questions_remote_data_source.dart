import 'package:class_app/core/network/connectivity.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:class_app/core/service/questions_service.dart';

abstract class QuestionsRemoteDataSource {
  Future<Map<String, dynamic>> generateQuestions({
    required String transcript,
    required int numberOfQuestions,
    required String title,
    required DateTime expiresAt,
    required String duration,
    required String accessPassword,
  });
  Future<Map<String, dynamic>> fetchQuizzes();
  Future<Map<String, dynamic>> getSharedQuestions(String id);
  Future<Map<String, dynamic>> submitAssessment({
    required String id,
    required Map<String, dynamic> response,
  });
}

class QuestionsRemoteDataSourceImpl implements QuestionsRemoteDataSource {
  final QuestionsService http;
  QuestionsRemoteDataSourceImpl(this.http);
  @override
  Future<Map<String, dynamic>> fetchQuizzes() async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    return http.fetchQuizzes();
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
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    return http.generateQuestions(
      transcript: transcript,
      numberOfQuestions: numberOfQuestions,
      title: title,
      expiresAt: expiresAt,
      duration: duration,
      accessPassword: accessPassword,
    );
  }

  @override
  Future<Map<String, dynamic>> getSharedQuestions(String id) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    return http.getSharedQuestions(id: id);
  }

  @override
  Future<Map<String, dynamic>> submitAssessment({
    required String id,
    required Map<String, dynamic> response,
  }) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    return http.submitAssessment(id: id, answers: response);
  }
}
