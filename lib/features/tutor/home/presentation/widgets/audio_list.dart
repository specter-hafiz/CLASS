import 'dart:io';

import 'package:class_app/features/tutor/home/presentation/widgets/audio_player.dart'
    show AudioPlayerScreen;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<List<FileSystemEntity>> getSavedAudioFiles() async {
  final dir = await getApplicationDocumentsDirectory();
  final directory = Directory(dir.path);

  // List all .aac files
  List<FileSystemEntity> files =
      directory.listSync().where((file) => file.path.endsWith(".aac")).toList();

  return files;
}

class AudioListScreen extends StatefulWidget {
  const AudioListScreen({super.key});

  @override
  State<AudioListScreen> createState() => _AudioListScreenState();
}

class _AudioListScreenState extends State<AudioListScreen> {
  List<FileSystemEntity> _audioFiles = [];

  @override
  void initState() {
    super.initState();
    _loadAudioFiles();
  }

  Future<void> _loadAudioFiles() async {
    final files = await getSavedAudioFiles();
    setState(() {
      _audioFiles = files;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Recordings")),
      body:
          _audioFiles.isEmpty
              ? const Center(child: Text("No recordings found"))
              : ListView.builder(
                itemCount: _audioFiles.length,
                itemBuilder: (context, index) {
                  final file = _audioFiles[index];
                  return ListTile(
                    title: Text(file.path.split('/').last),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AudioPlayerScreen(path: file.path),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
