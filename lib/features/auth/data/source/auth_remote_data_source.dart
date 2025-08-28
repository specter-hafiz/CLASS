import 'dart:convert';

import 'package:class_app/core/constants/app_secrets.dart';
import 'package:class_app/core/network/connectivity.dart';
import 'package:class_app/core/service/api/endpoints.dart';
import 'package:class_app/core/service/api/http_consumer.dart';
import 'package:class_app/core/service/api/status_code.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:class_app/core/service/shared_pref/shared_pref.dart';
import 'package:class_app/core/utilities/dependency_injection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  );

  /// Verifies the OTP token for the given email.

  Future<Map<String, dynamic>> verifyOTP(
    String email,
    String otp,
    bool? isLoginSignUp,
  );
  Future<Map<String, dynamic>> editProfile(String username);
  Future<Map<String, dynamic>> loginWithGoogle(String googleId);
  Future<Map<String, dynamic>> forgotPassword(String email);
  Future<Map<String, dynamic>> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  );
  Future<Map<String, dynamic>> resetPassword(String email, String newPassword);
  Future<Map<String, dynamic>> resendOTP(String email);
  Future<Map<String, dynamic>> uploadProfileImage(String imagePath);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpConsumer http;
  final Dio _dio;

  AuthRemoteDataSourceImpl(this.http) : _dio = Dio() {
    _dio.options.baseUrl = AppSecrets.baseUrl; // change this
    _dio.options.sendTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
  }

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

    return res.data;
  }

  @override
  Future<Map<String, dynamic>> verifyOTP(
    String email,
    String token,
    bool? isLoginSignUp,
  ) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    print("AuthRemote Data Source  Email: $email");
    final res = await http.post(
      Endpoints.verifyOTP,
      token: token,
      data: {'email': email, 'otp': token},
    );
    if (res.statusCode != StatusCode.ok) {
      throw Exception('Failed to verify OTP');
    }
    final data = res.data is String ? jsonDecode(res.data) : res.data;
    print("Data from remote data source: $data");
    if (isLoginSignUp == true) {
      final user = UserModel.fromJson(data['results']['user']);
      await SharedPrefService().saveToken(data['results']['accessToken']);
      await SharedPrefService().saveRefreshToken(
        data['results']['refreshToken'],
      );
      await SharedPrefService().saveUser(user);
    }
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
  Future<Map<String, dynamic>> loginWithGoogle(String googleId) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    final res = await http.post(
      Endpoints.googleLogin,
      data: {'token': googleId},
    );
    final data = res.data is String ? jsonDecode(res.data) : res.data;
    final user = UserModel.fromJson(data['user']);
    await SharedPrefService().saveToken(data['user']['accessToken']);
    await SharedPrefService().saveRefreshToken(data['user']['refreshToken']);
    await SharedPrefService().saveUser(user);
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

  @override
  Future<Map<String, dynamic>> uploadProfileImage(String imagePath) async {
    bool hasConnection = await NetworkConnectivity().isConnected;
    if (!hasConnection) {
      throw NetworkException("No internet connection");
    }
    final token = await sl<SharedPrefService>().getToken().then(
      (value) => value ?? '',
    );
    final userId = await sl<SharedPrefService>().getUser().then(
      (value) => value?.id ?? '',
    );
    final res = await _dio.post(
      Endpoints.uploadProfileImage,
      data: FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
          contentType: MediaType('image', 'jpeg'),
        ),
        'userId': userId,
      }),
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        },
        receiveTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(minutes: 20),
      ),
    );
    if (res.statusCode != StatusCode.ok) {
      throw ServerException(
        res.data['message'] ?? 'Failed to upload profile image',
      );
    }
    final currentUser = await sl<SharedPrefService>().getUser();
    final user = currentUser?.copyWith(imageUrl: res.data['url'].toString());
    await sl<SharedPrefService>().saveUser(user!);

    return {
      'message': res.data['message'] ?? 'Image uploaded successfully',
      'url': res.data['url'].toString(),
    };
  }
}
