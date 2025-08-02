import 'package:class_app/core/service/trancript_service.dart';
import 'package:class_app/features/tutor/home/data/models/transcript_model.dart';

abstract class TranscriptRemoteDataSource {
  Future<List<Transcript>> fetchTranscripts();
  Future<Transcript> fetchTranscript({required String transcriptId});
  Future<Transcript> updateTranscript({
    required String transcriptId,
    required String content,
  });
  Future<void> deleteTranscript(String transcriptId);
}

class TranscriptRemoteDataSourceImpl implements TranscriptRemoteDataSource {
  final TrancriptService _trancriptService;

  TranscriptRemoteDataSourceImpl(this._trancriptService);

  @override
  Future<Transcript> fetchTranscript({required String transcriptId}) async {
    try {
      final response = await _trancriptService.fetchTranscript(
        transcriptId: transcriptId,
      );
      return Transcript.fromJson(response['transcript']);
    } catch (e) {
      throw Exception("Failed to fetch transcript: ${e.toString()}");
    }
  }

  @override
  Future<Transcript> updateTranscript({
    required String transcriptId,
    required String content,
  }) async {
    try {
      final response = await _trancriptService.updateTranscript(
        transcriptId: transcriptId,
        content: content,
      );
      return Transcript.fromJson(response['updatedTranscript']);
    } catch (e) {
      throw Exception("Failed to update transcript: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteTranscript(String transcriptId) async {
    try {
      await _trancriptService.deleteTranscript(transcriptId: transcriptId);
    } catch (e) {
      throw Exception("Failed to delete transcript: ${e.toString()}");
    }
  }

  @override
  Future<List<Transcript>> fetchTranscripts() {
    try {
      return _trancriptService.fetchTranscripts();
    } catch (e) {
      throw Exception("Failed to fetch transcripts: ${e.toString()}");
    }
  }

  // Additional methods can be added here as needed
}
