import 'package:flutter/material.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final combine = (screenHeight + screenWidth);
    return Container(
      padding: EdgeInsets.all(combine * .013),
      width: screenWidth,
      height: screenHeight * .15,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.70, color: Color(0x440D5FC3)),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Preferred Playing time',
                style: TextStyle(
                  color: const Color(0xFF525252),
                  fontSize: combine * .013,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '4:00 PM ',
                style: TextStyle(
                  color: const Color(0xFF00344E),
                  fontSize: combine * .013,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date of birth',
                style: TextStyle(
                  color: const Color(0xFF525252),
                  fontSize: combine * .013,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '16-01-2001',
                style: TextStyle(
                  color: const Color(0xFF00344E),
                  fontSize: combine * .013,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Player type',
                style: TextStyle(
                  color: const Color(0xFF525252),
                  fontSize: combine * .013,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: ShapeDecoration(
                  color: const Color(0x0F00344E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Text(
                  'Singles',
                  style: TextStyle(
                    color: const Color(0xFF00344E),
                    fontSize: combine * .013,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
