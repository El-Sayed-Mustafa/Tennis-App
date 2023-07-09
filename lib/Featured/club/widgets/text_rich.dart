import 'package:flutter/material.dart';

class MyTextRich extends StatelessWidget {
  const MyTextRich({super.key, required this.text1, required this.text2});
  final String text1;
  final String text2;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text1,
            style: const TextStyle(
              color: Color(0xFF00344E),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const TextSpan(
            text: ': ',
            style: TextStyle(
              color: Color(0xFF00344E),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: text2,
            style: const TextStyle(
              color: Color(0xFF6D6D6D),
              fontSize: 13,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
