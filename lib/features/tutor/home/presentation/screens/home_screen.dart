import 'dart:io';
import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/deadline_string_to_date_time.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/core/utilities/time_allowed_string.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/audio/audio_bloc.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/audio/audio_events.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/audio/audio_state.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_bloc.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_events.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_state.dart';
import 'package:class_app/features/tutor/home/presentation/screens/transcript_audio_screen.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/custom_container.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/recording_bottom_sheet.dart';
import 'package:class_app/features/tutor/profile/presentation/screens/assessment_screen.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_bloc.dart';
import 'package:class_app/features/tutor/quiz/presentation/bloc/question_events.dart';
import 'package:class_app/features/tutor/quiz/presentation/screens/set_quiz_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedFileName;
  String? filePath;
  bool setQuizz = false;

  @override
  void initState() {
    super.initState();
    context.read<TranscriptBloc>().add(FetchTranscriptsRequested());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isPortrait = SizeConfig.orientation(context) == Orientation.portrait;

    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, state) {
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
                  AppTopWidget(),
                  SizedBox(
                    height:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeVertical! * 3
                            : SizeConfig.blockSizeVertical! * 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          buttonText: recordText,
                          showIcon: true,
                          iconPath: micOutlineImage,
                          onPressed: () async {
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
                                return RecordingBottomSheet(
                                  isPortrait: isPortrait,
                                );
                              },
                            );
                            // Navigator.pushNamed(context, '/audioRecorder');
                          },
                        ),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                      Expanded(
                        child: CustomElevatedButton(
                          isOutlineButton: true,
                          buttonText: importText,
                          showIcon: true,
                          iconColor: blueColor,
                          iconPath: importImage,
                          onPressed: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'mp3',
                                    'wav',
                                    'aac',
                                    'm4a',
                                    'flac',
                                    'ogg',
                                  ],
                                  allowMultiple: true,
                                  dialogTitle: "Select Audio File",
                                );

                            if (result != null) {
                              File file = File(result.files.single.path!);
                              setState(() {
                                selectedFileName = result.files.single.name;
                                filePath = file.path;
                              });

                              await showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                    screenWidth: SizeConfig.screenWidth!,
                                    screenHeight: SizeConfig.screenHeight!,
                                    height:
                                        SizeConfig.orientation(context) ==
                                                Orientation.portrait
                                            ? SizeConfig.screenHeight! * 0.28
                                            : SizeConfig.screenHeight! * 0.6,
                                    rightButtonText: transcribeText,
                                    onRightButtonPressed: () {
                                      if (filePath != null) {
                                        context.read<AudioBloc>().add(
                                          UploadAudioRequested(filePath!),
                                        );
                                        Navigator.of(
                                          context,
                                        ).pop(); // Dismiss dialog
                                      }
                                    },
                                    body: Column(
                                      children: [
                                        Text(
                                          importfileText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.orientation(
                                                          context,
                                                        ) ==
                                                        Orientation.portrait
                                                    ? SizeConfig
                                                            .blockSizeHorizontal! *
                                                        6
                                                    : SizeConfig
                                                            .blockSizeVertical! *
                                                        6,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.blockSizeVertical! * 2,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              selectedFileName!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.orientation(
                                                              context,
                                                            ) ==
                                                            Orientation.portrait
                                                        ? SizeConfig
                                                                .blockSizeHorizontal! *
                                                            4
                                                        : SizeConfig
                                                                .blockSizeVertical! *
                                                            4,
                                                fontWeight: FontWeight.bold,
                                                color: Color(blueColor),
                                              ),
                                            ),
                                            SizedBox(
                                              height:
                                                  SizeConfig
                                                      .blockSizeVertical! *
                                                  2,
                                            ),
                                            Text(
                                              "Selected file",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize:
                                                    SizeConfig.orientation(
                                                              context,
                                                            ) ==
                                                            Orientation.portrait
                                                        ? SizeConfig
                                                                .blockSizeHorizontal! *
                                                            4
                                                        : SizeConfig
                                                                .blockSizeVertical! *
                                                            4,
                                                fontWeight: FontWeight.w500,
                                                color: Color(blueColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical! * 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        recentTranscriptionsText,
                        style: TextStyle(
                          fontSize:
                              SizeConfig.orientation(context) ==
                                      Orientation.portrait
                                  ? SizeConfig.screenWidth! * 0.06
                                  : SizeConfig.screenWidth! * 0.025,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical! * 2),
                  Expanded(
                    child: BlocListener<TranscriptBloc, TranscriptState>(
                      listener: (context, state) {
                        if (state is DeleteTranscriptError) {}
                      },
                      child: BlocBuilder<TranscriptBloc, TranscriptState>(
                        builder: (context, state) {
                          if (state is FetchingTranscripts) {
                            return Center(
                              child: LoadingWidget(
                                loadingText: "Loading transcripts...",
                              ),
                            );
                          } else if (state is DeletingTranscript) {
                            return Center(
                              child: LoadingWidget(
                                loadingText: "Deleting transcript...",
                              ),
                            );
                          } else if (state is TranscriptsFetched) {
                            final transcripts = state.transcripts;

                            if (transcripts.isEmpty) {
                              return Center(
                                child: Text(
                                  "No transcriptions available\nTap on the microphone to record\nor import audio",
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: Color(blackColor),
                                    fontSize:
                                        SizeConfig.orientation(context) ==
                                                Orientation.portrait
                                            ? SizeConfig.screenWidth! * 0.04
                                            : SizeConfig.screenWidth! * 0.025,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }

                            return RefreshIndicator(
                              onRefresh: () async {
                                context.read<TranscriptBloc>().add(
                                  FetchTranscriptsRequested(),
                                );
                              },
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: transcripts.length,
                                itemBuilder: (context, index) {
                                  final transcript = transcripts[index];
                                  return CustomContainer(
                                    titleText: 'Transcription ${index + 1}',
                                    subText: transcript.transcript,
                                    showTrailingIcon: true,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  TranscriptAudioScreen(
                                                    transcript: transcript,
                                                  ),
                                        ),
                                      );
                                    },
                                    onMoreButton: (context) {
                                      return [
                                        PopupMenuItem(
                                          value: 'quiz',
                                          child: Text('Set Quiz'),
                                        ),
                                        PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete'),
                                        ),
                                      ];
                                    },
                                    onMoreTap: (value) async {
                                      if (value == 'quiz') {
                                        final result = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SetQuizDialog();
                                          },
                                        );
                                        if (result != null) {
                                          // Handle the result from the dialog
                                          context.read<QuestionBloc>().add(
                                            GenerateQuestionsEventRequest(
                                              transcript: transcript.transcript,
                                              numberOfQuestions: int.parse(
                                                result['numberOfQuestions'] ??
                                                    10,
                                              ),
                                              title:
                                                  result['title'] ??
                                                  "Quiz Title Default",
                                              expiresAt:
                                                  deadlineStringToDateTime(
                                                    result['deadline'],
                                                  ) ??
                                                  DateTime.now().add(
                                                    Duration(hours: 1),
                                                  ),
                                              duration:
                                                  timeAllowedString(
                                                    result['timeAllowed'],
                                                  ) ??
                                                  '30mins',
                                              accessPassword:
                                                  result['accessPassword'],
                                            ),
                                          );
                                        }
                                      } else if (value == 'delete') {
                                        context.read<TranscriptBloc>().add(
                                          DeleteTranscriptRequested(
                                            transcript.id,
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            );
                          } else if (state is TranscriptError) {
                            return CustomErrorWidget(
                              message: state.message,
                              onRetry: () {
                                context.read<TranscriptBloc>().add(
                                  FetchTranscriptsRequested(),
                                );
                              },
                            );
                          } else {
                            return SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.loadingText});
  final String loadingText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: CircularProgressIndicator(color: Color(blueColor))),
        SizedBox(height: SizeConfig.blockSizeVertical! * 2),
        Text(loadingText),
      ],
    );
  }
}

class AppTopWidget extends StatelessWidget {
  const AppTopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          appNameText,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
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
                  : SizeConfig.blockSizeHorizontal! * 0.5,
        ),

        Text(
          homeSubText,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.screenWidth! * 0.04
                    : SizeConfig.screenWidth! * 0.025,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}
