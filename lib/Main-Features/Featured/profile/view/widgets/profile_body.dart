import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/personal_info.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/playing_info.dart';

import '../../../../../generated/l10n.dart';
import '../../../../club/widgets/club_info.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
              fontSize: 18,
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
      ],
    );
  }
}
