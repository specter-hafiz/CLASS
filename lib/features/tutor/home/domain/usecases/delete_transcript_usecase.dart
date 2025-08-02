import 'package:class_app/features/tutor/home/domain/repository/transcript_repository.dart';

class DeleteTranscriptUsecase {
  final TranscriptRepository transcriptRepository;

  DeleteTranscriptUsecase(this.transcriptRepository);

  Future<void> call(String transcriptId) async {
    return await transcriptRepository.deleteTranscript(transcriptId);
  }
}
