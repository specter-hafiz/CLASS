import 'package:class_app/core/constants/app_secrets.dart';
import 'package:class_app/core/network/connectivity.dart';
import 'package:class_app/core/service/api/endpoints.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:class_app/core/service/shared_pref/shared_pref.dart';
import 'package:class_app/core/utilities/dependency_injection.dart';
import 'package:dio/dio.dart';

class QuestionsService {
  final Dio _dio;
  QuestionsService(this._dio) {
    _dio.options.baseUrl = AppSecrets.testUrl; // change this
    _dio.options.sendTimeout = const Duration(minutes: 2);
    _dio.options.receiveTimeout = const Duration(minutes: 5);
  }

  Future<Map<String, dynamic>> generateQuestions({
    required String transcript,
    required int numberOfQuestions,
    required String title,
    required DateTime expiresAt,
    required String duration,
    required String accessPassword,
  }) async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );
      print("Start generating questions with transcript: $transcript");

      final response = await _dio.post(
        Endpoints.generateQuestions,
        data: {
          'transcript': transcript,
          'numberOfQuestions': numberOfQuestions,
          'title': title,
          'expiresAt': expiresAt.toIso8601String(),
          'duration': duration,
          'accessPassword': accessPassword,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      print(
        "Generate Questions Response: ${response.data['questions']}, ${response.data['linkId']}, ${response.data['message']}",
      );
      return response.data;
    } catch (e) {
      throw Exception("Error generating questions: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> fetchQuizzes() async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );
      final response = await _dio.get(
        Endpoints.fetchQuestions,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      print("Fetch Questions Response: ${response.data}");
      return response.data;
    } catch (e) {
      throw Exception("Error fetching questions: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> getSharedQuestions({
    required String id,
    required String sharedId,
    required String accessPassword,
  }) async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );
      print("Start fetching shared questions with id: $sharedId");
      final response = await _dio.get(
        Endpoints.getQuestions(sharedId),
        data: {'id': id, 'accessPassword': accessPassword},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      print("Get Shared Questions Response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error fetching shared questions: ${e.toString()}");
      throw Exception("Error fetching shared questions: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> submitAssessment({
    required String sharedId,
    required String id,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );
      print("Start submitting assessment with id: $id and sharedId: $sharedId");
      print("Answers: $answers");
      final response = await _dio.post(
        Endpoints.submitAssessment(sharedId),
        data: {'id': id, 'answers': answers},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      print("Submit Assessment Response: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error submitting assessment: ${e.toString()}");
      throw Exception("Error submitting assessment: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> fetchSubmittedResponses() async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );
      print("Start fetching submitted responses");
      final response = await _dio.get(
        Endpoints.fetchSubmittedResponses,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      print("Fetch Submitted Responses: ${response.data}");
      return response.data;
    } catch (e) {
      print("Error fetching submitted responses: ${e.toString()}");
      throw Exception("Error fetching submitted responses: ${e.toString()}");
    }
  }
}
