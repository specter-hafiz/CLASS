import 'package:equatable/equatable.dart';

class TranscriptEvents extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTranscriptsRequested extends TranscriptEvents {}

class FetchTranscriptRequested extends TranscriptEvents {
  final String transcriptId;

  FetchTranscriptRequested(this.transcriptId);

  @override
  List<Object?> get props => [transcriptId];
}

class UpdateTranscriptRequested extends TranscriptEvents {
  final String transcriptId;
  final String content;

  UpdateTranscriptRequested({
    required this.transcriptId,
    required this.content,
  });

  @override
  List<Object?> get props => [transcriptId, content];
}

class DeleteTranscriptRequested extends TranscriptEvents {
  final String transcriptId;

  DeleteTranscriptRequested(this.transcriptId);
  @override
  List<Object?> get props => [transcriptId];
}
