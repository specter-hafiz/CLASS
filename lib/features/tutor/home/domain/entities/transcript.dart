import 'package:equatable/equatable.dart';

class Transcript extends Equatable {
  final String id;
  final String userId;
  final String audioFileName;
  final String content;
  final DateTime createdAt;

  const Transcript({
    required this.userId,
    required this.audioFileName,
    required this.id,
    required this.content,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, userId, audioFileName, content, createdAt];
}
