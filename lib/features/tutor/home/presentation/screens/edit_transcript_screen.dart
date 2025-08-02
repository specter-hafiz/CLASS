import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:class_app/core/constants/strings.dart';
import 'package:class_app/core/utilities/size_config.dart';
import 'package:class_app/features/auth/presentation/widgets/custom_back_button.dart';
import 'package:class_app/features/tutor/home/data/models/transcript_model.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_bloc.dart';
import 'package:class_app/features/tutor/home/presentation/bloc/transcript/transcript_events.dart';

class EditTranscriptScreen extends StatefulWidget {
  const EditTranscriptScreen({super.key, required this.transcript});
  final Transcript transcript;

  @override
  State<EditTranscriptScreen> createState() => _EditTranscriptScreenState();
}

class _EditTranscriptScreenState extends State<EditTranscriptScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.transcript.transcript);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSave() {
    final updatedContent = _controller.text.trim();

    if (updatedContent.isNotEmpty &&
        updatedContent != widget.transcript.transcript) {
      context.read<TranscriptBloc>().add(
        UpdateTranscriptRequested(
          transcriptId: widget.transcript.id,
          content: updatedContent,
        ),
      );
      // You can also return the updated content if needed
      Navigator.pop(context);
    } else {
      Navigator.pop(context); // Just pop if nothing changed
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: Text(
          editTrancriptText,
          style: TextStyle(
            fontSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeVertical! * 2.5
                    : SizeConfig.blockSizeVertical! * 6,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            iconSize:
                SizeConfig.orientation(context) == Orientation.portrait
                    ? SizeConfig.blockSizeVertical! * 3
                    : SizeConfig.blockSizeVertical! * 8,
            onPressed: _handleSave,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding(context),
        ),
        child: TextField(
          controller: _controller,
          maxLines: null,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Edit transcript here...",
          ),
        ),
      ),
    );
  }
}
