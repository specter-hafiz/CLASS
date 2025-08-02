import 'package:class_app/features/tutor/home/data/models/transcript_model.dart';
import 'package:class_app/features/tutor/home/domain/repository/transcript_repository.dart';

class FetchTranscriptsUsecase {
  final TranscriptRepository transcriptRepository;
  FetchTranscriptsUsecase(this.transcriptRepository);
  Future<List<Transcript>> call() async {
    return await transcriptRepository.fetchTranscripts();
  }
}
