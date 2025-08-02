import 'package:class_app/features/tutor/home/data/source/audio_remote_data_source.dart';
import 'package:class_app/features/tutor/home/domain/repository/audio_repo.dart';

class AudioRepoImpl implements AudioRepository {
  final AudioRemoteDataSource remoteDataSource;

  AudioRepoImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> uploadAudio(String filePath) async {
    return await remoteDataSource.uploadAudio(filePath);
  }

  @override
  Future<Map<String, dynamic>> transcribeAudio({required String audioUrl}) {
    return remoteDataSource.transcribeAudio(audioUrl: audioUrl);
  }
}
