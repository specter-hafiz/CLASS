import 'package:class_app/features/auth/domain/entities/user.dart';
import 'package:class_app/features/auth/domain/repository/auth_repository.dart';

import '../source/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<User> login(String email, String password) {
    return remote.login(email, password);
  }

  @override
  Future<void> logout() {
    return remote.logout();
  }

  @override
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) {
    return remote.register(name, email, password);
  }

  @override
  Future<Map<String, dynamic>> verifyToken(String email, String token) {
    return remote.verifyToken(email, token);
  }

  @override
  Future<Map<String, dynamic>> editProfile(String username) {
    return remote.editProfile(username);
  }
}
