import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

class ResetPasswordUsecase {
  AuthRepository authRepository;
  ResetPasswordUsecase(this.authRepository);
  Future<Map<String, dynamic>> call(String email, String newPassword) {
    return authRepository.resetPassword(email, newPassword);
  }
}
