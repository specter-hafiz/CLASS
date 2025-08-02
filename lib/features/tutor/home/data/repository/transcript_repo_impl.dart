import 'package:class_app/features/tutor/home/data/models/transcript_model.dart';
import 'package:class_app/features/tutor/home/data/source/transcript_data_source.dart';
import 'package:class_app/features/tutor/home/domain/repository/transcript_repository.dart';

class TranscriptRepoImpl implements TranscriptRepository {
  final TranscriptRemoteDataSource remoteDataSource;

  TranscriptRepoImpl(this.remoteDataSource);

  @override
  Future<void> deleteTranscript(String transcriptId) {
    return remoteDataSource.deleteTranscript(transcriptId);
  }

  @override
  Future<Transcript> fetchTranscript({required String transcriptId}) {
    return remoteDataSource.fetchTranscript(transcriptId: transcriptId);
  }

  @override
  Future<List<Transcript>> fetchTranscripts() {
    return remoteDataSource.fetchTranscripts();
  }

  @override
  Future<Transcript> updateTranscript({
    required String transcriptId,
    required String content,
  }) {
    return remoteDataSource.updateTranscript(
      transcriptId: transcriptId,
      content: content,
    );
  }
}
