import 'package:flutter/material.dart';
import 'package:tennis_app/generated/l10n.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 0.5,
            color: Colors.grey[400],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(S.of(context).orContinueWith,
                style: TextStyle(color: Colors.grey[700])),
          ),
          Expanded(
              child: Divider(
            thickness: 0.5,
            color: Colors.grey[400],
          )),
        ],
      ),
    );
  }
}
