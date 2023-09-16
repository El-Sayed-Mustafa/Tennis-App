import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/club/widgets/avaliable_courts.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/generated/l10n.dart';
import 'package:tennis_app/models/club.dart';
import '../../../models/player.dart';

class AvailableCourtsWidget extends StatelessWidget {
  final TextEditingController? courtNameController; // Optional parameter
  final bool isSaveUser;
  const AvailableCourtsWidget(
      {super.key, this.courtNameController, required this.isSaveUser});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final Method method = Method();

    return Column(
      children: [
        FutureBuilder<Player>(
          future: method.getCurrentUser(),
          builder: (context, playerSnapshot) {
            if (playerSnapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: screenHeight,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (playerSnapshot.hasError) {
              return Center(
                child: Text(S.of(context).error_fetching_club_data),
              );
            } else {
              final player = playerSnapshot.data!;

              return FutureBuilder<Club>(
                future: method.fetchClubData(player.participatedClubId),
                builder: (context, clubSnapshot) {
                  if (clubSnapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: screenHeight,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (clubSnapshot.hasError) {
                    return Text(
                        'No available data'); // Show appropriate error UI
                  } else {
                    final clubData = clubSnapshot.data!;

                    return AvailableCourts(
                      clubData: clubData,
                      courtNameController: courtNameController,
                      isSaveUser: isSaveUser,
                    );
                  }
                },
              );
            }
          },
        ),
      ],
    );
  }
}
