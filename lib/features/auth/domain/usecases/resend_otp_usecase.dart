import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

class ResendOtpUsecase {
  AuthRepository authRepository;
  ResendOtpUsecase(this.authRepository);
  Future<Map<String, dynamic>> call(String email) {
    return authRepository.resendOTP(email);
  }
}
