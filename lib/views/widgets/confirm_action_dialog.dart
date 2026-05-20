import 'package:flutter/material.dart';

Future<bool> showConfirmActionDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmText,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (_) {
      return _ConfirmActionDialog(
        title: title,
        message: message,
        confirmText: confirmText,
      );
    },
  );

  return confirmed ?? false;
}

class _ConfirmActionDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;

  const _ConfirmActionDialog({
    required this.title,
    required this.message,
    required this.confirmText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message, style: const TextStyle(color: Color(0xFF5E6C84))),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD92D20),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
