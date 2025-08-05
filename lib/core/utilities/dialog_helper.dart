import 'package:flutter/material.dart';

Future<void> showSuccessAndPop({
  required BuildContext context,
  required String message,
}) async {
  // Wait briefly to ensure state updates (optional but often helpful)
  await Future.delayed(const Duration(milliseconds: 300));

  // Ensure context is still valid
  if (!context.mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  // Optionally delay before popping to give time for SnackBar
  await Future.delayed(const Duration(milliseconds: 300));

  if (context.mounted) {
    Navigator.pop(context);
  }
}
