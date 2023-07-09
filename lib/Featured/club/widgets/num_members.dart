import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NumMembers extends StatelessWidget {
  const NumMembers({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * .7,
      height: screenHeight * .06,
      decoration: ShapeDecoration(
        color: Color(0x87FFA372),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              'assets/images/members.svg',
              width: screenWidth * 0.15,
              height: screenHeight * 0.03,
            ),
            Text(
              'Total Members',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '56',
              style: TextStyle(
                color: Color(0xFF00344E),
                fontSize: 30,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }
}
