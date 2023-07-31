import 'package:flutter/material.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../models/player.dart';
import '../../../choose_club/widgets/card_details.dart';

class PlayingInfo extends StatelessWidget {
  const PlayingInfo({super.key, required this.player});
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CardDetails(
              color: Color(0x30ED6663),
              label: '${S.of(context).Matched_Played} ',
              svgPath: 'assets/images/courts.svg',
              value: player.matchPlayed.toString(),
            ),
            CardDetails(
              color: Color.fromARGB(112, 148, 211, 211),
              label: S.of(context).totalWins,
              svgPath: 'assets/images/wins.svg',
              value: player.totalWins.toString(),
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CardDetails(
              color: Color(0x3094B6D3),
              label: S.of(context).Skill_level,
              svgPath: 'assets/images/matches.svg',
              value: player.skillLevel.toString(),
            ),
            CardDetails(
              color: Color.fromARGB(108, 252, 179, 140),
              label: S.of(context).In_Club_Ranking,
              svgPath: 'assets/images/members.svg',
              value: '_',
            )
          ],
        )
      ],
    );
  }
}
