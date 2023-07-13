import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputTextWithHint extends StatelessWidget {
  final String text;
  final String hint;
  final Widget? suffixIcon;
  final TextEditingController controller;

  const InputTextWithHint({
    Key? key,
    required this.text,
    required this.hint,
    this.suffixIcon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 2.0, left: screenWidth * .055),
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF525252),
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: screenWidth * .8,
            height: screenHeight * .05,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0x300A557F)),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 0, bottom: 5),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  color: Color(0xFF6E6E6E),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Color(0xFFA8A8A8),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  suffixIcon: suffixIcon != null
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          child: suffixIcon,
                        )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
