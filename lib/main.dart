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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures bindings are ready
  await initCore();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
        BlocProvider<AudioBloc>(create: (context) => sl<AudioBloc>()),
        BlocProvider<TranscriptBloc>(create: (context) => sl<TranscriptBloc>()),
        BlocProvider<QuestionBloc>(create: (context) => sl<QuestionBloc>()),
      ],
      child: MaterialApp(
        title: 'CLASS',
        theme: ThemeData(
          scaffoldBackgroundColor: Color(whiteColor),
          appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.transparent,

            backgroundColor: Color(whiteColor),
            elevation: 0,
            iconTheme: IconThemeData(color: Color(blackColor)),
          ),
          popupMenuTheme: PopupMenuThemeData(color: Color(whiteColor)),
          fontFamily: "Poppins",
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontWeight: FontWeight.w400),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Builder(
          builder: (context) {
            Future<bool> isOnboarded = sl<SharedPrefService>().isOnboarded();
            Future<bool> isLoggedIn = sl<SharedPrefService>().hasToken();
            return FutureBuilder<bool>(
              future: isOnboarded,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || !snapshot.data!) {
                  return const OnboardingScreen();
                } else {
                  return FutureBuilder<bool>(
                    future: isLoggedIn,
                    builder: (context, loginSnapshot) {
                      if (loginSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (loginSnapshot.hasError ||
                          !(loginSnapshot.data ?? false)) {
                        return const LoginScreen();
                      } else {
                        return const BaseScreen();
                      }
                    },
                  );
                }
              },
            );
          },
        ),
        routes: appRoutes,
      ),
    );
  }
}
