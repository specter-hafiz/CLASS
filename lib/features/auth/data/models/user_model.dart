// ignore_for_file: overridden_fields

import 'package:class_app/features/auth/domain/entities/user.dart';

class UserModel extends User {
  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String role;
  @override
  final bool isVerified;
  final String accessToken;
  final String refreshToken;
  final String imageUrl;

  const UserModel(
    this.imageUrl, {
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
      json['profileUrl'] ?? '',
      id: json['_id'],
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      role: json['role'] ?? 'user',
      isVerified: json['isVerified'] ?? false,
      accessToken: json['accessToken'] ?? "",
      refreshToken: json['refreshToken'] ?? "",
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
      'profileUrl': imageUrl,
    };
  }

  UserModel copyWith({
    String? imageUrl,
    String? id,
    String? name,
    String? email,
    String? role,
    bool? isVerified,
    String? accessToken,
    String? refreshToken,
  }) {
    return UserModel(
      imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
