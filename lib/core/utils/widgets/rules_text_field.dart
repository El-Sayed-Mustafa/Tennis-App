import 'package:flutter/material.dart';

class RulesInputText extends StatelessWidget {
  const RulesInputText({
    Key? key,
    required this.header,
    required this.body,
    required this.controller,
  }) : super(key: key);
  final String header;
  final String body;
  final TextEditingController controller;

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
              header,
              style: const TextStyle(
                color: Color(0xFF525252),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: screenWidth * .8,
            height: screenHeight * .2,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0x300A557F)),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 24, right: 24, bottom: 6, top: 6),
              child: TextField(
                maxLines: 8,
                controller: controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: body,
                  hintStyle: const TextStyle(
                    color: Color(0xFFA8A8A8),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
