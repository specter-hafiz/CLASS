import 'package:class_app/core/constants/app_secrets.dart';
import 'package:class_app/core/network/connectivity.dart';
import 'package:class_app/core/service/api/endpoints.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:class_app/core/service/shared_pref/shared_pref.dart';
import 'package:class_app/core/utilities/dependency_injection.dart';
import 'package:class_app/features/auth/data/source/auth_remote_data_source.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class AudioTranscriptionService {
  final Dio _dio;

  AudioTranscriptionService(this._dio) {
    _dio.options.baseUrl = AppSecrets.baseUrl; // change this
    _dio.options.sendTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(minutes: 1);
  }

  Future<Map<String, dynamic>> uploadAudioForTranscription({
    required String filePath,
  }) async {
    try {
      bool hasConnection = await NetworkConnectivity().isConnected;
      if (!hasConnection) {
        throw NetworkException("No internet connection");
      }

      // Prepare the form data with the audio file
      logger.i("Uploading audio file: $filePath");
      if (filePath.isEmpty) {
        throw ServerException("File path cannot be empty");
      }
      final token = await sl<SharedPrefService>().getToken().then(
        (value) => value ?? '',
      );

      final response = await _dio.post(
        Endpoints.uploadAudio,
        data: FormData.fromMap({
          'audio': await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
            contentType: MediaType('audio', 'mpeg'),
          ),
        }),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          receiveTimeout: const Duration(minutes: 10),
          sendTimeout: const Duration(minutes: 20),
        ),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerException("Failed to transcribe audio file.");
      }
    } catch (e) {
      throw Exception("Transcription error: ${e.toString()}");
    }
  }

  Future<Map<String, dynamic>> transcribeAudio({
    required String audioUrl,
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
        Endpoints.transcribeAudio,
        data: {'audioUrl': audioUrl},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          receiveTimeout: const Duration(minutes: 20),
          sendTimeout: const Duration(minutes: 20),
        ),
      );
      return response.data;
    } catch (e) {
      throw Exception("Transcription error: ${e.toString()}");
    }
  }
}
