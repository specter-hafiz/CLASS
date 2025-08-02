import 'package:class_app/features/tutor/home/domain/repository/audio_repo.dart';

class UploadAudioUseCase {
  final AudioRepository audioRepository;

  UploadAudioUseCase(this.audioRepository);

  Future<Map<String, dynamic>> call(String filePath) async {
    if (filePath.isEmpty) {
      throw ArgumentError("Audio file path cannot be empty.");
    }
    return await audioRepository.uploadAudio(filePath);
  }
}
