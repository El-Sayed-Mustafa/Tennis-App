import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/home/services/firebase_methods.dart';
import 'package:tennis_app/Main-Features/home/widgets/avaliable_courts.dart';
import 'package:tennis_app/Main-Features/home/widgets/button_home.dart';
import 'package:tennis_app/Main-Features/home/widgets/my_events.dart';
import 'package:tennis_app/Main-Features/home/widgets/my_matches.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/utils/widgets/app_bar_wave.dart';

import '../../generated/l10n.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final sectionTitleSize = screenWidth * 0.052;

    final spacing = screenHeight * 0.015;
    Method method = Method();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWaveHome(
              text: S.of(context).Home,
              suffixIconPath: 'assets/images/app-bar-icon.svg',
            ),
            SizedBox(
              height: spacing,
            ),
            Text(
              S.of(context).Your_Upcoming_Events,
              style: TextStyle(
                color: const Color(0xFF313131),
                fontSize: sectionTitleSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: spacing),
            const MyEvents(),
            SizedBox(height: spacing * 2),
            Text(
              S.of(context).Your_Reversed_Courts,
              style: TextStyle(
                color: const Color(0xFF313131),
                fontSize: sectionTitleSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const ReversedCourts(),
            SizedBox(height: spacing * 2),
            Text(
              S.of(context).Your_Upcoming_Matches,
              style: TextStyle(
                color: const Color(0xFF313131),
                fontSize: sectionTitleSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            MyMatches(),
            SizedBox(height: spacing * 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeButton(
                    buttonText: S.of(context).Find_Court,
                    imagePath: 'assets/images/Find-Court.svg',
                    onPressed: () {
                      GoRouter.of(context).push('/findCourt');
                    },
                  ),
                  HomeButton(
                    buttonText: S.of(context).Find_Partner,
                    imagePath: 'assets/images/Find-Partner.svg',
                    onPressed: () {
                      GoRouter.of(context).push('/findPartner');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeButton(
                      buttonText: S.of(context).Create_Event,
                      imagePath: 'assets/images/Create-Event.svg',
                      onPressed: () async {
                        navigateToCreateEvent(context);
                      }),
                  HomeButton(
                    buttonText: S.of(context).Create_Club,
                    imagePath: 'assets/images/Make-offers.svg',
                    onPressed: () async {
                      bool hasRight =
                          await method.doesPlayerHaveRight('Create offers');
                      print(hasRight);
                      GoRouter.of(context).push('/createClub');
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing * 2),
          ],
        ),
      ),
    );
  }
}
