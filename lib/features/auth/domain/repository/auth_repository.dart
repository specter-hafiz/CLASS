import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  );
  Future<Map<String, dynamic>> verifyToken(String email, String token);
  Future<Map<String, dynamic>> editProfile(String username);
}
