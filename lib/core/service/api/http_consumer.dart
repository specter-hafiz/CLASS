import 'dart:convert';

import 'package:class_app/core/constants/app_secrets.dart';
import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:dio/dio.dart';

class HttpConsumer {
  final Dio _dio;

  HttpConsumer(this._dio) {
    _dio.options.baseUrl = AppSecrets.baseUrl; // change this
    _dio.options.connectTimeout = const Duration(seconds: 20);
    _dio.options.receiveTimeout = const Duration(seconds: 20);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      _handleError(e);
    }
    throw ServerException("Unexpected error in GET");
  }

  Future<Response> patch(
    String path, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
    } on DioException catch (e) {
      _handleError(e);
    }
    throw ServerException("Unexpected error occurred.");
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
    } on DioException catch (e) {
      _handleError(e);
    }
    throw ServerException("Unexpected error in DELETE");
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
    } on DioException catch (e) {
      _handleError(e);
    }
    throw ServerException("Unexpected error in POST");
  }

  void _handleError(DioException e) {
    final response = e.response;

    late Map<String, dynamic> data;

    try {
      // Always convert to a Map<String, dynamic>
      if (response?.data is String) {
        data = jsonDecode(response!.data);
      } else if (response?.data is Map) {
        // Re-encode and decode to normalize the structure
        data = jsonDecode(jsonEncode(response!.data));
      } else {
        throw ServerException("Unexpected error format");
      }
    } catch (err) {
      throw ServerException("Failed to parse response");
    }

    final message = data['message']?.toString();
    // ✅ Special handling for 403: unverified users

    if (response.statusCode == 399) {
      throw OTPVerificationException(message ?? "OTP verification required.");
    }

    if (message == "Validation error") {
      final errors = data['errors'] as List?;
      if (errors != null && errors.isNotEmpty) {
        final first = errors.first;
        final errorMessage = first['message'] ?? 'Unknown validation error';
        throw ServerException(errorMessage);
      } else {
        throw ServerException("Validation error occurred.");
      }
    }

    throw ServerException(message ?? 'An error occurred: ${e.message}');
  }
}
