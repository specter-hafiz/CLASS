import 'dart:convert';

import 'package:class_app/core/network/connectivity.dart';
import 'package:class_app/core/service/api/endpoints.dart';
import 'package:class_app/core/service/api/http_consumer.dart';
import 'package:class_app/core/service/api/status_code.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:class_app/core/service/shared_pref/shared_pref.dart';
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

  Future<Map<String, dynamic>> verifyToken(String email, String otp);
  Future<Map<String, dynamic>> editProfile(String username);
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
      logger.i("Sending login request...");
      final res = await http.post(
        Endpoints.login,
        data: {'email': email, 'password': password},
      );
      final data = res.data is String ? jsonDecode(res.data) : res.data;
      final user = UserModel.fromJson(data['response']['user']);
      print("User data: ${user.toJson()}");
      await SharedPrefService().saveToken(
        data['response']['user']['accessToken'],
      );
      await SharedPrefService().saveRefreshToken(
        data['response']['user']['refreshToken'],
      );
      await SharedPrefService().saveUser(user);
      logger.i("Login response: $data");
      logger.i("User logged in: ${user.email}");
      return user;
    } on OTPVerificationException {
      rethrow; // ✅ This is fine – it will be caught in BLoC
    } catch (e) {
      logger.e("Login failed: $e");
      throw ServerException("An unexpected error occurred.");
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
  Future<Map<String, dynamic>> verifyToken(String email, String token) async {
    final res = await http.post(
      Endpoints.verifyOTP,
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
    final res = await http.patch(
      Endpoints.editProfile,
      data: {'name': username},
    );
    if (res.statusCode != StatusCode.ok) {
      throw ServerException(res.data['message'] ?? 'Failed to edit profile');
    }
    return res.data;
  }
}
