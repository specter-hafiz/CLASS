import 'dart:async';

import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/onboarding/widgets/custom_elevated_button.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final isPortrait = SizeConfig.orientation(context) == Orientation.portrait;
    final screenWidth =
        SizeConfig.screenWidth ?? MediaQuery.of(context).size.width;
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
                    appNameText,
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
                            : SizeConfig.blockSizeHorizontal! * 0.5,
                  ),

                  Text(
                    homeSubText,
                    style: TextStyle(
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
                          showDragHandle: true,
                          isDismissible: false,
                          isScrollControlled: true,
                          backgroundColor: Color(whiteColor),
                          context: context,
                          builder: (context) {
                            return RecordingBottomSheet(isPortrait: isPortrait);
                          },
                        );
                        Navigator.pushNamed(context, '/audioRecorder');
                      },
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                  Expanded(
                    child: CustomElevatedButton(
                      isOutlineButton: true,
                      buttonText: importText,
                      showIcon: true,
                      iconPath: importImage,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 3),
              Row(
                children: [
                  Expanded(
                    child: Text(
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
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      viewAllText,
                      style: TextStyle(
                        color: Color(blueColor),
                        fontSize:
                            SizeConfig.orientation(context) ==
                                    Orientation.portrait
                                ? SizeConfig.screenWidth! * 0.04
                                : SizeConfig.screenWidth! * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.blockSizeVertical! * 2),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10, // Replace with your data length
                  itemBuilder: (context, index) {
                    return CustomContainer(
                      titleText: 'Transcription ${index + 1}',
                      subText: '00:30:00 | 407 words',
                      showTrailingIcon: true,
                      onTap: () {
                        // Handle tap action
                      },
                      onMoreTap: () {},
                    );
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
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  String? _filePath;

  Duration _elapsedTime = Duration.zero;
  Timer? _timer;
  StreamSubscription? _recorderSubscription;
  double _decibels = 0.0;

  @override
  void initState() {
    super.initState();
    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..addListener(() {
      setState(() {});
    });
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await Permission.storage.request();

    if (!await Permission.microphone.isGranted ||
        !await Permission.storage.isGranted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Permissions not granted")));
      Navigator.pop(context);
      return;
    }

    await _recorder.openRecorder();
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
    _startRecording();
  }

  Future<void> _startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    _filePath =
        '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(toFile: _filePath, codec: Codec.aacADTS);

    // Timer
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedTime += const Duration(seconds: 1);
      });
    });

    // Decibel (waveform) listener
    _recorderSubscription = _recorder.onProgress!.listen((event) {
      final currentDb = event.decibels ?? 0.0;

      setState(() {
        _waveformValues.removeAt(0); // shift left
        _waveformValues.add(currentDb); // push new value
      });

      _waveformController.forward(from: 0);
    });

    setState(() {
      _isRecording = true;
      _isPaused = false;
    });
  }

  Future<void> _pauseOrResumeRecording() async {
    if (_isPaused) {
      // Resume recording and timer
      await _recorder.resumeRecorder();

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _elapsedTime += const Duration(seconds: 1);
        });
      });
    } else {
      // Pause recording and cancel timer
      await _recorder.pauseRecorder();
      _timer?.cancel();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  Future<void> _stopAndSaveRecording() async {
    try {
      await _recorder.stopRecorder();
    } catch (_) {
      // In case the recorder was already stopped
    }

    _timer?.cancel();
    _recorderSubscription?.cancel();

    setState(() {
      _elapsedTime = Duration.zero;
      _isRecording = false;
      _isPaused = false;
    });

    if (_filePath != null) {
      widget.onSave?.call(_filePath!);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to save audio")));
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _timer?.cancel();
    _recorderSubscription?.cancel();
    _waveformController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "00:$minutes:$seconds";
  }

  List<double> _waveformValues = List.filled(40, 0.0);
  late AnimationController _waveformController;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_outlined),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Audio Recorder",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 2),

            /// Recording Timer
            Text(
              _formatDuration(_elapsedTime),
              style: TextStyle(
                fontSize: widget.isPortrait ? 40 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            SizedBox(height: SizeConfig.blockSizeVertical! * 2),

            /// Waveform visualizer
            AnimatedBuilder(
              animation: _waveformController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _WaveformPainter(_waveformValues),
                  child: const SizedBox.expand(),
                );
              },
            ),

            SizedBox(height: SizeConfig.blockSizeVertical! * 2),

            Text(
              _isRecording
                  ? (_isPaused ? "Paused" : "Recording...")
                  : "Stopped",
              style: TextStyle(
                fontSize: widget.isPortrait ? 18 : 14,
                color: Color(greyColor),
              ),
            ),

            /// Buttons
            SizedBox(height: SizeConfig.blockSizeVertical! * 2),
            GestureDetector(
              onTap: () {
                _pauseOrResumeRecording();
              },
              child: Container(
                height: widget.isPortrait ? 60 : 40,
                width: widget.isPortrait ? 60 : 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
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
                  onPressed: () {
                    if (_isRecording) {
                      _pauseOrResumeRecording();
                    } else {
                      _startRecording();
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockSizeVertical! * 2),

            Row(
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    buttonText: transcribeText,
                    onPressed: () {},
                    isOutlineButton: true,
                    showIcon: true,
                    iconPath: documentImage,
                    iconColor: blueColor,
                  ),
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal! * 2),
                Expanded(
                  child: CustomElevatedButton(
                    buttonText: setQuizText,

                    onPressed: () {},
                    showIcon: true,

                    iconPath: quizDocumentImage,
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

class _WaveformPainter extends CustomPainter {
  final List<double> waveformValues;
  _WaveformPainter(this.waveformValues);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.blueAccent
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;

    final centerLinePaint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1;

    final centerY = size.height / 2;
    final barWidth = size.width / waveformValues.length;

    // Draw center line
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      centerLinePaint,
    );

    for (int i = 0; i < waveformValues.length; i++) {
      final normalized = (waveformValues[i] + 50).clamp(0, 100);
      final barHeight = (normalized / 100) * size.height;
      final x = i * barWidth + barWidth / 2;
      final y1 = centerY - barHeight / 2;
      final y2 = centerY + barHeight / 2;

      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) =>
      oldDelegate.waveformValues != waveformValues;
}
