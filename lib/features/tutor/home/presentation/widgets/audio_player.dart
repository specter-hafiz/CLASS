import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioPlaybackScreen extends StatefulWidget {
  final String audioPath;

  const AudioPlaybackScreen({super.key, required this.audioPath});

  @override
  State<AudioPlaybackScreen> createState() => _AudioPlaybackScreenState();
}

class _AudioPlaybackScreenState extends State<AudioPlaybackScreen> {
  late AudioPlayer _audioPlayer;
  late PlayerController _waveformController;

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _waveformController = PlayerController();

    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _waveformController.preparePlayer(
        path: widget.audioPath,
        shouldExtractWaveform: true,
      );

      await _audioPlayer.setFilePath(widget.audioPath);

      _audioPlayer.playerStateStream.listen((state) {
        final isPlaying = state.playing;
        final isCompleted = state.processingState == ProcessingState.completed;

        setState(() => _isPlaying = isPlaying);

        if (isCompleted) {
          _waveformController.stopPlayer();
          _isPlaying = false; // Reset playing state
          _audioPlayer.stop(); // Stop audio playback
          _audioPlayer.seek(Duration.zero); // Reset audio
          _waveformController.seekTo(0);
        } else {
          isPlaying
              ? _waveformController.startPlayer()
              : _waveformController.pausePlayer();
        }
      });
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play();
    }
  }

  void _stopAndReturn() async {
    await _audioPlayer.stop();
    await _waveformController.stopAllPlayers();
    Navigator.pop(context, widget.audioPath);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Audio Playback"),
        actions: [
          IconButton(icon: const Icon(Icons.stop), onPressed: _stopAndReturn),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AudioFileWaveforms(
              size: Size(MediaQuery.of(context).size.width, 80),
              playerController: _waveformController,
              enableSeekGesture: true,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: PlayerWaveStyle(
                liveWaveColor: Colors.blueAccent,
                fixedWaveColor: Colors.grey.shade300,
                showSeekLine: true,
                seekLineColor: Colors.black,
                waveThickness: 3,
              ),
            ),
            const SizedBox(height: 40),
            IconButton(
              iconSize: 64,
              icon: Icon(
                _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                color: Colors.blueAccent,
              ),
              onPressed: _togglePlayPause,
            ),
          ],
        ),
      ),
    );
  }
}
