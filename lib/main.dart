import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/app_routes.dart';
import 'package:class_app/core/service/shared_pref/shared_pref.dart';
import 'package:class_app/core/utilities/dependency_injection.dart';
import 'package:class_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:class_app/features/auth/presentation/screens/login_screen.dart';
import 'package:class_app/features/base/base_screen.dart';
import 'package:class_app/features/onboarding/screens/onboarding_screen.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/audio/audio_bloc.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_bloc.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_bloc.dart';
import 'package:class_app/firebase_options.dart';
import 'package:class_app/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initCore();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Map<String, bool>> loadAppState() async {
    final isOnboarded = await sl<SharedPrefService>().isOnboarded();
    final isLoggedIn = await sl<SharedPrefService>().hasToken();
    return {'onboarded': isOnboarded, 'loggedIn': isLoggedIn};
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<AudioBloc>(create: (_) => sl<AudioBloc>()),
        BlocProvider<TranscriptBloc>(create: (_) => sl<TranscriptBloc>()),
        BlocProvider<QuestionBloc>(create: (_) => sl<QuestionBloc>()),
      ],
      child: MaterialApp(
        title: 'CLASS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(whiteColor),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(whiteColor),
            elevation: 0,
            iconTheme: IconThemeData(color: Color(blackColor)),
          ),
          fontFamily: "Poppins",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routes: appRoutes,
        home: FutureBuilder<Map<String, bool>>(
          future: loadAppState(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SplashScreen();
            }

            final data = snapshot.data ?? {};
            final isOnboarded = data['onboarded'] ?? false;
            final isLoggedIn = data['loggedIn'] ?? false;

            if (!isOnboarded) return const OnboardingScreen();
            if (!isLoggedIn) return const LoginScreen();
            return const BaseScreen();
          },
        ),
      ),
    );
  }
}
