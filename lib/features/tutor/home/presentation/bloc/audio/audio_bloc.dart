import 'package:class_app/features/tutor/home/domain/usecases/transcribe_audio_usecase.dart';
import 'package:class_app/features/tutor/home/domain/usecases/upload_audio_usecase.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/audio/audio_events.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/audio/audio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final TranscribeAudioUseCase transcribeAudioUseCase;
  final UploadAudioUseCase uploadAudioUseCase;

  AudioBloc(this.transcribeAudioUseCase, this.uploadAudioUseCase)
    : super(AudioInitial()) {
    on<UploadAudioRequested>((event, emit) async {
      emit(AudioUploading());
      try {
        final response = await uploadAudioUseCase(event.filePath);
        emit(AudioUploaded(response['url']));
        emit(AudioTranscribing());
        final transcriptionResult = await transcribeAudioUseCase(
          response['url'],
        );
        emit(
          AudioTranscribed(
            transcriptionResult['transcript'],
            transcriptionResult['success'],
          ),
        );
      } catch (e) {
        emit(AudioError("Failed to upload audio: ${e.toString()}"));
      }
    });

    on<UploadAudioAndGenerateQuizRequested>((event, emit) async {
      emit(AudioUploading());
      try {
        final response = await uploadAudioUseCase(event.filePath);
        emit(AudioUploaded(response['url']));
        emit(AudioTranscribing());
        final transcriptionResult = await transcribeAudioUseCase(
          response['url'],
        );
        emit(
          AudioTranscribed(
            transcriptionResult['transcript'],
            transcriptionResult['success'],
          ),
        );
        // Trigger quiz generation based on the transcription result
        emit(
          GenerateQuestionsEvent(
            transcript: transcriptionResult['transcript'],
            title: event.title,
            expiresAt: event.expiresAt,
            duration: event.duration,
            accessPassword: event.accessPassword,
          ),
        );
      } catch (e) {
        emit(
          AudioError("Failed to upload and transcribe audio: ${e.toString()}"),
        );
      }
    });

    on<TranscribeAudioRequested>((event, emit) async {
      emit(AudioTranscribing());
      try {
        final transcriptionResult = await transcribeAudioUseCase(
          event.audioUrl,
        );
        emit(
          AudioTranscribed(
            transcriptionResult['transcript'],
            transcriptionResult['success'],
          ),
        );
      } catch (e) {
        emit(AudioError("Failed to transcribe audio: ${e.toString()}"));
      }
    });

    on<FetchAudioFilesRequested>((event, emit) async {
      // Implement fetching audio files logic here
    });

    on<DeleteAudioFileRequested>((event, emit) async {
      // Implement deleting audio file logic here
    });
  }
}
