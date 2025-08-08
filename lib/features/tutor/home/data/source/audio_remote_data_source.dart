import 'package:class_app/core/network/connectivity.dart';
import 'package:class_app/core/service/audio_service.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class AudioRemoteDataSource {
  Future<Map<String, dynamic>> uploadAudio(String filePath);
  Future<Map<String, dynamic>> transcribeAudio({required String audioUrl});
  // Future<List<String>> fetchAudioFiles();
  // Future<void> deleteAudioFile(String fileName);
}

class AudioRemoteDataSourceImpl implements AudioRemoteDataSource {
  final AudioTranscriptionService http;

  AudioRemoteDataSourceImpl(this.http);

  @override
  Future<Map<String, dynamic>> uploadAudio(String filePath) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    try {
      debugPrint("Uploading audio file: $filePath");
      final res = await http.uploadAudioForTranscription(filePath: filePath);
      return res;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        throw ServerException("Invalid audio file format or size.");
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw NetworkException("Connection timed out. Please try again.");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException(
          "Server took too long to respond. Please try again.",
        );
      }
    } catch (e) {
      throw ServerException("An unexpected error while uploading audio.");
    }
    throw ServerException("Audio upload Text for an unknown reason.");
  }

  @override
  Future<Map<String, dynamic>> transcribeAudio({
    required String audioUrl,
  }) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    if (audioUrl.isEmpty) {
      throw ArgumentError("Audio URL cannot be empty.");
    }
    return http.transcribeAudio(audioUrl: audioUrl);
  }
}
