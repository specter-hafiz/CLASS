import 'package:class_app/core/service/audio_service.dart';
import 'package:class_app/core/service/questions_service.dart';
import 'package:class_app/core/service/trancript_service.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:class_app/features/auth/data/source/auth_remote_data_source.dart';
import 'package:class_app/features/auth/domain/repository/auth_repository.dart';
import 'package:class_app/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/edit_profile_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/upload_profile_pic_usecase.dart';
import 'package:class_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/tutor/home/data/repository/audio_repo_impl.dart';
import 'package:class_app/features/tutor/home/data/repository/transcript_repo_impl.dart';
import 'package:class_app/features/tutor/home/data/source/audio_remote_data_source.dart';
import 'package:class_app/features/tutor/home/data/source/transcript_data_source.dart';
import 'package:class_app/features/tutor/home/domain/repository/audio_repo.dart';
import 'package:class_app/features/tutor/home/domain/repository/transcript_repository.dart';
import 'package:class_app/features/tutor/home/domain/usecases/delete_transcript_usecase.dart';
import 'package:class_app/features/tutor/home/domain/usecases/fetch_transcript_usecase.dart';
import 'package:class_app/features/tutor/home/domain/usecases/fetch_transcripts_usecase.dart';
import 'package:class_app/features/tutor/home/domain/usecases/transcribe_audio_usecase.dart';
import 'package:class_app/features/tutor/home/domain/usecases/update_transcript_usecase.dart';
import 'package:class_app/features/tutor/home/domain/usecases/upload_audio_usecase.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/audio/audio_bloc.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_bloc.dart';
import 'package:class_app/features/tutor/quiz/data/repository/questions_repo_impl.dart';
import 'package:class_app/features/tutor/quiz/data/source/questions_remote_data_source.dart';
import 'package:class_app/features/tutor/quiz/domain/repository/questions_repository.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/fetch_quizzes_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/fetch_submitted_responses.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/generate_questions_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/get_analytics_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/get_quiz_analytics_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/get_quiz_results_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/get_shared_questions_usecase.dart';
import 'package:class_app/features/tutor/quiz/domain/usecase/submit_assessment_usecase.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../network/connectivity.dart';
import '../service/api/http_consumer.dart';
import '../service/shared_pref/shared_pref.dart';

final sl = GetIt.instance; // sl = service locator

/// Registers all core services and dependencies
Future<void> initCore() async {
  // core
  sl.registerLazySingleton(() => SharedPrefService());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => HttpConsumer(sl()));
  sl.registerLazySingleton(() => AudioTranscriptionService(sl()));
  sl.registerLazySingleton(() => TrancriptService(sl()));
  sl.registerLazySingleton(() => QuestionsService(sl()));

  sl.registerLazySingleton(() => NetworkConnectivity());
  sl.registerLazySingleton(() => SizeConfig());

  //! Features - Auth

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
      sl(),
    ),
  );
  sl.registerFactory(() => AudioBloc(sl(), sl()));
  sl.registerFactory(() => TranscriptBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(
    () => QuestionBloc(
      sl<FetchQuizzesUsecase>(),
      sl<GetSharedQuestionsUsecase>(),
      sl<SubmitAssessmentUsecase>(),
      sl<GenerateQuestionsUsecase>(),
      sl<FetchSubmittedResponsesUsecase>(),
      sl<GetAnalyticsUsecase>(),
      sl<GetQuizAnalyticsUsecase>(),
      sl<GetQuizResultsUsecase>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => TranscribeAudioUseCase(sl()));
  sl.registerLazySingleton(() => UploadAudioUseCase(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignupUsecase(sl()));
  sl.registerLazySingleton(() => GoogleLoginUsecase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUsecase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUsecase(sl()));
  sl.registerLazySingleton(() => EditProfileUsecase(sl()));
  sl.registerLazySingleton(() => ResendOtpUsecase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));
  sl.registerLazySingleton(() => VerifytokenUsecase(sl()));
  sl.registerLazySingleton(() => FetchTranscriptsUsecase(sl()));
  sl.registerLazySingleton(() => FetchTranscriptUsecase(sl()));
  sl.registerLazySingleton(() => UpdateTranscriptUsecase(sl()));
  sl.registerLazySingleton(() => DeleteTranscriptUsecase(sl()));
  sl.registerLazySingleton(() => FetchQuizzesUsecase(sl()));
  sl.registerLazySingleton(() => GetSharedQuestionsUsecase(sl()));
  sl.registerLazySingleton(() => SubmitAssessmentUsecase(sl()));
  sl.registerLazySingleton(() => GenerateQuestionsUsecase(sl()));
  sl.registerLazySingleton(() => FetchSubmittedResponsesUsecase(sl()));
  sl.registerLazySingleton(() => GetAnalyticsUsecase(sl()));
  sl.registerLazySingleton(() => GetQuizAnalyticsUsecase(sl()));
  sl.registerLazySingleton(() => GetQuizResultsUsecase(sl()));
  sl.registerLazySingleton(() => UploadProfilePicUsecase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AudioRepository>(() => AudioRepoImpl(sl()));
  sl.registerLazySingleton<TranscriptRepository>(
    () => TranscriptRepoImpl(sl()),
  );
  sl.registerLazySingleton<QuestionsRepository>(() => QuestionsRepoImpl(sl()));

  // Data Source

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AudioRemoteDataSource>(
    () => AudioRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<TranscriptRemoteDataSource>(
    () => TranscriptRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<QuestionsRemoteDataSource>(
    () => QuestionsRemoteDataSourceImpl(sl()),
  );
}
