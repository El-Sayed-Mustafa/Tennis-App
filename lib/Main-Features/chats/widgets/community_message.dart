import 'package:flutter/material.dart';

class CommunityMessage extends StatelessWidget {
  const CommunityMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile-image.jpg'),
            radius: 20,
          ),
          const SizedBox(
            width: 7,
          ),
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.only(bottom: 14, right: 20, left: 20),
            width: 268,
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.25, color: Color(0x5BC7C7C7)),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x1E000000),
                  blurRadius: 6,
                  offset: Offset(0, 0),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 8, bottom: 5),
                  child: const Text(
                    'Elsayed Mustafa',
                    style: TextStyle(
                      color: Color(0xFF00344E),
                      fontFamily: 'Poppins',
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Text(
                  'I commented on Figma I want to add some fancy icons. Do you have any icon set?',
                  style: TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Align(
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
          )
        ],
      ),
    );
  }
}
