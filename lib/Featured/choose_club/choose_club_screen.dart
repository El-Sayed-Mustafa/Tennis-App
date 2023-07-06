import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Featured/choose_club/widgets/card_details.dart';
import 'package:tennis_app/Featured/choose_club/widgets/static_rating_bar.dart';
import 'package:tennis_app/Featured/choose_club/widgets/wave_clipper_widget.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../core/utils/widgets/opacity_wave.dart';

class ChooseClub extends StatelessWidget {
  const ChooseClub({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                WaveClipperScreenChooseClub(
                  widgetHeight: screenHeight * .4,
                  svgImage: SvgPicture.asset('assets/images/choose-club.svg'),
                  text: "Join Club",
                ),
                OpacityWave(height: screenHeight * 0.407),
              ],
            ),
            SizedBox(
              height: screenHeight * .005,
            ),
            const Text(
              'FC Barcelona',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: screenHeight * .007,
            ),
            const StaticRatingBar(rating: 4.5),
            SizedBox(
              height: screenHeight * .007,
            ),
            const Text(
              'Buhl 9, 35043 Marburg\nGermany',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6D6D6D),
                fontSize: 14,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: screenHeight * .007,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CardDetails(
                    svgPath: 'assets/images/members.svg',
                    value: '56',
                    label: 'Total Members',
                    color: Color(0x87FFA372),
                  ),
                  SizedBox(
                    width: screenWidth * .08,
                  ),
                  const CardDetails(
                    svgPath: 'assets/images/matches.svg',
                    value: '100',
                    label: 'Total Members',
                    color: Color(0x84ED6663),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CardDetails(
                    svgPath: 'assets/images/wins.svg',
                    value: '90',
                    label: 'Total Members',
                    color: Color(0x8294D3D3),
                  ),
                  SizedBox(
                    width: screenWidth * .08,
                  ),
                  const CardDetails(
                    svgPath: 'assets/images/courts.svg',
                    value: '3',
                    label: 'Total Members',
                    color: Color(0x8294B6D3),
                  ),
                ],
              ),
            ),
            BottomSheetContainer(
              buttonText: 'Join',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
