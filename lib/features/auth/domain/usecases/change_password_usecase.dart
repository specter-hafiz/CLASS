import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

class ChangePasswordUsecase {
  AuthRepository authRepository;
  ChangePasswordUsecase(this.authRepository);
  Future<Map<String, dynamic>> call(
    String userId,
    String oldPassword,
    String newPassword,
  ) {
    return authRepository.changePassword(userId, oldPassword, newPassword);
  }
}
