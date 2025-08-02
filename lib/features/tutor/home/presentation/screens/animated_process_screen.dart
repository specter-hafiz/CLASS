import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedProcessScreen extends StatefulWidget {
  final String animationPath;
  final String message;
  final bool showEmojiAfter;
  final VoidCallback? onFinished;

  const AnimatedProcessScreen({
    super.key,
    required this.animationPath,
    required this.message,
    this.showEmojiAfter = false,
    this.onFinished,
  });

  @override
  State<AnimatedProcessScreen> createState() => _AnimatedProcessScreenState();
}

class _AnimatedProcessScreenState extends State<AnimatedProcessScreen> {
  bool showEmoji = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!showEmoji)
              Lottie.asset(widget.animationPath, width: 200, height: 200),
            if (showEmoji) const Text("😊", style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              widget.message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
