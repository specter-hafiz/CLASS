import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

class VerifytokenUsecase {
  final AuthRepository repository;

  VerifytokenUsecase(this.repository);

  Future<Map<String, dynamic>> call(String email, String token) {
    return repository.verifyToken(email, token);
  }
}
