import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/tutor/analytics/presentation/screens/analytics_screen.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/audio/audio_bloc.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/audio/audio_state.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_bloc.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_events.dart';
import 'package:class_app/features/tutor/home/presentation/screens/animated_process_screen.dart';
import 'package:class_app/features/tutor/home/presentation/screens/home_screen.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/recording_bottom_sheet.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/profile_screen.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_bloc.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_events.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_state.dart';
import 'package:class_app/features/tutor/quiz/presentation/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [HomeScreen(), QuizScreen(), AnalyticsScreen(), ProfileScreen()];
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return PopScope(
      canPop: (ModalRoute.of(context)?.isCurrent != true) ? false : true,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AudioBloc, AudioState>(
            listener: (context, state) {
              if (state is AudioUploading) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder:
                      (_) => PopScope(
                        canPop: false,
                        child: const AnimatedProcessScreen(
                          animationPath: 'assets/animations/uploading.json',
                          message: 'Uploading audio...',
                        ),
                      ),
                );
              } else if (state is AudioTranscribing) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder:
                      (_) => PopScope(
                        canPop: false,
                        child: const AnimatedProcessScreen(
                          animationPath: 'assets/animations/transcribing.json',
                          message: 'Transcribing audio...',
                        ),
                      ),
                );
              } else if (state is AudioTranscribed) {
                Navigator.of(context).pop(); // Close transcription dialog
                context.read<TranscriptBloc>().add(FetchTranscriptsRequested());
                setState(() {
                  _currentIndex = 0; // Reset to HomeScreen
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Transcription ${state.success ? 'succeeded' : 'failed'}",
                    ),
                  ),
                );
              } else if (state is GenerateQuestionsEvent) {
                context.read<QuestionBloc>().add(
                  GenerateQuestionsEventRequest(
                    transcript: state.transcript,
                    numberOfQuestions: state.numberOfQuestions,
                    title: state.title,
                    expiresAt: state.expiresAt,
                    duration: state.duration,
                    accessPassword: state.accessPassword,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Quiz generation started")),
                );
              } else if (state is AudioUploaded) {
                if (!mounted) return;
                Navigator.of(context).pop(); // Close upload dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Audio uploaded successfully")),
                );
              } else if (state is AudioError) {
                if (!mounted) return;
                Navigator.of(context).pop(); // Close any open dialog
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<QuestionBloc, QuestionState>(
            listener: (context, state) {
              if (state is GeneratingQuizzesState) {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder:
                      (_) => PopScope(
                        canPop: false,
                        child: const AnimatedProcessScreen(
                          animationPath: 'assets/animations/loading.json',
                          message: 'Generating quiz questions...',
                        ),
                      ),
                );
              } else if (state is QuestionsGeneratedCompletedState) {
                if (!mounted) return;
                Navigator.of(context).pop(); // Close loading dialog
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder:
                      (_) => PopScope(
                        canPop: false,
                        child: AnimatedProcessScreen(
                          animationPath: 'assets/animations/success.json',
                          message: 'Generating Generated Successfully',
                        ),
                      ),
                );
                Navigator.of(context).pop(); // Close success dialog
                setState(() {
                  _currentIndex = 1; // Switch to QuizScreen
                });
              } else if (state is QuestionErrorState) {
                if (!mounted) return;
                Navigator.of(context).pop(); // Close any open dialog
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is QuestionErrorState) {
                if (!mounted) return;
                Navigator.of(context).pop(); // Close any open dialog
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: Scaffold(
          floatingActionButton: Container(
            margin: EdgeInsets.only(
              bottom: SizeConfig.blockSizeVertical! * 1.5,
            ),
            decoration: BoxDecoration(
              color: Color(greyColor).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(
                SizeConfig.blockSizeHorizontal! * 10,
              ),
            ),
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal! * 1),
            child: FloatingActionButton(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  SizeConfig.blockSizeHorizontal! * 10,
                ),
              ),
              onPressed: () async {
                var isPortrait =
                    SizeConfig.orientation(context) == Orientation.portrait;
                // Add your floating action button action here
                await showModalBottomSheet(
                  constraints: BoxConstraints(
                    maxHeight:
                        isPortrait
                            ? SizeConfig.screenHeight! * 0.7
                            : SizeConfig.screenHeight! * 0.95,
                  ),
                  showDragHandle: true,
                  isDismissible: false,
                  backgroundColor: Color(whiteColor),
                  context: context,
                  builder: (context) {
                    return RecordingBottomSheet(isPortrait: isPortrait);
                  },
                );
              },
              backgroundColor: Color(blueColor),
              child: SvgPicture.asset(
                "assets/svgs/mic.svg",
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.height * 0.045,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: _pages[_currentIndex],

          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Color(whiteColor),
            enableFeedback: false,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            unselectedItemColor: Color(greyColor),
            selectedItemColor: Color(blueColor),
            currentIndex: _currentIndex,

            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  homeImage,
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 0 ? Color(blueColor) : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  quizImage,
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 1 ? Color(blueColor) : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Quiz',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  analyticsImage,
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 2 ? Color(blueColor) : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Analytics',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  profileImage,
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 3 ? Color(blueColor) : Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
