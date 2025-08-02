import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/custom_container.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_bloc.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_events.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_state.dart';
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
              BlocBuilder<QuestionBloc, QuestionState>(
                builder: (context, state) {
                  if (state is QuestionLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is QuestionErrorState) {
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            state.message,
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.read<QuestionBloc>().add(
                                FetchQuizzesEvent(),
                              );
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is QuizzesFetchedState) {
                    if (state.quizzes.isEmpty) {
                      return Center(
                        child: Text(
                          'No quizzes available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.quizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = state.quizzes[index];
                          return CustomContainer(
                            titleText: quiz['title'],
                            subText: "${quiz['questions'].length} questions",
                            iconPath: quizDocumentImage,
                            showTrailingIcon: true,
                            onTap: () {
                              // Handle tap action
                              Navigator.pushNamed(context, '/quizDetail');
                            },
                            onMoreTap: () {
                              // Handle more action
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
