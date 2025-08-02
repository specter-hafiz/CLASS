import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested(this.email, this.password);
}

class LogoutRequested extends AuthEvent {}

class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const RegisterRequested(this.name, this.email, this.password);
}

class VerifyTokenRequested extends AuthEvent {
  final String email;
  final String otp;

  const VerifyTokenRequested(this.email, this.otp);
}

class OTPVerificationRequested extends AuthEvent {
  final String message;

  const OTPVerificationRequested(this.message);

  @override
  List<Object?> get props => [message];
}
