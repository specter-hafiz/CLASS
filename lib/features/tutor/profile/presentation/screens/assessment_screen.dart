import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_textfield.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/home/presentation/screens/animated_process_screen.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/custom_container.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/answer_quiz_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/quiz_review_screen.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_bloc.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_events.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  @override
  initState() {
    super.initState();
    // Fetch submitted responses when the screen is initialized
    context.read<QuestionBloc>().add(FetchSubmittedResponsesEvent());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<QuestionBloc, QuestionState>(
      listener: (context, state) {
        if (state is QuestionLoadingState) {
          // Show loading indicator
          showDialog(
            barrierDismissible: false,
            context: context,
            builder:
                (_) => const AnimatedProcessScreen(
                  animationPath: 'assets/animations/loading.json',
                  message: 'Fetching questions...',
                ),
          );
        } else if (state is QuestionSharedState) {
          // Hide loading indicator
          Navigator.pop(context);
          // Navigate to answer quiz screen with shared questions
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AnswerQuizScreen(
                    sharedQuestions: state.sharedQuestions,
                    duration: state.duration,
                    startedAt: state.startedAt,
                    sharedLinkId: state.sharedLinkId,
                    id: state.id,
                  ),
            ),
          );
        } else if (state is QuestionErrorState) {
          // Hide loading indicator
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: CustomBackButton(),
            title: Text(
              assessmentText,
              style: TextStyle(
                fontSize:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeHorizontal! * 6
                        : SizeConfig.blockSizeVertical! * 7,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
            ),
          ),
          body: Padding(
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
                          : SizeConfig.blockSizeHorizontal! * 2,
                ),
                CustomElevatedButton(
                  iconPath: newAssessmentImage,
                  showIcon: true,
                  buttonText: newAssessmentText,
                  onPressed: () async {
                    // show dialog
                    final results = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        final screenHeight = MediaQuery.of(context).size.height;
                        final screenWidth = MediaQuery.of(context).size.width;

                        return CustomAlertDialog(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                        );
                      },
                    );

                    if (results != null) {
                      context.read<QuestionBloc>().add(
                        GetSharedQuestionsEvent(
                          results['id'] ?? '',
                          results['sharedId'] ?? '',
                          results['accessPassword'] ?? '',
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 2
                          : SizeConfig.blockSizeHorizontal! * 2,
                ),
                Text(
                  previusAssessmentText,
                  style: TextStyle(
                    fontSize:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeHorizontal! * 5
                            : SizeConfig.blockSizeVertical! * 6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 2
                          : SizeConfig.blockSizeHorizontal! * 2,
                ),
                Expanded(
                  child: BlocBuilder<QuestionBloc, QuestionState>(
                    builder: (context, state) {
                      if (state is FetchingResponsesState) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is FetchedSubmittedResponsesState) {
                        return ListView.builder(
                          itemCount: state.responses.length,
                          itemBuilder: (context, index) {
                            return CustomContainer(
                              iconPath: quizImage,
                              titleText: state.responses[index].title,
                              subText: "89/100",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => QuizReviewScreen(
                                          questions:
                                              state.responses[index].questions,
                                          response:
                                              state.responses[index].response,
                                        ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else if (state is QuestionErrorState) {
                        return Center(
                          child: Text(
                            state.message,
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            'No assessments available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    this.leftButtonText,
    this.rightButtonText,
    this.onLeftButtonPressed,
    this.onRightButtonPressed,
    this.width,
    this.height,
    this.body,
  });

  final double screenWidth;
  final double screenHeight;
  final String? leftButtonText;
  final String? rightButtonText;
  final void Function()? onLeftButtonPressed;

  final void Function()? onRightButtonPressed;
  final double? width;
  final double? height;
  final Column? body;

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  TextEditingController idController = TextEditingController();
  TextEditingController accessPasswordController = TextEditingController();
  TextEditingController sharedIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      backgroundColor: Color(whiteColor),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      contentPadding: const EdgeInsets.all(16),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              widget.height ??
              (SizeConfig.orientation(context) == Orientation.portrait
                  ? widget.screenHeight * 0.38
                  : widget.screenHeight *
                      0.8), // 👈 manually control height here
          maxWidth:
              widget.width ??
              (SizeConfig.orientation(context) == Orientation.portrait
                  ? widget.screenWidth * 0.9
                  : widget.screenWidth * 0.4), // optional: control width too
        ),

        child: SingleChildScrollView(
          child: Column(
            children: [
              widget.body ??
                  Column(
                    children: [
                      Text(
                        detailsForAssessmentText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:
                              SizeConfig.orientation(context) ==
                                      Orientation.portrait
                                  ? SizeConfig.blockSizeHorizontal! * 6
                                  : SizeConfig.blockSizeVertical! * 6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomTextField(
                        hintText: "Enter ID",
                        controller: idController,
                        showTitle: true,
                        showSuffixIcon: false,
                        titleText: idText,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'ID cannot be empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical! * 1),
                      CustomTextField(
                        hintText: "Enter shared ID",
                        controller: sharedIdController,
                        showTitle: true,
                        showSuffixIcon: false,
                        titleText: sharedIdText,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical! * 1),

                      CustomTextField(
                        hintText: accessPassTextHint,
                        controller: accessPasswordController,
                        showTitle: true,
                        showSuffixIcon: true,
                        titleText: accessPassText,
                      ),
                    ],
                  ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      buttonText: widget.leftButtonText ?? cancelText,
                      isOutlineButton: true,
                      onPressed:
                          widget.onLeftButtonPressed ??
                          () {
                            Navigator.pop(context);
                          },
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                  Expanded(
                    child: CustomElevatedButton(
                      buttonText: widget.rightButtonText ?? startNowText,
                      onPressed:
                          widget.onRightButtonPressed ??
                          () {
                            Navigator.pop(context, {
                              'id': idController.text,
                              'sharedId': sharedIdController.text,
                              'accessPassword': accessPasswordController.text,
                            });
                          },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
