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
    _dio.options.sendTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
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

      return response.data;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        // Server responded with error data
        final errorMessage =
            e.response?.data['message'] ?? 'Unexpected error occurred';
        throw Exception(errorMessage); // Or custom exception
      } else {
        // No response from server or other Dio issues
        throw Exception('Network error. Please try again.');
      }
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
      return response.data;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        // Server responded with error data
        final errorMessage =
            e.response?.data['message'] ?? 'Unexpected error occurred';
        throw Exception(errorMessage); // Or custom exception
      } else {
        // No response from server or other Dio issues
        throw Exception('Network error. Please try again.');
      }
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
      return response.data;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        // Server responded with error data
        final errorMessage =
            e.response?.data['message'] ?? 'Unexpected error occurred';
        throw Exception(errorMessage); // Or custom exception
      } else {
        // No response from server or other Dio issues
        throw Exception('Network error. Please try again.');
      }
    } catch (e) {
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
      print("Submit Response: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        // Server responded with error data
        final errorMessage =
            e.response?.data['message'] ?? 'Unexpected error occurred';
        throw Exception(errorMessage); // Or custom exception
      } else {
        // No response from server or other Dio issues
        throw Exception('Network error. Please try again.');
      }
    } catch (e) {
      print("Error submitting assessment: ${e.toString()}");
      throw Exception(e.toString());
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
      print("Submitted Responses: ${response.data}");
      return response.data;
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        // Server responded with error data
        final errorMessage =
            e.response?.data['message'] ?? 'Unexpected error occurred';
        throw Exception(errorMessage); // Or custom exception
      } else {
        // No response from server or other Dio issues
        throw Exception('Network error. Please try again.');
      }
    } catch (e) {
      throw Exception("Error fetching submitted responses: ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>> fetchAnalytics() async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );
      final response = await _dio.get(
        Endpoints.getAnalytics,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      return List<Map<String, dynamic>>.from(response.data['analytics']);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        // Server responded with error data
        final errorMessage =
            e.response?.data['message'] ?? 'Unexpected error occurred';
        throw Exception(errorMessage); // Or custom exception
      } else {
        // No response from server or other Dio issues
        throw Exception('Network error. Please try again.');
      }
    } catch (e) {
      throw Exception("Error fetching quiz analytics: ${e.toString()}");
    }
  }

  Future<List<Map<String, dynamic>>> getQuizAnalytics(String id) async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );
      final response = await _dio.get(
        Endpoints.getQuizAnalytics(id),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      return List<Map<String, dynamic>>.from(response.data['analytics']);
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        // Server responded with error data
        final errorMessage =
            e.response?.data['message'] ?? 'Unexpected error occurred';
        throw Exception(errorMessage); // Or custom exception
      } else {
        // No response from server or other Dio issues
        throw Exception('Network error. Please try again.');
      }
    } catch (e) {
      throw Exception("Error fetching quiz analytics: ${e.toString()}");
    }
  }
}
