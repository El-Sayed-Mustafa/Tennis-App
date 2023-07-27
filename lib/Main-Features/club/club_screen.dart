import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Main-Features/club/widgets/club_events.dart';
import 'package:tennis_app/Main-Features/club/widgets/club_info.dart';
import 'package:tennis_app/Main-Features/club/widgets/header_text.dart';
import 'package:tennis_app/Main-Features/club/widgets/num_members.dart';
import 'package:tennis_app/Main-Features/club/widgets/players_ranking.dart';

import '../../core/utils/widgets/app_bar_wave.dart';
import '../../models/club.dart';
import '../../models/player.dart';
import '../home/widgets/button_home.dart';

import '../../core/methodes/firebase_methodes.dart';

class ClubScreen extends StatelessWidget {
  const ClubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.01;
    final Method method = Method();

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
              SizedBox(height: spacing),
              FutureBuilder<Player>(
                future: method.getCurrentUser(), // Call getCurrentUser() method
                builder: (context, playerSnapshot) {
                  if (playerSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    // While waiting for the user data to be fetched
                    return Container(
                      height: screenHeight,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (playerSnapshot.hasError) {
                    // If there was an error while fetching the user data
                    return const Center(
                      child: Text('Error fetching user data.'),
                    );
                  } else {
                    // If the user data was successfully fetched, show the UI
                    final player = playerSnapshot.data!;
                    return FutureBuilder<Club>(
                      future: method.fetchClubData(player
                          .participatedClubId), // Call fetchClubData() method
                      builder: (context, clubSnapshot) {
                        if (clubSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: screenHeight,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (clubSnapshot.hasError) {
                          return const Center(
                            child: Text('Error fetching club data.'),
                          );
                        } else {
                          final clubData = clubSnapshot.data!;
                          return Column(
                            children: [
                              ClubInfo(
                                clubData: clubData,
                              ),
                              SizedBox(height: spacing * 1.5),
                              NumMembers(
                                num: clubData.memberIds.length.toString(),
                              ),
                              SizedBox(height: spacing * 2.5),
                              const Text(
                                'Announcements',
                                style: TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 19,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: spacing * 2),
                              const HeaderText(text: 'Club’s Upcoming events'),
                              SizedBox(height: spacing / 3),
                              ClubEvents(
                                eventsId: clubData.eventIds,
                              ),
                              SizedBox(height: spacing * 2),
                              const HeaderText(text: 'Club’s Players Ranking'),
                              PlayersRanking(),
                              SizedBox(height: spacing * 2),
                              HomeButton(
                                buttonText: 'Create Event',
                                imagePath: 'assets/images/Make-offers.svg',
                                onPressed: () {},
                              ),
                              SizedBox(height: spacing * 2),
                            ],
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
