import 'dart:async';

import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/profile/data/question.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/remarks_screen.dart';
import 'package:class_app/features/tutor/profile/presentation/widgets/quiz_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AnswerQuizScreen extends StatefulWidget {
  const AnswerQuizScreen({super.key});

  @override
  State<AnswerQuizScreen> createState() => _AnswerQuizScreenState();
}

class _AnswerQuizScreenState extends State<AnswerQuizScreen> {
  int currentIndex = 0;
  int? selectedIndex;
  int score = 0;
  List<int?> selectedAnswers = List.filled(quizQuestions.length, null);
  late Timer _timer;
  Duration remainingTime = Duration(minutes: 1);
  bool quizEnded = false;
  @override
  void initState() {
    super.initState();
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
    _timer.cancel();

    int finalScore = 0;
    for (int i = 0; i < quizQuestions.length; i++) {
      if (selectedAnswers[i] == quizQuestions[i]['correctIndex']) {
        finalScore++;
      }
    }

    final calculatedScore = ((finalScore / quizQuestions.length) * 100).round();

    setState(() {
      score = calculatedScore;
      quizEnded = true;
    });

    if (isTimeUp) {
      // Immediately navigate to remarks without showing dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RemarksScreen(score: score.toString()),
        ),
      );
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
                    "Questions ${selectedAnswers.where((a) => a != null).length} / ${quizQuestions.length} answered",
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
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      RemarksScreen(score: score.toString()),
                            ),
                          );
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

    if (currentIndex < quizQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = selectedAnswers[currentIndex];
      });
    } else {
      submitQuiz();
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
        leading: CustomBackButton(),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title:
            isPortrait
                ? Text("Q${currentIndex + 1}/${quizQuestions.length}")
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
                      "Q${currentIndex + 1}/${quizQuestions.length}",
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
                    child: CustomElevatedButton(
                      buttonText: nextText,
                      onPressed: nextQuestion,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
