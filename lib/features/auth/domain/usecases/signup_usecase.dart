import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

class SignupUsecase {
  final AuthRepository repository;
  SignupUsecase(this.repository);
  Future<Map<String, dynamic>> call(
    String name,
    String email,
    String password,
  ) {
    return repository.register(name, email, password);
  }
}
