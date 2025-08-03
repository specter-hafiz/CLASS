import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

class EditProfileUsecase {
  final AuthRepository authRepository;

  EditProfileUsecase(this.authRepository);

  Future<Map<String, dynamic>> call(String username) async {
    return await authRepository.editProfile(username);
  }
}
