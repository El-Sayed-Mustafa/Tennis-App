import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/club/widgets/player_info.dart';
import 'package:tennis_app/Main-Features/club/widgets/see_all.dart';

class PlayersRanking extends StatelessWidget {
  const PlayersRanking({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
      child: Row(
        children: [
          const PlayerInfo(
            imagePath: 'assets/images/profile-image.jpg',
            name: 'Joseph',
            clubName: 'FC Club',
            svgImagePath: 'assets/images/first.svg',
          ),
          SizedBox(width: screenWidth * 0.04),
          const PlayerInfo(
            imagePath: 'assets/images/profile-image.jpg',
            name: 'Joseph',
            clubName: 'FC Club',
            svgImagePath: 'assets/images/second.svg',
          ),
          SizedBox(width: screenWidth * 0.04),
          const SeeAll()
        ],
      ),
    );
  }
}
