import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/tutor/home/presentation/screens/home_screen.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/custom_container.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/assessment_screen.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_bloc.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_events.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_state.dart';
import 'package:class_app/features/tutor/quiz/presentation/screens/quiz_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuestionBloc>().add(FetchQuizzesEvent());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 2
                        : SizeConfig.blockSizeVertical! * 0.3,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    quizText,
                    style: TextStyle(
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.screenWidth! * 0.09
                              : SizeConfig.screenWidth! * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeVertical! * 1
                            : SizeConfig.blockSizeHorizontal! * 0.1,
                  ),

                  Text(
                    quizSubText,

                    style: TextStyle(
                      color: Color(blackColor),
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.screenWidth! * 0.04
                              : SizeConfig.screenWidth! * 0.025,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 2
                        : SizeConfig.blockSizeHorizontal! * 1,
              ),
              Expanded(
                child: BlocBuilder<QuestionBloc, QuestionState>(
                  builder: (context, state) {
                    if (state is FetchingQuizzesState) {
                      return LoadingWidget(loadingText: "Loading quizzes...");
                    } else if (state is FetchQuizzesErrorState) {
                      return CustomErrorWidget(
                        message: state.message,
                        onRetry: () {
                          context.read<QuestionBloc>().add(FetchQuizzesEvent());
                        },
                      );
                    } else if (state is QuizzesFetchedState) {
                      if (state.quizzes.isEmpty) {
                        return Center(
                          child: Text(
                            'No quizzes available\nQuizzes you create from your transcripts\nwill appear here.',
                            style: TextStyle(
                              color: Color(blackColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.quizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = state.quizzes[index];
                          return CustomContainer(
                            titleText: quiz.title,
                            subText: "${quiz.questions.length} questions",
                            iconPath: quizDocumentImage,
                            showTrailingIcon: true,
                            onTap: () {
                              // Handle tap action
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => QuizDetailScreen(quiz: quiz),
                                ),
                              );
                            },
                            onMoreButton: (context) {
                              return [
                                PopupMenuItem(
                                  value: 'password',
                                  child: Text('Password'),
                                ),
                              ];
                            },
                            onMoreTap: (value) async {
                              if (value == "password") {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      width: SizeConfig.screenWidth! * 0.8,
                                      height: SizeConfig.screenHeight! * 0.4,
                                      body: Column(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: "Your quiz password is ",
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.screenWidth! *
                                                    0.05,
                                                fontWeight: FontWeight.w400,
                                                color: Color(blackColor),
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: quiz.accessPassword,
                                                  style: TextStyle(
                                                    color: Color(blueColor),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: " and the Shared Id is",
                                                ),
                                                TextSpan(
                                                  text: quiz.sharedLinkId,
                                                  style: TextStyle(
                                                    color: Color(blueColor),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      leftButtonText: "Ok",
                                      showRightButton: false,
                                      screenWidth:
                                          SizeConfig.screenWidth! * 0.8,
                                      screenHeight:
                                          SizeConfig.screenHeight! * 0.4,
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

RelativeRect? relativeRectFromLTRB() {
  return RelativeRect.fromLTRB(
    SizeConfig.screenWidth! * 0.65,
    SizeConfig.screenHeight! * 0.34,
    SizeConfig.screenWidth! * 0.055,
    0,
  );
}
