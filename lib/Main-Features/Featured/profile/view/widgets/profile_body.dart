import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/personal_info.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/player_strength.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/playing_info.dart';

import '../../../../club/widgets/club_info.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * .07),
          child: const Column(
            children: [
              PersonalInfo(),
              SizedBox(height: 20),
              PlayingInfo(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Your Club',
            style: TextStyle(
              color: Color(0xFF313131),
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(
                right: screenWidth * .05,
                left: screenWidth * .05,
                bottom: screenWidth * .05),
            child: const ClubInfo()),
        const Text(
          'Your Strength',
          style: TextStyle(
            color: Color(0xFF313131),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        const PlayerStrength(
          value: 9,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Your strength will be determined based on your playing record,\nand your performance may impact your strength rating.',
            style: TextStyle(
              color: Color(0xFF6A6A6A),
              fontSize: 11,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        )
      ],
    );
  }
}
