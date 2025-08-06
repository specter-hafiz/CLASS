import 'package:equatable/equatable.dart';

abstract class AudioState extends Equatable {
  const AudioState();
  @override
  List<Object?> get props => [];
}

class AudioInitial extends AudioState {}

class AudioUploading extends AudioState {}

class AudioUploaded extends AudioState {
  final String audioUrl;

  const AudioUploaded(this.audioUrl);

  @override
  List<Object?> get props => [audioUrl];
}

class AudioTranscribing extends AudioState {}

class AudioTranscribed extends AudioState {
  final String transcript;
  final bool success;

  const AudioTranscribed(this.transcript, this.success);

  @override
  List<Object?> get props => [transcript, success];
}

class AudioError extends AudioState {
  final String message;

  const AudioError(this.message);

  @override
  List<Object?> get props => [message];
}

class GenerateQuestionsEvent extends AudioState {
  final String transcript;
  final String title;
  final int numberOfQuestions;
  final DateTime expiresAt;
  final String duration;
  final String accessPassword;

  const GenerateQuestionsEvent({
    required this.numberOfQuestions,
    required this.transcript,
    required this.title,
    required this.expiresAt,
    required this.duration,
    required this.accessPassword,
  });

  @override
  List<Object?> get props => [
    transcript,
    title,
    expiresAt,
    duration,
    accessPassword,
  ];
}
