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

class EditProfileRequested extends AuthEvent {
  final String name;

  const EditProfileRequested(this.name);
}

class VerifyTokenRequested extends AuthEvent {
  final String email;
  final String otp;
  final bool? isLoginSignUp;

  const VerifyTokenRequested(this.email, this.otp, this.isLoginSignUp);
}

class OTPVerificationRequested extends AuthEvent {
  final String message;

  const OTPVerificationRequested(this.message);

  @override
  List<Object?> get props => [message];
}

class UploadProfileImageRequested extends AuthEvent {
  final String imagePath;

  const UploadProfileImageRequested(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ChangePasswordRequested extends AuthEvent {
  final String userId;
  final String oldPassword;
  final String newPassword;
  const ChangePasswordRequested(
    this.userId,
    this.oldPassword,
    this.newPassword,
  );

  @override
  List<Object?> get props => [userId, oldPassword, newPassword];
}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordRequested extends AuthEvent {
  final String email;
  final String newPassword;

  const ResetPasswordRequested({
    required this.email,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [email, newPassword];
}

class LoginWithGoogleRequested extends AuthEvent {
  const LoginWithGoogleRequested();
}
