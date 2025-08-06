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
  Future<Map<String, dynamic>> getSharedQuestions(
    String id,
    String sharedId,
    String accessPassword,
  );
  Future<Map<String, dynamic>> submitAssessment({
    required String id,
    required String sharedId,
    required List<Map<String, dynamic>> response,
  });

  Future<Map<String, dynamic>> fetchSubmittedResponses();
  Future<List<Map<String, dynamic>>> fetchAnalytics();
  Future<List<Map<String, dynamic>>> getQuizAnalytics(String id);
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
  Future<Map<String, dynamic>> getSharedQuestions(
    String id,
    String sharedId,
    String accessPassword,
  ) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    return http.getSharedQuestions(
      id: id,
      sharedId: sharedId,
      accessPassword: accessPassword,
    );
  }

  @override
  Future<Map<String, dynamic>> submitAssessment({
    required String id,
    required String sharedId,
    required List<Map<String, dynamic>> response,
  }) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    return http.submitAssessment(id: id, answers: response, sharedId: sharedId);
  }

  @override
  Future<Map<String, dynamic>> fetchSubmittedResponses() async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    return http.fetchSubmittedResponses();
  }

  @override
  Future<List<Map<String, dynamic>>> fetchAnalytics() async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    return http.fetchAnalytics();
  }

  @override
  Future<List<Map<String, dynamic>>> getQuizAnalytics(String id) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    return http.getQuizAnalytics(id);
  }
}
