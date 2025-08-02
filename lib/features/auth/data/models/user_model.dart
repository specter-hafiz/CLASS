import 'package:class_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isVerified;
  final String accessToken;
  final String refreshToken;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isVerified,
    required this.accessToken,
    required this.refreshToken,
  }) : super(
         role: role,
         isVerified: isVerified,
         id: id,
         email: email,
         name: name,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'] ?? 'user',
      isVerified: json['isVerified'] ?? false,
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'isVerified': isVerified,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
