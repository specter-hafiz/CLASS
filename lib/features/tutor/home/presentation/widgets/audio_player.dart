import 'dart:io';

import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/recording_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioPlaybackScreen extends StatefulWidget {
  const AudioPlaybackScreen({super.key});

  @override
  State<AudioPlaybackScreen> createState() => _AudioPlaybackScreenState();
}

class _AudioPlaybackScreenState extends State<AudioPlaybackScreen> {
  late AudioPlayer _audioPlayer;
  late PlayerController _waveformController;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _waveformController = PlayerController();
    _fetchLatestAudioFromCache();
  }

  Future<void> _fetchLatestAudioFromCache() async {
    try {
      final cacheDir =
          await getTemporaryDirectory(); // or getApplicationCacheDirectory()
      final files = Directory(cacheDir.path).listSync();

      // Filter for audio files (you can adjust extensions as needed)
      final audioFiles =
          files.whereType<File>().where((file) {
            final name = file.path.toLowerCase();
            return name.endsWith('.m4a') ||
                name.endsWith('.mp3') ||
                name.endsWith('.wav');
          }).toList();

      if (audioFiles.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No audio files found in cache")),
          );
        }
        return;
      }

      // Sort files by modified date (latest first)
      audioFiles.sort(
        (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
      );

      // Use the most recent one
      _filePath = audioFiles.first.path;

      _initAudio();
    } catch (e) {
      debugPrint("Error fetching audio from cache: $e");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error loading audio: $e")));
      }
    }
  }

  Future<void> _initAudio() async {
    try {
      await _waveformController.preparePlayer(
        path: _filePath!,
        shouldExtractWaveform: true,
      );

      await _audioPlayer.setFilePath(_filePath!);
      _audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() {
            _totalDuration = duration;
          });
        }
      });

      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _currentPosition = position;
        });
      });

      _audioPlayer.playerStateStream.listen((state) {
        final isPlaying = state.playing;
        final isCompleted = state.processingState == ProcessingState.completed;

        setState(() => _isPlaying = isPlaying);

        if (isCompleted) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.stop();

          _waveformController.seekTo(0);
          _waveformController.stopPlayer();

          setState(() {
            _isPlaying = false;
          });
        } else {
          isPlaying
              ? _waveformController.startPlayer()
              : _waveformController.pausePlayer();
        }
      });
    } catch (e) {
      debugPrint("Error initializing audio: $e");
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
    Navigator.pop(context, _filePath);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return _filePath == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 5
                        : SizeConfig.blockSizeVertical! * 2.5,
              ),
              Center(
                child: Text(
                  _formatDuration(_totalDuration - _currentPosition),
                  style: TextStyle(
                    fontSize:
                        SizeConfig.orientation(context) == Orientation.portrait
                            ? SizeConfig.blockSizeVertical! * 8
                            : SizeConfig.blockSizeVertical! * 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 5
                        : SizeConfig.blockSizeVertical! * 8,
              ),

              AudioFileWaveforms(
                size: Size(
                  MediaQuery.of(context).size.width,
                  SizeConfig.blockSizeVertical! * 10,
                ),
                playerController: _waveformController,
                enableSeekGesture: true,
                waveformType: WaveformType.long,
                playerWaveStyle: PlayerWaveStyle(
                  liveWaveColor: Color(blueColor),
                  fixedWaveColor: Color(greyColor),
                  scaleFactor: 200,
                  showSeekLine: true,
                  seekLineColor: Colors.red,
                  waveThickness: 2,
                ),
              ),
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 5
                        : SizeConfig.blockSizeVertical! * 10,
              ),
              Text(
                _isPlaying ? "Playing" : "Paused",
                style: TextStyle(
                  fontSize:
                      SizeConfig.orientation(context) == Orientation.portrait
                          ? SizeConfig.blockSizeVertical! * 2.5
                          : SizeConfig.blockSizeVertical! * 5,
                  color: Color(greyColor),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 5
                        : SizeConfig.blockSizeVertical! * 10,
              ),
              CustomPlayPauseButton(
                isRecording: _isPlaying,
                onpressed: _togglePlayPause,
              ),
              SizedBox(
                height:
                    SizeConfig.orientation(context) == Orientation.portrait
                        ? SizeConfig.blockSizeVertical! * 0
                        : SizeConfig.blockSizeVertical! * 2,
              ),
            ],
          ),
        );
  }
}
