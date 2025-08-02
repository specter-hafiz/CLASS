import 'package:class_app/features/tutor/home/data/models/transcript_model.dart';
import 'package:class_app/features/tutor/home/domain/repository/transcript_repository.dart';

class UpdateTranscriptUsecase {
  final TranscriptRepository transcriptRepository;

  UpdateTranscriptUsecase(this.transcriptRepository);

  Future<Transcript> call({
    required String transcriptId,
    required String content,
  }) async {
    return await transcriptRepository.updateTranscript(
      transcriptId: transcriptId,
      content: content,
    );
  }
}
