import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/personal_info.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/player_strength.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/playing_info.dart';
import 'package:tennis_app/models/club.dart'; // Replace 'Club' with the correct Club class path

import '../../../../../core/methodes/firebase_methodes.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../models/player.dart';
import '../../../../club/widgets/club_info.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key, required this.player});
  final Player player;
  double parseSkillLevel(String skillLevel) {
    try {
      return double.parse(skillLevel);
    } catch (e) {
      // Return a default value (e.g., 0.0) in case parsing fails
      return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final Method method = Method();

    return FutureBuilder<Club?>(
      future: method
          .fetchClubData(player.participatedClubId), // Fetch club data here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data, you can show a loading indicator or an empty container
          return Container();
        } else if (snapshot.hasError) {
          // Handle error if any
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been successfully fetched
          final clubData = snapshot.data;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * .07),
                child: Column(
                  children: [
                    PersonalInfo(
                      player: player,
                    ),
                    const SizedBox(height: 20),
                    PlayingInfo(
                      player: player,
                    ),
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
                  bottom: screenWidth * .05,
                ),
                child: clubData != null
                    ? ClubInfo(
                        clubData: clubData, // Pass the club data here
                      )
                    : Text(S
                        .of(context)
                        .No_Club_Data), // Show a message when clubData is null
              ),
              Text(
                S.of(context).Your_Strength,
                style: const TextStyle(
                  color: Color(0xFF313131),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              PlayerStrength(
                value: parseSkillLevel(player.skillLevel),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  S
                      .of(context)
                      .Your_strength_will_be_determined_based_on_your_playing_record_and_your_performance_may_impact_your_strength_rating,
                  style: const TextStyle(
                    color: Color(0xFF6A6A6A),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  // Function to fetch club data using the provided clubId
}
