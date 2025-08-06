import 'dart:async';
import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/remarks_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/quiz_card.dart';
import 'package:class_app/features/tutor/quiz/data/models/question_model.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_bloc.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_events.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class AnswerQuizScreen extends StatefulWidget {
  const AnswerQuizScreen({
    super.key,
    required this.sharedQuestions,
    required this.duration,
    required this.startedAt,
    required this.sharedLinkId,
    required this.id,
  });
  final List<Question> sharedQuestions;
  final String duration;
  final String startedAt;
  final String sharedLinkId;
  final String id;

  @override
  State<AnswerQuizScreen> createState() => _AnswerQuizScreenState();
}

class _AnswerQuizScreenState extends State<AnswerQuizScreen> {
  int currentIndex = 0;
  int? selectedIndex;
  late List<int?> selectedAnswers;
  late Timer _timer;
  late Duration remainingTime;

  bool quizEnded = false;
  @override
  void initState() {
    super.initState();
    // if (sharedQuestions.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text("No questions available to answer."),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    //   return;
    // }
    try {
      final startedAtTime = DateTime.parse(widget.startedAt).toLocal();
      final now = DateTime.now();

      final parsedDuration = int.tryParse(widget.duration) ?? 1;
      final endTime = startedAtTime.add(Duration(minutes: parsedDuration));

      final remaining = endTime.difference(now);
      remainingTime = remaining.isNegative ? Duration.zero : remaining;
    } catch (e) {
      remainingTime = Duration(minutes: 1); // fallback
    }

    selectedAnswers = List.filled(widget.sharedQuestions.length, null);
    selectedIndex = selectedAnswers[currentIndex];

    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds > 0) {
        setState(() {
          remainingTime -= Duration(seconds: 1);
        });
      } else {
        submitQuiz(isTimeUp: true);
      }
    });
  }

  void submitQuiz({bool isTimeUp = false}) {
    setState(() {
      quizEnded = true;
    });

    final formattedAnswers = <Map<String, dynamic>>[];

    for (int i = 0; i < widget.sharedQuestions.length; i++) {
      final selected = selectedAnswers[i];
      if (selected != null) {
        formattedAnswers.add({
          "questionId": widget.sharedQuestions[i].id,
          "answer": widget.sharedQuestions[i].options[selected],
        });
      }
    }

    if (isTimeUp) {
      _timer.cancel();

      context.read<QuestionBloc>().add(
        SubmitAssessmentEvent(
          id: widget.id,
          sharedId: widget.sharedLinkId,
          response: formattedAnswers,
        ),
      );
      // Immediately navigate to remarks without showing dialog
    } else {
      // Show confirmation dialog before submitting manually
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) => AlertDialog(
              backgroundColor: Color(whiteColor),
              icon: Icon(Icons.info_outline_rounded, color: Color(blueColor)),
              title: Text(
                warningText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeHorizontal! * 6
                          : SizeConfig.blockSizeVertical! * 6,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Questions ${selectedAnswers.where((a) => a != null).length} / ${widget.sharedQuestions.length} answered",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal! * 4
                              : SizeConfig.blockSizeVertical! * 4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    confirmationText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:
                          SizeConfig.orientation(context) ==
                                  Orientation.portrait
                              ? SizeConfig.blockSizeHorizontal! * 4
                              : SizeConfig.blockSizeVertical! * 4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        buttonText: cancelText,
                        isOutlineButton: true,
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            quizEnded = false;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                    Expanded(
                      child: CustomElevatedButton(
                        buttonText: submitText,
                        onPressed: () {
                          _timer.cancel();
                          setState(() {
                            quizEnded = true;
                          });
                          context.read<QuestionBloc>().add(
                            SubmitAssessmentEvent(
                              id: widget.id,
                              sharedId: widget.sharedLinkId,
                              response: formattedAnswers,
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
      );
    }
  }

  void nextQuestion() {
    if (selectedIndex != null) {
      selectedAnswers[currentIndex] = selectedIndex;
    }

    if (currentIndex < widget.sharedQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = selectedAnswers[currentIndex];
      });
    }
  }

  void saveCurrentAnswer() {
    if (selectedIndex != null) {
      selectedAnswers[currentIndex] = selectedIndex;
    }
  }

  void previousQuestion() {
    if (selectedIndex != null) {
      selectedAnswers[currentIndex] = selectedIndex;
    }

    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        selectedIndex = selectedAnswers[currentIndex];
      });
    }
  }

  String get formattedTime {
    String minutes = remainingTime.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    String seconds = remainingTime.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return "00:$minutes:$seconds";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isPortrait = SizeConfig.orientation(context) == Orientation.portrait;
    final screenWidth =
        SizeConfig.screenWidth ?? MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(
          onTap: () {
            if (quizEnded) {
              Navigator.pop(context);
            } else {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => WarningDialog(),
              );
            }
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title:
            isPortrait
                ? Text("Q${currentIndex + 1}/${widget.sharedQuestions.length}")
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomElevatedButton(
                      buttonText: backText,
                      isOutlineButton: true,
                      onPressed: previousQuestion,
                      width: screenWidth * 0.2,
                    ),
                    Text(
                      "Q${currentIndex + 1}/${widget.sharedQuestions.length}",
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical! * 4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    CustomElevatedButton(
                      buttonText: nextText,
                      onPressed: nextQuestion,
                      width: screenWidth * 0.2,
                    ),
                  ],
                ),
        actions: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal! * 2,
            ),
            decoration: BoxDecoration(
              color: Color(blueColor),
              borderRadius: BorderRadius.circular(
                SizeConfig.blockSizeHorizontal! * 3,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    SizeConfig.blockSizeHorizontal! * 0.8,
                  ),
                  child: SvgPicture.asset(
                    timerImage,
                    width: SizeConfig.blockSizeHorizontal! * 4,
                    height: SizeConfig.blockSizeHorizontal! * 4,
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal! * 1),
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize:
                        isPortrait
                            ? SizeConfig.blockSizeHorizontal! * 4
                            : SizeConfig.blockSizeHorizontal! * 2,
                    color: Color(whiteColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: BlocListener<QuestionBloc, QuestionState>(
          listener: (context, state) {
            if (state is SubmittingAssessmentState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Submitting your answers..."),
                  backgroundColor: Colors.blue,
                ),
              );
            }
            if (state is SubmittingAssessmentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (state is SubmittedAssessmentState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => RemarksScreen(
                        score:
                            (state.score / state.numberOfQuestions * 100)
                                .toString(),
                      ),
                ),
              );
            }
          },
          child: Column(
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                      QuizCard(
                        questionIndex: currentIndex,
                        onOptionSelected: (index) {
                          setState(() {
                            selectedIndex = index;
                            selectedAnswers[currentIndex] = index;
                          });
                        },
                        selectedIndex: selectedIndex,
                        quizQuestions: widget.sharedQuestions,
                        questionText:
                            widget.sharedQuestions[currentIndex].question,
                        options: widget.sharedQuestions[currentIndex].options,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical! * 6),
                    ],
                  ),
                ),
              ),
              if (isPortrait)
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        buttonText: backText,
                        onPressed: previousQuestion,
                        isOutlineButton: true,
                      ),
                    ),
                    SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                    Expanded(
                      child:
                          currentIndex == widget.sharedQuestions.length - 1
                              ? CustomElevatedButton(
                                buttonText: submitText,
                                onPressed: () {
                                  submitQuiz(); // User must confirm via dialog
                                },
                              )
                              : CustomElevatedButton(
                                buttonText: nextText,
                                onPressed: nextQuestion,
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

class WarningDialog extends StatelessWidget {
  const WarningDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(whiteColor),
      icon: Icon(Icons.warning_amber_rounded, color: Color(blueColor)),
      title: Text(
        warningText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeHorizontal! * 6
                  : SizeConfig.blockSizeVertical! * 6,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        "Are you sure you want to exit? Your progress will be lost.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeHorizontal! * 4
                  : SizeConfig.blockSizeVertical! * 4,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomElevatedButton(
                buttonText: cancelText,
                isOutlineButton: true,
                onPressed: () => Navigator.pop(context),
              ),
            ),
            SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
            Expanded(
              child: CustomElevatedButton(
                buttonText: "Exit",
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
