import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/home/services/firebase_methods.dart';
import 'package:tennis_app/Main-Features/home/widgets/avaliable_courts.dart';
import 'package:tennis_app/Main-Features/home/widgets/button_home.dart';
import 'package:tennis_app/Main-Features/home/widgets/double_club_matches.dart';
import 'package:tennis_app/Main-Features/home/widgets/my_events.dart';
import 'package:tennis_app/Main-Features/home/widgets/my_matches.dart';
import 'package:tennis_app/Main-Features/home/widgets/single_club_matches.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/methodes/roles_manager.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/app_bar_wave.dart';
import 'package:tennis_app/core/utils/widgets/custom_dialouge.dart';

import '../../generated/l10n.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static Future<bool> checkParticipatedClub() async {
    try {
      Method method = Method();
      final player = await method.getCurrentUser();
      final String participatedClubId = player.participatedClubId;
      return participatedClubId.isNotEmpty;
    } catch (e) {
      print("Error fetching player data: $e");
      return false;
    }
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();

    final sectionTitleSize = screenWidth * 0.052;

    final spacing = screenHeight * 0.015;
    Method method = Method();

    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              PoPBarWaveHome(
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
              const MyMatches(),
              SizedBox(height: spacing * 1),
              const MySingleMatches(),
              SizedBox(height: spacing * 1),
              const MyDoubleMatches(),
              SizedBox(height: spacing * 2),
              HomeButton(
                buttonText: S.of(context).Find_Court,
                imagePath: 'assets/images/Find-Court.svg',
                onPressed: () {
                  GoRouter.of(context).push('/findCourt');
                },
              ),
              SizedBox(height: spacing),
              HomeButton(
                buttonText: S.of(context).Find_Partner,
                imagePath: 'assets/images/Find-Partner.svg',
                onPressed: () {
                  GoRouter.of(context).push('/findPartner');
                },
              ),
              SizedBox(height: spacing),
              HomeButton(
                  buttonText: S.of(context).Create_Event,
                  imagePath: 'assets/images/Create-Event.svg',
                  onPressed: () async {
                    bool hasRight = await RolesManager.instance
                        .doesPlayerHaveRight('Create Event');
                    // bool hasRight =
                    //     await RolesManager.instance.doesPlayerHaveRight('Create Event');
                    if (hasRight) {
                      GoRouter.of(context).push('/createEvent');
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          text: S.of(context).noRightMessage,
                        ),
                      );
                    }
                  }),
              SizedBox(height: spacing),
              FutureBuilder<bool>(
                future: HomeScreen.checkParticipatedClub(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display a loading indicator while checking participation
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Handle error state
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final hasParticipated = snapshot.data ?? false;
                    if (hasParticipated) {
                      return Container();
                    } else {
                      return HomeButton(
                        buttonText: S.of(context).Create_Club,
                        imagePath: 'assets/images/Make-offers.svg',
                        onPressed: () {
                          GoRouter.of(context).push('/createClub');
                        },
                      );
                    }
                  }
                },
              ),
              SizedBox(height: spacing * 2),
            ],
          ),
        ),
      ),
    );
  }
}
