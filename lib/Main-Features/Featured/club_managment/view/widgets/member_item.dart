import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/Featured/club_managment/view/widgets/text_rich.dart';

import '../../../../home/widgets/divider.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = (screenHeight + screenWidth) * 0.09;

    return Container(
      padding: EdgeInsets.all(8),
      width: screenWidth * .8,
      height: screenHeight * .27,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Color(0x440D5FC3)),
          borderRadius: BorderRadius.circular(31),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sayed Member',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const MyDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MyTextRich(
                    text1: 'Skill level ',
                    text2: '10',
                  ),
                  SizedBox(height: screenHeight * .01),
                  const MyTextRich(
                    text1: 'Membership  ',
                    text2: 'Clear',
                  ),
                  SizedBox(height: screenHeight * .01),
                  const MyTextRich(
                    text1: 'Player type ',
                    text2: 'Singles',
                  ),
                  SizedBox(height: screenHeight * .01),
                  const MyTextRich(
                    text1: 'Date  ',
                    text2: '20-12-2023',
                  ),
                  SizedBox(height: screenHeight * .01),
                  const MyTextRich(
                    text1: 'Role ',
                    text2: 'Lead Player',
                  ),
                ],
              ),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(imageHeight / 5),
                    child: Container(
                      height: imageHeight,
                      width: imageHeight,
                      child: Image.asset(
                        'assets/images/clubimage.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * .005,
                  ),
                  Container(
                    decoration: const ShapeDecoration(
                      color: Color.fromARGB(212, 15, 32, 42),
                      shape: OvalBorder(),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.ads_click, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
