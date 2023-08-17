import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/club/widgets/avaliable_courts.dart';
import 'package:tennis_app/Main-Features/club/widgets/club_events.dart';
import 'package:tennis_app/Main-Features/club/widgets/club_info.dart';
import 'package:tennis_app/Main-Features/club/widgets/double_matches_club.dart';
import 'package:tennis_app/Main-Features/club/widgets/double_tournaments_club.dart';
import 'package:tennis_app/Main-Features/club/widgets/header_text.dart';
import 'package:tennis_app/Main-Features/club/widgets/num_members.dart';
import 'package:tennis_app/Main-Features/club/widgets/players_ranking.dart';
import 'package:tennis_app/Main-Features/club/widgets/single_matches_club.dart';
import 'package:tennis_app/Main-Features/club/widgets/single_tournament_club.dart';

import '../../core/utils/widgets/app_bar_wave.dart';
import '../../generated/l10n.dart';
import '../../models/club.dart';
import '../../models/player.dart';
import '../home/services/firebase_methods.dart';
import '../home/widgets/button_home.dart';

import '../../core/methodes/firebase_methodes.dart';

class ClubScreen extends StatelessWidget {
  const ClubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.01;
    final Method method = Method();
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarWaveHome(
                text: S.of(context).your_club,
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
                    return Center(
                      child: Text(S.of(context).error_fetching_club_data),
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
                          return Center(
                            child: Text(S.of(context).error_fetching_club_data),
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
                              Text(
                                S.of(context).announcements,
                                style: const TextStyle(
                                  color: Color(0xFF313131),
                                  fontSize: 19,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: spacing * 2),
                              HeaderText(
                                  text: S.of(context).clubs_upcoming_events),
                              SizedBox(height: spacing / 3),
                              ClubEvents(
                                eventsId: clubData.eventIds,
                              ),
                              SizedBox(height: spacing * 2),
                              HeaderText(
                                  text: S.of(context).clubs_players_ranking),
                              PlayersRanking(
                                clubId: clubData.clubId,
                                clubName: clubData.clubName,
                              ),
                              SizedBox(height: spacing * 2),
                              HeaderText(text: S.of(context).available_courts),
                              SizedBox(height: spacing / 3),
                              const AvailableCourts(),
                              SizedBox(height: spacing * 2),
                              HeaderText(
                                  text: S.of(context).available_single_matches),
                              SizedBox(height: spacing),
                              const ClubSingleMatches(),
                              SizedBox(height: spacing * 2),
                              HeaderText(
                                  text: S.of(context).available_single_matches),
                              SizedBox(height: spacing),
                              const ClubDoubleMatches(),
                              const SingleTournamentsClub(),
                              const DoubleTournamentsClub(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.05),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    HomeButton(
                                        buttonText: S.of(context).create_event,
                                        imagePath:
                                            'assets/images/Create-Event.svg',
                                        onPressed: () async {
                                          navigateToCreateEvent(context);
                                        }),
                                    HomeButton(
                                      buttonText: S.of(context).find_partner,
                                      imagePath:
                                          'assets/images/Make-offers.svg',
                                      onPressed: () {
                                        GoRouter.of(context)
                                            .push('/findPartner');
                                      },
                                    ),
                                  ],
                                ),
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
