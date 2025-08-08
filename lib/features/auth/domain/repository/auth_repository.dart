import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  );
  Future<Map<String, dynamic>> verifyOTP(
    String email,
    String token,
    bool? isLoginSignUp,
  );
  Future<Map<String, dynamic>> editProfile(String username);
  Future<Map<String, dynamic>> loginWithGoogle(
    String username,
    String email,
    String googleId,
  );
  Future<Map<String, dynamic>> forgotPassword(String email);
  Future<Map<String, dynamic>> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  );
  Future<Map<String, dynamic>> resetPassword(String email, String newPassword);
  Future<Map<String, dynamic>> resendOTP(String email);
  Future<Map<String, dynamic>> uploadProfileImage(String imagePath);
}
