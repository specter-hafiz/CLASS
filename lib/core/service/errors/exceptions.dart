class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  @override
  String toString() => message;
}

class OTPVerificationException implements Exception {
  final String message;

  OTPVerificationException(this.message);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = "No internet connection"]);

  @override
  String toString() => message;
}

class CustomTimeoutException implements Exception {
  final String message;
  CustomTimeoutException(this.message);

  @override
  String toString() => message;
}
