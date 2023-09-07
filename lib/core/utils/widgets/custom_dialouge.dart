import 'package:flutter/material.dart';
import 'package:tennis_app/generated/l10n.dart';

class CustomDialog extends StatelessWidget {
  final String text;

  CustomDialog({required this.text});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).accessDenied),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text(S.of(context).ok),
        ),
      ],
    );
  }
}
