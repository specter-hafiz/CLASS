import 'package:class_app/features/tutor/home/data/models/transcript_model.dart';

abstract class TranscriptRepository {
  Future<List<Transcript>> fetchTranscripts();
  Future<Transcript> fetchTranscript({required String transcriptId});
  Future<Transcript> updateTranscript({
    required String transcriptId,
    required String content,
  });
  Future<void> deleteTranscript(String transcriptId);
}
