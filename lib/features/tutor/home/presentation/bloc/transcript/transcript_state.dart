import 'package:class_app/features/tutor/home/data/models/transcript_model.dart';
import 'package:equatable/equatable.dart';

class TranscriptState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TranscriptInitial extends TranscriptState {}

class TranscriptLoading extends TranscriptState {}

class FetchingTranscripts extends TranscriptState {}

class TranscriptLoaded extends TranscriptState {
  final List<Transcript> transcripts;

  TranscriptLoaded(this.transcripts);

  @override
  List<Object?> get props => [transcripts];
}

class TranscriptsFetched extends TranscriptState {
  final List<Transcript> transcripts;

  TranscriptsFetched(this.transcripts);

  @override
  List<Object?> get props => [transcripts];
}

class TranscriptFetched extends TranscriptState {
  final Transcript transcript;

  TranscriptFetched(this.transcript);

  @override
  List<Object?> get props => [transcript];
}

class TranscriptUpdated extends TranscriptState {
  final Transcript updatedTranscript;

  TranscriptUpdated(this.updatedTranscript);

  @override
  List<Object?> get props => [updatedTranscript];
}

class TranscriptError extends TranscriptState {
  final String message;

  TranscriptError(this.message);

  @override
  List<Object?> get props => [message];
}
