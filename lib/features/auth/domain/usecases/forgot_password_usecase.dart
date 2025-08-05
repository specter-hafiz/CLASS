import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

class ForgotPasswordUsecase {
  AuthRepository authRepository;
  ForgotPasswordUsecase(this.authRepository);
  Future<Map<String, dynamic>> call(String email) {
    return authRepository.forgotPassword(email);
  }
}
