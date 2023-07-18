import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../choose_club/widgets/card_details.dart';

class PlayingInfo extends StatelessWidget {
  const PlayingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const CardDetails(
              color: Color(0x30ED6663),
              label: 'Match Played ',
              svgPath: 'assets/images/courts.svg',
              value: '12',
            ),
            CardDetails(
              color: Color.fromARGB(112, 148, 211, 211),
              label: S.of(context).totalWins,
              svgPath: 'assets/images/wins.svg',
              value: '12',
            )
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CardDetails(
              color: Color(0x3094B6D3),
              label: 'Skill level',
              svgPath: 'assets/images/matches.svg',
              value: '4',
            ),
            CardDetails(
              color: Color.fromARGB(108, 252, 179, 140),
              label: 'In Club Ranking',
              svgPath: 'assets/images/members.svg',
              value: '12',
            )
          ],
        )
      ],
    );
  }
}
