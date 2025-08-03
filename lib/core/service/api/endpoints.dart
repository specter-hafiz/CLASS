class Endpoints {
  // AUTH ROUTES
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String refreshToken = '/auth/refresh-token';
  static const String googleLogin = '/auth/google-login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String verifyOTP = '/auth/verify-otp';
  static const String editProfile = '/auth/edit-profile';

  // AUDIO ROUTES
  static const String transcribeAudio = '/audio/transcribe';
  static const String uploadAudio = '/audio/upload';
  static const String estimateTime = '/audio/estimate-time';

  // TRANSCRIPTS ROUTES
  static const String fetchTranscripts = '/transcripts';
  static String getTranscript(String id) => '/transcripts/$id';
  static String deleteTranscript(String id) => '/transcripts/$id';
  static String updateTranscript(String id) => '/transcripts/$id';

  // QUESTIONS ROUTE
  static const String generateQuestions = '/questions/generate';
  static String getQuestions(String id) => '/questions/shared/$id';
  static String submitAssessment(String id) => '/questions/response/$id';
  static const String fetchQuestions = '/questions/fetch';
  static const String fetchSubmittedResponses = '/questions/fetch/responses';
}
