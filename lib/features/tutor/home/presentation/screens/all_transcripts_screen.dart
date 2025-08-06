import 'package:flutter/material.dart';

class AllTranscriptsScreen extends StatefulWidget {
  const AllTranscriptsScreen({super.key});

  @override
  State<AllTranscriptsScreen> createState() => _AllTranscriptsScreenState();
}

class _AllTranscriptsScreenState extends State<AllTranscriptsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Transcripts')),
      body: Center(
        child: Text(
          'This is the All Transcripts Screen',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
