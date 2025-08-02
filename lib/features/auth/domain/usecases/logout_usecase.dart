import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

class LogoutUsecase {
  final AuthRepository repository;

  LogoutUsecase(this.repository);

  Future<void> call() {
    return repository.logout();
  }
}
