import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordingBottomSheet extends StatefulWidget {
  const RecordingBottomSheet({
    super.key,
    required this.isPortrait,
    this.onSave,
  });

  final bool isPortrait;
  final Function(String path)? onSave;

  @override
  State<RecordingBottomSheet> createState() => _RecordingBottomSheetState();
}

class _RecordingBottomSheetState extends State<RecordingBottomSheet>
    with TickerProviderStateMixin {
  final RecorderController _recorderController = RecorderController();
  bool _isRecording = false;
  Duration _elapsedTime = Duration.zero;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    _recorderController.checkPermission();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission denied")),
      );
      Navigator.pop(context);
      return;
    }

    _recorderController
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..updateFrequency = const Duration(milliseconds: 400)
      ..sampleRate = 16000
      ..record();

    _recorderController.onCurrentDuration.listen((duration) {
      if (mounted) {
        setState(() {
          _elapsedTime = duration;
        });
      }
    });

    setState(() => _isRecording = true);
  }

  void _pauseRecording() {
    if (_isRecording) {
      _recorderController.pause();
      setState(() => _isRecording = false);
    } else {
      _recorderController.record();
      setState(() => _isRecording = true);
    }
  }

  Future<void> _stopRecording() async {
    final path = await _recorderController.stop();
    setState(() {
      _isRecording = false;
      _audioPath = path;
    });
    Navigator.pop(context); // Return the file path to parent
  }

  @override
  void dispose() {
    _recorderController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.horizontalPadding(context),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Audio Recorder",
                style: TextStyle(
                  fontSize:
                      widget.isPortrait
                          ? SizeConfig.blockSizeVertical! * 2.5
                          : SizeConfig.blockSizeVertical! * 5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 1),

            /// Recording Timer
            Center(
              child: Text(
                _formatDuration(_elapsedTime),
                style: TextStyle(
                  fontSize:
                      widget.isPortrait
                          ? SizeConfig.blockSizeVertical! * 5
                          : SizeConfig.blockSizeVertical! * 8,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical! * 2),

            /// Waveform visualizer
            SizedBox(
              width: SizeConfig.screenWidth,
              child: AudioWaveforms(
                size: Size(
                  SizeConfig.screenWidth!,
                  SizeConfig.blockSizeVertical! * 10,
                ),
                recorderController: _recorderController,
                waveStyle: WaveStyle(
                  extendWaveform: true,
                  waveColor: Color(blackColor),
                  showMiddleLine: true,
                  waveCap: StrokeCap.round,
                  spacing: 5,
                  waveThickness: 2,

                  scaleFactor: 120,
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical! * 2),

            Text(
              _isRecording ? "Recording..." : "Paused",
              style: TextStyle(
                fontSize:
                    widget.isPortrait
                        ? SizeConfig.blockSizeVertical! * 2
                        : SizeConfig.blockSizeVertical! * 4,
                color: Color(greyColor),
              ),
            ),

            /// Buttons
            SizedBox(height: SizeConfig.blockSizeVertical! * 2),
            CustomPlayPauseButton(
              isRecording: _isRecording,
              onpressed: () {
                _pauseRecording();
              },
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 3),

            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    buttonText: transcribeText,
                    onPressed: () {
                      _stopRecording();
                      if (_audioPath != null && widget.onSave != null) {
                        widget.onSave!(_audioPath!);
                      }
                    },
                    isOutlineButton: true,
                    showIcon: true,
                    iconPath: documentImage,
                    iconColor: blueColor,
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                Expanded(
                  child: CustomElevatedButton(
                    iconColor: whiteColor,
                    buttonText: setQuizText,

                    onPressed: () {},
                    showIcon: true,

                    iconPath: quizDocumentImage,
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 2),
          ],
        ),
      ),
    );
  }
}

class CustomPlayPauseButton extends StatelessWidget {
  const CustomPlayPauseButton({
    super.key,
    required bool isRecording,
    this.onpressed,
  }) : _isRecording = isRecording;

  final bool _isRecording;
  final void Function()? onpressed;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      height:
          SizeConfig.orientation(context) == Orientation.portrait
              ? SizeConfig.blockSizeVertical! * 8
              : 40,
      width:
          SizeConfig.orientation(context) == Orientation.portrait
              ? SizeConfig.blockSizeVertical! * 8
              : 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.blockSizeVertical! * 4),
        border: Border.all(color: Color(blueColor), width: 5),
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Color(whiteColor),
          padding: EdgeInsets.zero,
        ),
        icon: SvgPicture.asset(
          _isRecording ? pauseImage : playImage,
          width:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeHorizontal! * 3
                  : SizeConfig.blockSizeHorizontal! * 5,
          height:
              SizeConfig.orientation(context) == Orientation.portrait
                  ? SizeConfig.blockSizeVertical! * 3
                  : SizeConfig.blockSizeVertical! * 5,
        ),
        onPressed: onpressed,
      ),
    );
  }
}
