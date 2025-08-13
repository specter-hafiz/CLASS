import 'package:class_app/features/auth/domain/entities/user.dart';
import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

import '../source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<User> login(String email, String password) {
    return remote.login(email, password);
  }

  @override
  Future<void> logout() {
    return remote.logout();
  }

  @override
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) {
    return remote.register(name, email, password);
  }

  @override
  Future<Map<String, dynamic>> verifyOTP(
    String email,
    String token,
    bool? isLoginSignUp,
  ) {
    return remote.verifyOTP(email, token, isLoginSignUp);
  }

  @override
  Future<Map<String, dynamic>> editProfile(String username) {
    return remote.editProfile(username);
  }

  @override
  Future<Map<String, dynamic>> loginWithGoogle(String googleId) {
    return remote.loginWithGoogle(googleId);
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) {
    return remote.forgotPassword(email);
  }

  @override
  Future<Map<String, dynamic>> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) {
    return remote.changePassword(userId, oldPassword, newPassword);
  }

  @override
  Future<Map<String, dynamic>> resetPassword(String email, String newPassword) {
    return remote.resetPassword(email, newPassword);
  }

  @override
  Future<Map<String, dynamic>> resendOTP(String email) {
    return remote.resendOTP(email);
  }

  @override
  Future<Map<String, dynamic>> uploadProfileImage(String imagePath) {
    return remote.uploadProfileImage(imagePath);
  }
}
