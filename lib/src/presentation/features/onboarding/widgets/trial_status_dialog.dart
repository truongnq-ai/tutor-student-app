import 'package:flutter/material.dart';

/// Dialog widget for displaying trial/licence status messages.
/// Used for statuses that require user acknowledgment before navigation.
class TrialStatusDialog extends StatelessWidget {
  const TrialStatusDialog({
    super.key,
    required this.message,
    this.title = 'Thông báo',
    this.onOk,
  });

  final String message;
  final String title;
  final VoidCallback? onOk;

  /// Show the dialog with the given message.
  /// Returns a Future that completes when the dialog is dismissed.
  static Future<void> show(
    BuildContext context, {
    required String message,
    String title = 'Thông báo',
    VoidCallback? onOk,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TrialStatusDialog(
        message: message,
        title: title,
        onOk: onOk,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onOk?.call();
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}

