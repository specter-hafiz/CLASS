import 'package:class_app/features/auth/domain/entities/user.dart';
import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class RequireOtpVerification extends AuthState {
  const RequireOtpVerification();
}

class SignupSuccess extends AuthState {
  final String message;
  final String email;
  const SignupSuccess(this.message, this.email);
  @override
  List<Object?> get props => [message, email];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class TokenVerified extends AuthState {
  final String message;

  const TokenVerified(this.message);
  @override
  List<Object?> get props => [message];
}
