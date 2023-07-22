import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Main-Features/club/widgets/club_events.dart';
import 'package:tennis_app/Main-Features/club/widgets/club_info.dart';
import 'package:tennis_app/Main-Features/club/widgets/header_text.dart';
import 'package:tennis_app/Main-Features/club/widgets/num_members.dart';
import 'package:tennis_app/Main-Features/club/widgets/players_ranking.dart';

import '../../core/utils/widgets/app_bar_wave.dart';
import '../home/widgets/button_home.dart';

class ClubScreen extends StatelessWidget {
  const ClubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    final double spacing = screenHeight * 0.01;
    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarWaveHome(
                prefixIcon: SvgPicture.asset(
                  'assets/images/profile-icon.svg',
                  fit: BoxFit.contain,
                ),
                text: 'Your Club',
                suffixIconPath: 'assets/images/app-bar-icon.svg',
              ),
              SizedBox(
                height: spacing,
              ),
              //  TODO:ClubInfo(clubData: null,),
              SizedBox(
                height: spacing * 1.5,
              ),
              const NumMembers(),
              SizedBox(
                height: spacing * 2.5,
              ),
              const Text(
                'Announcements',
                style: TextStyle(
                  color: Color(0xFF313131),
                  fontSize: 19,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: spacing * 2,
              ),
              const HeaderText(text: 'Club’s Upcoming events'),
              SizedBox(
                height: spacing / 3,
              ),
              const ClubEvents(),
              SizedBox(
                height: spacing * 2,
              ),
              const HeaderText(text: 'Club’s Players Ranking'),
              const PlayersRanking(),
              SizedBox(
                height: spacing * 2,
              ),
              HomeButton(
                buttonText: 'Create Event',
                imagePath: 'assets/images/Make-offers.svg',
                onPressed: () {},
              ),
              SizedBox(
                height: spacing * 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
