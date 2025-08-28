import 'dart:io';

import 'package:class_app/core/constants/app_colors.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/tutor/home/presentation/screens/home_screen.dart';
import 'package:class_app/features/tutor/home/presentation/widgets/recording_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class AudioPlaybackScreen extends StatefulWidget {
  const AudioPlaybackScreen({super.key, required this.audioUrl});
  final String audioUrl;

  @override
  State<AudioPlaybackScreen> createState() => _AudioPlaybackScreenState();
}

class _AudioPlaybackScreenState extends State<AudioPlaybackScreen> {
  late AudioPlayer _audioPlayer;
  late PlayerController _waveformController;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isPlaying = false;
  String? _audioUrl;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _waveformController = PlayerController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioUrl = widget.audioUrl;
      _loadAudio(audioUrl);
    });
  }

  Future<void> _loadAudio(String url) async {
    try {
      if (url.startsWith('http')) {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/temp_audio.aac');
          await file.writeAsBytes(response.bodyBytes);
          _audioUrl = file.path;
        } else {
          throw Exception("Download failed");
        }
      } else {
        // Local file already
        _audioUrl = url;
      }

      await _initAudio(); // Now safe to call
      setState(() {}); // To rebuild with waveform
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> _initAudio() async {
    try {
      await _waveformController.preparePlayer(
        path: _audioUrl!,
        shouldExtractWaveform: true,
      );

      await _audioPlayer.setFilePath(_audioUrl!);
      _audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          if (!mounted) return;
          setState(() {
            _totalDuration = duration;
          });
        }
      });

      _audioPlayer.positionStream.listen((position) {
        if (!mounted) return;
        setState(() {
          _currentPosition = position;
        });
      });

      _audioPlayer.playerStateStream.listen((state) {
        final isPlaying = state.playing;
        final isCompleted = state.processingState == ProcessingState.completed;
        if (!mounted) return;
        setState(() => _isPlaying = isPlaying);

        if (isCompleted) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.stop();

          _waveformController.seekTo(0);
          _waveformController.stopPlayer();
          if (!mounted) return;
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
    return _audioUrl == null
        ? const Center(child: LoadingWidget(loadingText: "Fetching audio..."))
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
