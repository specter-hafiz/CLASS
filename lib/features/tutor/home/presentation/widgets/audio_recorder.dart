import 'package:class_app/features/tutor/home/presentation/widgets/audio_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderWidget extends StatefulWidget {
  final Function(String path)? onSave;

  const AudioRecorderWidget({super.key, this.onSave});

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
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
      return;
    }

    await _recorder.openRecorder();
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
  }

  Future<void> _startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    _filePath =
        '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(toFile: _filePath, codec: Codec.aacADTS);

    setState(() {
      _isRecording = true;
      _isPaused = false;
    });
  }

  Future<void> _pauseOrResumeRecording() async {
    if (_isPaused) {
      await _recorder.resumeRecorder();
    } else {
      await _recorder.pauseRecorder();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  Future<void> _stopAndSaveRecording() async {
    await _recorder.stopRecorder();
    setState(() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Visualizer
        if (_isRecording)
          StreamBuilder(
            stream: _recorder.onProgress,
            builder: (context, snapshot) {
              final level = snapshot.data?.decibels ?? 0.0;
              return Container(
                height: 80,
                color: Colors.black12,
                child: CustomPaint(
                  painter: _WavePainter(level),
                  child: const SizedBox.expand(),
                ),
              );
            },
          ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(_isRecording ? Icons.stop : Icons.mic),
              label: Text(_isRecording ? "Stop & Save" : "Record"),
              onPressed: _isRecording ? _stopAndSaveRecording : _startRecording,
            ),
            const SizedBox(width: 10),
            if (_isRecording)
              ElevatedButton.icon(
                icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                label: Text(_isPaused ? "Resume" : "Pause"),
                onPressed: _pauseOrResumeRecording,
              ),
          ],
        ),
        if (!_isRecording && _filePath != null)
          ElevatedButton(
            child: const Text("Audio List"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AudioListScreen()),
              );
            },
          ),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  final double decibels;
  _WavePainter(this.decibels);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.greenAccent
          ..strokeWidth = 4;

    final centerY = size.height / 2;
    final barHeight = (decibels + 50).clamp(0, 100);

    canvas.drawLine(
      Offset(size.width / 2, centerY - barHeight / 2),
      Offset(size.width / 2, centerY + barHeight / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.decibels != decibels;
}
