import 'package:class_app/features/tutor/home/domain/repository/audio_repo.dart';

class TranscribeAudioUseCase {
  final AudioRepository audioRepository;

  TranscribeAudioUseCase(this.audioRepository);

  Future<Map<String, dynamic>> call(String audioUrl) async {
    if (audioUrl.isEmpty) {
      throw ArgumentError("Audio URL cannot be empty.");
    }
    return await audioRepository.transcribeAudio(audioUrl: audioUrl);
  }
}
