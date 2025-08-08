import 'package:class_app/core/service/errors/exceptions.dart';
import 'package:class_app/features/tutor/home/domain/usecases/delete_transcript_usecase.dart';
import 'package:class_app/features/tutor/home/domain/usecases/fetch_transcript_usecase.dart';
import 'package:class_app/features/tutor/home/domain/usecases/fetch_transcripts_usecase.dart';
import 'package:class_app/features/tutor/home/domain/usecases/update_transcript_usecase.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_events.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TranscriptBloc extends Bloc<TranscriptEvents, TranscriptState> {
  final FetchTranscriptsUsecase fetchTranscriptsUsecase;
  final FetchTranscriptUsecase fetchTranscriptUsecase;
  final UpdateTranscriptUsecase updateTranscriptUsecase;
  final DeleteTranscriptUsecase deleteTranscriptUsecase;

  TranscriptBloc(
    this.fetchTranscriptsUsecase,
    this.fetchTranscriptUsecase,
    this.updateTranscriptUsecase,
    this.deleteTranscriptUsecase,
  ) : super(TranscriptInitial()) {
    on<FetchTranscriptsRequested>((event, emit) async {
      emit(FetchingTranscripts());
      try {
        final transcripts = await fetchTranscriptsUsecase();
        emit(TranscriptsFetched(transcripts));
      } on CustomTimeoutException catch (e) {
        emit(TranscriptError(e.toString()));
      } catch (e) {
        emit(TranscriptError(e.toString()));
      }
    });

    on<FetchTranscriptRequested>((event, emit) async {
      emit(TranscriptLoading());
      try {
        final transcript = await fetchTranscriptUsecase(
          transcriptId: event.transcriptId,
        );
        emit(TranscriptFetched(transcript));
      } catch (e) {
        emit(TranscriptError(e.toString()));
      }
    });

    on<UpdateTranscriptRequested>((event, emit) async {
      emit(TranscriptLoading()); // Optional: Show loading UI
      try {
        final updatedTranscript = await updateTranscriptUsecase(
          transcriptId: event.transcriptId,
          content: event.content,
        );
        emit(TranscriptUpdated(updatedTranscript));
      } catch (e) {
        emit(TranscriptError(e.toString()));
      }
    });
    on<DeleteTranscriptRequested>((event, emit) async {
      emit(DeletingTranscript());
      try {
        await deleteTranscriptUsecase(event.transcriptId);
        final currentState = state;
        if (currentState is TranscriptsFetched) {
          final updatedTranscripts =
              currentState.transcripts
                  .where((transcript) => transcript.id != event.transcriptId)
                  .toList();
          emit(TranscriptsFetched(updatedTranscripts));
        } else {
          // If current state is not TranscriptsFetched, just refetch all
          final transcripts = await fetchTranscriptsUsecase();
          emit(TranscriptsFetched(transcripts));
        }
      } catch (e) {
        emit(DeleteTranscriptError(e.toString()));
      }
    });
  }
}
