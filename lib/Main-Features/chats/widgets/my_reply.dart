import 'package:flutter/material.dart';

class MyReply extends StatelessWidget {
  const MyReply({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: 268,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 193, 191, 191).withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          color: const Color(0x33EE746C),
          border: Border.all(
            width: 0.25,
            color: const Color(0x5BC7C7C7),
          ),
        ),
        child: const Column(
          children: [
            Text(
              'I commented on Figma I want to add some fancy icons. Do you have any icon set?',
              style: TextStyle(
                color: Color(0xFF757575),
                fontSize: 13,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                letterSpacing: 1,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '12/20/23',
                style: TextStyle(
                  color: Color(0xFF707070),
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
