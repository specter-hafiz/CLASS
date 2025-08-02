abstract class QuestionsRepository {
  Future<Map<String, dynamic>> fetchQuizzes();
  Future<Map<String, dynamic>> generateQuestions({
    required String transcript,
    required int numberOfQuestions,
    required String title,
    required DateTime expiresAt,
    required String duration,
    required String accessPassword,
  });
  Future<Map<String, dynamic>> getSharedQuestions(String id);
  Future<Map<String, dynamic>> submitAssessment({
    required String id,
    required Map<String, dynamic> response,
  });
}
