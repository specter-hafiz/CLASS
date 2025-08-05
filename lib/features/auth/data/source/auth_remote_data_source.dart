import 'dart:convert';

import 'package:class_app/core/network/connectivity.dart';
import 'package:class_app/core/service/api/endpoints.dart';
import 'package:class_app/core/service/api/http_consumer.dart';
import 'package:class_app/core/service/api/status_code.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:class_app/core/service/shared_pref/shared_pref.dart';
import 'package:class_app/core/utilities/dependency_injection.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'package:logger/logger.dart';

final logger = Logger(level: Level.debug);

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  );

  /// Verifies the OTP token for the given email.

  Future<Map<String, dynamic>> verifyOTP(String email, String otp);
  Future<Map<String, dynamic>> editProfile(String username);
  Future<Map<String, dynamic>> loginWithGoogle(
    String username,
    String email,
    String googleId,
  );
  Future<Map<String, dynamic>> forgotPassword(String email);
  Future<Map<String, dynamic>> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  );
  Future<Map<String, dynamic>> resetPassword(String email, String newPassword);
  Future<Map<String, dynamic>> resendOTP(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpConsumer http;

  AuthRemoteDataSourceImpl(this.http);

  @override
  Future<UserModel> login(String email, String password) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    try {
      final res = await http.post(
        Endpoints.login,
        data: {'email': email, 'password': password},
      );
      final data = res.data is String ? jsonDecode(res.data) : res.data;
      final user = UserModel.fromJson(data['response']['user']);
      await SharedPrefService().saveToken(
        data['response']['user']['accessToken'],
      );
      await SharedPrefService().saveRefreshToken(
        data['response']['user']['refreshToken'],
      );
      await SharedPrefService().saveUser(user);
      return user;
    } on OTPVerificationException {
      rethrow; // ✅ This is fine – it will be caught in BLoC
    } catch (e) {
      logger.e("Login failed: $e");
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await http.post('/logout');
  }

  @override
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    final res = await http.post(
      Endpoints.signup,
      data: {'name': name, 'email': email, 'password': password},
    );
    if (res.statusCode != 201) {
      throw ServerException(res.data['message'] ?? 'Registration failed');
    }

    logger.i("Registration response: $res");
    return res.data;
  }

  @override
  Future<Map<String, dynamic>> verifyOTP(String email, String token) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    final res = await http.post(
      Endpoints.verifyOTP,
      token: token,
      data: {'email': email, 'otp': token},
    );
    if (res.statusCode != StatusCode.ok) {
      throw Exception('Failed to verify OTP');
    }
    final data = res.data is String ? jsonDecode(res.data) : res.data;

    debugPrint("Verify OTP response: $data");
    return data;
  }

  @override
  Future<Map<String, dynamic>> editProfile(String username) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    final token = await sl<SharedPrefService>().getToken().then(
      (value) => value ?? '',
    );

    final res = await http.patch(
      Endpoints.editProfile,
      data: {'name': username},
      token: token,
    );
    if (res.statusCode != StatusCode.ok) {
      throw ServerException(res.data['message'] ?? 'Failed to edit profile');
    }
    return res.data;
  }

  @override
  Future<Map<String, dynamic>> loginWithGoogle(
    String username,
    String email,
    String googleId,
  ) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    final res = await http.post(
      Endpoints.googleLogin,
      data: {'name': username, 'email': email, 'googleId': googleId},
    );
    if (res.statusCode != StatusCode.ok) {
      throw ServerException(
        res.data['message'] ?? 'Failed to login with Google',
      );
    }
    return res.data;
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    final res = await http.post(
      Endpoints.forgotPassword,
      data: {'email': email},
    );
    res.data is String ? jsonDecode(res.data) : res.data;
    if (res.statusCode != StatusCode.ok) {
      throw ServerException(res.data['message'] ?? 'Failed to send OTP');
    }
    logger.i("Forgot password response: ${res.data}");
    return res.data;
  }

  @override
  Future<Map<String, dynamic>> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    final token = await sl<SharedPrefService>().getToken().then(
      (value) => value ?? '',
    );
    final res = await http.post(
      Endpoints.changePassword,
      data: {
        'userId': userId,
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
      token: token,
    );
    if (res.statusCode != StatusCode.ok) {
      throw ServerException(res.data['message'] ?? 'Failed to change password');
    }
    return res.data;
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
    String email,
    String newPassword,
  ) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    final res = await http.post(
      Endpoints.resetPassword,
      data: {'email': email, 'newPassword': newPassword},
    );
    if (res.statusCode != StatusCode.ok) {
      throw ServerException(res.data['message'] ?? 'Failed to reset password');
    }
    return res.data;
  }

  @override
  Future<Map<String, dynamic>> resendOTP(String email) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    final res = await http.post(Endpoints.resendOTP, data: {'email': email});
    if (res.statusCode != StatusCode.ok) {
      throw ServerException(res.data['message'] ?? 'Failed to resend OTP');
    }
    return res.data;
  }
}
