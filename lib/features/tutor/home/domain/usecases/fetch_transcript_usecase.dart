import 'package:class_app/features/tutor/home/data/models/transcript_model.dart';
import 'package:class_app/features/tutor/home/domain/repository/transcript_repository.dart';

class FetchTranscriptUsecase {
  final TranscriptRepository transcriptRepository;

  FetchTranscriptUsecase(this.transcriptRepository);

  Future<Transcript> call({required String transcriptId}) async {
    return await transcriptRepository.fetchTranscript(
      transcriptId: transcriptId,
    );
  }
}
