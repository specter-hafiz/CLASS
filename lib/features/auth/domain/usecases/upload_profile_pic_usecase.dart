import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

class UploadProfilePicUsecase {
  AuthRepository authRepository;
  UploadProfilePicUsecase(this.authRepository);
  Future<Map<String, dynamic>> call(String imagePath) {
    return authRepository.uploadProfileImage(imagePath);
  }
}
