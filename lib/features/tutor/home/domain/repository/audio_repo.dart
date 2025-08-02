abstract class AudioRepository {
  Future<Map<String, dynamic>> uploadAudio(String filePath);
  Future<Map<String, dynamic>> transcribeAudio({required String audioUrl});
  // Future<List<String>> fetchAudioList();
  // Future<void> deleteAudio(String audioId);
}
