import 'package:bloc/bloc.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:class_app/features/auth/data/models/user_model.dart';
import 'package:class_app/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/edit_profile_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/upload_profile_pic_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUsecase logoutUseCase;
  final SignupUsecase registerUseCase;
  final VerifytokenUsecase verifyTokenUsecase;
  final EditProfileUsecase editProfileUsecase; //
  final GoogleLoginUsecase googleLoginUsecase; //
  final ForgotPasswordUsecase forgotPasswordUsecase; //
  final ChangePasswordUsecase changePasswordUsecase; //
  final ResetPasswordUsecase resetPasswordUsecase; //
  final ResendOtpUsecase resendOtpUsecase;
  final UploadProfilePicUsecase uploadProfilePicUsecase;

  AuthBloc(
    this.loginUseCase,
    this.logoutUseCase,
    this.registerUseCase,
    this.verifyTokenUsecase,
    this.editProfileUsecase,
    this.googleLoginUsecase,
    this.forgotPasswordUsecase,
    this.changePasswordUsecase,
    this.resetPasswordUsecase,
    this.resendOtpUsecase,
    this.uploadProfilePicUsecase,
  ) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase(event.email, event.password);
        emit(AuthAuthenticated(user));
      } on NetworkException catch (e) {
        emit(AuthError(e.message));
      } on OTPVerificationException {
        emit(RequireOtpVerification());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      await logoutUseCase();
      emit(AuthInitial());
    });

    on<RegisterRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await registerUseCase(
          event.name,
          event.email,
          event.password,
        );
        emit(SignupSuccess(response['email'], response['message']));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<VerifyTokenRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await verifyTokenUsecase(
          event.email,
          event.otp,
          event.isLoginSignUp,
        );
        debugPrint("Token verification response: $response");
        emit(
          TokenVerified(
            response['msg'],
            user: UserModel.fromJson(response['results']['user']),
          ),
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<EditProfileRequested>((event, emit) async {
      emit(EditProfileStarting());
      try {
        final response = await editProfileUsecase(event.name);
        emit(EditProfileSuccess(response['message']));
      } catch (e) {
        emit(EditProfileError(e.toString()));
      }
    });

    on<ChangePasswordRequested>((event, emit) async {
      emit(ChangingPassword());
      try {
        final response = await changePasswordUsecase(
          event.userId,
          event.oldPassword,
          event.newPassword,
        );
        emit(ChangePasswordSuccess(response['message']));
      } catch (e) {
        emit(ChangePasswordError(e.toString()));
      }
    });

    on<ForgotPasswordRequested>((event, emit) async {
      emit(ForgotPasswordStarting());
      try {
        final response = await forgotPasswordUsecase(event.email);
        emit(ForgotPasswordSuccess(response['message'], response['email']));
      } catch (e) {
        emit(ForgotPasswordError(e.toString()));
      }
    });

    on<ResetPasswordRequested>((event, emit) async {
      emit(ResetPasswordStarting());
      try {
        final response = await resetPasswordUsecase(
          event.email,
          event.newPassword,
        );
        emit(ResetPasswordSuccess(response['message']));
      } catch (e) {
        emit(ResetPasswordError(e.toString()));
      }
    });

    on<UploadProfileImageRequested>((event, emit) async {
      emit(UploadingProfileImage());
      try {
        final response = await uploadProfilePicUsecase(event.imagePath);
        final message = response['message']?.toString() ?? 'Image uploaded';
        final url = response['url']?.toString() ?? '';

        if (url.isEmpty) throw Exception("Upload failed: URL missing");

        emit(UploadProfileImageSuccess(message, url));
      } catch (e) {
        emit(UploadProfileImageError(e.toString()));
      }
    });
  }
}
