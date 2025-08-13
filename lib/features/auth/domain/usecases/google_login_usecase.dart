import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

class GoogleLoginUsecase {
  AuthRepository repository;
  GoogleLoginUsecase(this.repository);
  Future<Map<String, dynamic>> call(String googleId) {
    return repository.loginWithGoogle(googleId);
  }
}
