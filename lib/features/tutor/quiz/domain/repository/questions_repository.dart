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
  Future<Map<String, dynamic>> getSharedQuestions(
    String id,
    String sharedId,
    String accessPassword,
  );
  Future<Map<String, dynamic>> submitAssessment({
    required String id,
    required String sharedId,
    required List<Map<String, dynamic>> response,
  });
  Future<Map<String, dynamic>> fetchSubmittedResponses();
  Future<List<Map<String, dynamic>>> fetchAnalytics();
  Future<List<Map<String, dynamic>>> getQuizAnalytics(String id);
  Future<List<Map<String, dynamic>>> fetchResults(String id);
}
