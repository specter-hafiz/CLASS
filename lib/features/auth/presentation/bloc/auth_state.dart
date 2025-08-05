import 'package:class_app/features/auth/data/models/user_model.dart';
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
  final UserModel? user;

  const TokenVerified(this.message, {this.user});
  @override
  List<Object?> get props => [message, user];
}

class EditProfileStarting extends AuthState {}

class EditProfileSuccess extends AuthState {
  final String message;

  const EditProfileSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class EditProfileError extends AuthState {
  final String message;

  const EditProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

class ChangingPassword extends AuthState {}

class ChangePasswordSuccess extends AuthState {
  final String message;
  const ChangePasswordSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ChangePasswordError extends AuthState {
  final String message;
  const ChangePasswordError(this.message);
  @override
  List<Object?> get props => [message];
}

class ForgotPasswordSuccess extends AuthState {
  final String message;
  final String email;

  const ForgotPasswordSuccess(this.message, this.email);
  @override
  List<Object?> get props => [message, email];
}

class ForgotPasswordError extends AuthState {
  final String message;

  const ForgotPasswordError(this.message);
  @override
  List<Object?> get props => [message];
}

class ForgotPasswordStarting extends AuthState {}

class ResetPasswordSuccess extends AuthState {
  final String message;

  const ResetPasswordSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ResetPasswordError extends AuthState {
  final String message;

  const ResetPasswordError(this.message);
  @override
  List<Object?> get props => [message];
}

class ResetPasswordStarting extends AuthState {}
