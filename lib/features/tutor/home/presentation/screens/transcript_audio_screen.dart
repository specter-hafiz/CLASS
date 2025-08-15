import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/home/data/models/transcript_model.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_bloc.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_events.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_state.dart';
import 'package:class_app/features/tutor/home/presentation/screens/edit_transcript_screen.dart';
import 'package:class_app/features/tutor/home/presentation/screens/home_screen.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/audio_playback_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

class TranscriptAudioScreen extends StatefulWidget {
  const TranscriptAudioScreen({super.key, required this.transcript});
  final Transcript transcript;

  @override
  State<TranscriptAudioScreen> createState() => _TranscriptAudioScreenState();
}

class _TranscriptAudioScreenState extends State<TranscriptAudioScreen> {
  int selectedIndex = 0;
  late TextEditingController transcriptController;

  @override
  void initState() {
    super.initState();
    transcriptController = TextEditingController();
    context.read<TranscriptBloc>().add(
      FetchTranscriptRequested(widget.transcript.id),
    );
  }

  @override
  void dispose() {
    transcriptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TranscriptBloc, TranscriptState>(
      listener: (context, state) {
        if (state is TranscriptError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is TranscriptFetched) {
          final transcript = state.transcript;
          transcriptController.text = transcript.transcript;
        } else if (state is TranscriptUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Transcript updated successfully")),
          );
          transcriptController.text = state.updatedTranscript.transcript;
        }
      },
      builder: (context, state) {
        final isPortrait =
            SizeConfig.orientation(context) == Orientation.portrait;

        final Transcript currentTranscript =
            state is TranscriptFetched ? state.transcript : widget.transcript;

        return PopScope(
          onPopInvokedWithResult: (bool bul, results) async {
            if (FocusScope.of(context).hasFocus) {
              FocusScope.of(context).unfocus();
            }
            context.read<TranscriptBloc>().add(FetchTranscriptsRequested());
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                meetingDiscussionText,
                style: TextStyle(
                  fontSize:
                      isPortrait
                          ? SizeConfig.blockSizeVertical! * 2.5
                          : SizeConfig.blockSizeVertical! * 6,
                  fontWeight: FontWeight.w500,
                ),
              ),
              automaticallyImplyLeading: false,
              leading: CustomBackButton(
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.horizontalPadding(context),
              ),
              child:
                  state is TranscriptLoading
                      ? LoadingWidget(loadingText: "Loading transcipt...")
                      : Column(
                        children: [
                          // Toggle buttons
                          Container(
                            padding: EdgeInsets.all(
                              isPortrait
                                  ? SizeConfig.blockSizeVertical! * 0.5
                                  : SizeConfig.blockSizeVertical! * 1,
                            ),
                            decoration: BoxDecoration(
                              color: Color(lightBlue),
                              borderRadius: BorderRadius.circular(
                                SizeConfig.blockSizeVertical! * 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomElevatedButton(
                                    height:
                                        isPortrait
                                            ? SizeConfig.blockSizeVertical! * 5
                                            : SizeConfig.blockSizeVertical! *
                                                10,
                                    buttonText: transcriptText,
                                    backgroundColor:
                                        selectedIndex == 0
                                            ? blueColor
                                            : transparentColor,
                                    textColor:
                                        selectedIndex == 0
                                            ? whiteColor
                                            : blueColor,
                                    onPressed:
                                        () => setState(() => selectedIndex = 0),
                                  ),
                                ),
                                SizedBox(
                                  width: SizeConfig.blockSizeHorizontal! * 2,
                                ),
                                Expanded(
                                  child: CustomElevatedButton(
                                    height:
                                        isPortrait
                                            ? SizeConfig.blockSizeVertical! * 5
                                            : SizeConfig.blockSizeVertical! *
                                                10,
                                    buttonText: audioText,
                                    backgroundColor:
                                        selectedIndex == 1
                                            ? blueColor
                                            : transparentColor,
                                    textColor:
                                        selectedIndex == 1
                                            ? whiteColor
                                            : blueColor,
                                    onPressed:
                                        () => setState(() => selectedIndex = 1),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Content
                          Expanded(
                            child:
                                selectedIndex == 0
                                    ? Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              transcribedText,
                                              style: TextStyle(
                                                fontSize:
                                                    isPortrait
                                                        ? SizeConfig
                                                                .blockSizeVertical! *
                                                            2
                                                        : SizeConfig
                                                                .blockSizeVertical! *
                                                            5,
                                                color: Color(blackColor),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                padding: EdgeInsets.zero,
                                              ),
                                              onPressed: () async {
                                                await Navigator.of(
                                                  context,
                                                ).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          _,
                                                        ) => EditTranscriptScreen(
                                                          transcript:
                                                              currentTranscript,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                editText,
                                                style: TextStyle(
                                                  fontSize:
                                                      isPortrait
                                                          ? SizeConfig
                                                                  .blockSizeVertical! *
                                                              2
                                                          : SizeConfig
                                                                  .blockSizeVertical! *
                                                              5,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.w500,
                                                  decorationColor: Color(
                                                    blueColor,
                                                  ),
                                                  color: Color(blueColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: transcriptController,
                                            readOnly: true,
                                            maxLines: null,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        CustomElevatedButton(
                                          buttonText: shareText,
                                          onPressed: () async {
                                            await SharePlus.instance.share(
                                              ShareParams(
                                                text:
                                                    currentTranscript
                                                        .transcript,
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height:
                                              SizeConfig.blockSizeVertical! * 1,
                                        ),
                                      ],
                                    )
                                    : AudioPlaybackScreen(
                                      audioUrl: currentTranscript.audioUrl,
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
