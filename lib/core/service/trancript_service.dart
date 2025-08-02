import 'package:class_app/core/constants/app_secrets.dart';
import 'package:class_app/core/network/connectivity.dart';
import 'package:class_app/core/service/api/endpoints.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:class_app/core/service/shared_pref/shared_pref.dart';
import 'package:class_app/core/utilities/dependency_injection.dart';
import 'package:class_app/features/tutor/home/data/models/transcript_model.dart';
import 'package:dio/dio.dart';

class TrancriptService {
  final Dio _dio;
  TrancriptService(this._dio) {
    _dio.options.baseUrl = AppSecrets.testUrl; // change this
    _dio.options.sendTimeout = const Duration(minutes: 2);
    _dio.options.receiveTimeout = const Duration(minutes: 5);
  }

  Future<List<Transcript>> fetchTranscripts() async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );
      final response = await _dio.get(
        Endpoints.fetchTranscripts,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      print("Response: ${response.data}");
      return response.data['transcripts'] != null
          ? List<Transcript>.from(
            response.data['transcripts'].map(
              (transcript) => Transcript.fromJson(transcript),
            ),
          )
          : [];
    } catch (e) {
      throw Exception("Failed to fetch transcript: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> fetchTranscript({
    required String transcriptId,
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
        Endpoints.getTranscript(transcriptId),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      return response.data;
    } catch (e) {
      print("Error fetching transcript: ${e.toString()}");
      throw Exception("Failed to fetch transcript: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> updateTranscript({
    required String transcriptId,
    required String content,
  }) async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );
      final response = await _dio.patch(
        Endpoints.updateTranscript(transcriptId),
        data: {'transcript': content},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
      return response.data;
    } catch (e) {
      print("Error updating transcript: ${e.toString()}");
      throw Exception("Failed to update transcript: ${e.toString()}");
    }
  }

  Future<void> deleteTranscript({required String transcriptId}) async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );
      await _dio.delete(
        Endpoints.deleteTranscript(transcriptId),
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(minutes: 5),
          sendTimeout: const Duration(minutes: 2),
        ),
      );
    } catch (e) {
      throw Exception("Failed to delete transcript: ${e.toString()}");
    }
  }
}
