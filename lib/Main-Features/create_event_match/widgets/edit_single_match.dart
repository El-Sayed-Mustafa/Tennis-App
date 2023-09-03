import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import 'package:tennis_app/core/utils/widgets/single_match_card%20copy.dart';
import 'package:tennis_app/models/single_match.dart';

import '../single_friendly_match/player_match_item.dart';

class EditSingleMatch extends StatelessWidget {
  const EditSingleMatch(
      {super.key, required this.match, required this.tournamentId});
  final SingleMatch match;
  final String tournamentId;
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double carouselHeight = (screenHeight + screenWidth) * 0.165;

    return Scaffold(
      body: Column(
        children: [
          PoPAppBarWave(
            prefixIcon: IconButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
            ),
            text: 'Edit Match',
            suffixIconPath: '',
          ),
          const Text(
            'Update Match',
            style: TextStyle(
              color: Color(0xFF313131),
              fontSize: 22,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenHeight * .01),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
            child: SizedBox(
              height: carouselHeight,
              child: SingleMatchCard(
                match: match,
                tournamentId: tournamentId,
              ),
            ),
          ),
          SizedBox(height: screenHeight * .01),
          const Expanded(child: PlayerMatchItem())
        ],
      ),
    );
  }
}
