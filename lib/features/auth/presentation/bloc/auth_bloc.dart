import 'package:bloc/bloc.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:class_app/features/auth/data/source/auth_remote_data_source.dart';
import 'package:class_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/verify_token_usecase.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUsecase logoutUseCase;
  final SignupUsecase registerUseCase;
  final VerifytokenUsecase verifyTokenUsecase;

  AuthBloc(
    this.loginUseCase,
    this.logoutUseCase,
    this.registerUseCase,
    this.verifyTokenUsecase,
  ) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase(event.email, event.password);
        emit(AuthAuthenticated(user));
        debugPrint("Login successful: ${user.email}");
      } on NetworkException catch (e) {
        logger.e(e.message);
        emit(AuthError(e.message));
      } on OTPVerificationException {
        logger.i("OTPVerificationException caught in BLoC");
        emit(RequireOtpVerification());
      } catch (e, stackTrace) {
        logger.e('Login failed', error: e, stackTrace: stackTrace);
        emit(AuthError("Login problem: ${e.toString()}"));
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
        final response = await verifyTokenUsecase(event.email, event.otp);
        debugPrint("Token verification response: $response");
        emit(TokenVerified(response['msg']));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
