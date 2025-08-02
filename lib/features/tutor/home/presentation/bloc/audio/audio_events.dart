import 'package:equatable/equatable.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();
  @override
  List<Object?> get props => [];
}

class UploadAudioRequested extends AudioEvent {
  final String filePath;

  const UploadAudioRequested(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class TranscribeAudioRequested extends AudioEvent {
  final String audioUrl;

  const TranscribeAudioRequested(this.audioUrl);

  @override
  List<Object?> get props => [audioUrl];
}

class FetchAudioFilesRequested extends AudioEvent {}

class DeleteAudioFileRequested extends AudioEvent {
  final String fileName;

  const DeleteAudioFileRequested(this.fileName);

  @override
  List<Object?> get props => [fileName];
}

class UploadAudioAndGenerateQuizRequested extends AudioEvent {
  final String filePath;
  final String title;
  final DateTime expiresAt;
  final String duration;
  final String accessPassword;

  const UploadAudioAndGenerateQuizRequested(
    this.filePath,
    this.title,
    this.expiresAt,
    this.duration,
    this.accessPassword,
  );
  @override
  List<Object?> get props => [
    filePath,
    title,
    expiresAt,
    duration,
    accessPassword,
  ];
}
