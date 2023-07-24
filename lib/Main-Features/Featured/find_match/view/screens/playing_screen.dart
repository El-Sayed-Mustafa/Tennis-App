import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/find_match/view/widgets/match_item.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../models/Match.dart';

class PlayingScreen extends StatelessWidget {
  const PlayingScreen({super.key, required this.match, required this.opponent});
  final Matches match;
  final Matches opponent;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xF8F8F8F8),
          child: Column(children: [
            AppBarWaveHome(
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
              text: '    Find Match',
              suffixIconPath: '',
            ),
            const Text(
              'You',
              style: TextStyle(
                color: Color(0xFF313131),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: screenHeight * .02),
            MatchItem(match: match),
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Text(
                'Opponent',
                style: TextStyle(
                  color: Color(0xFF313131),
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            MatchItem(match: opponent),
            Center(
              // Wrap the IconButton in Center to center it horizontally
              child: SizedBox(
                height: 100,
                width: 100,
                child: IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.change_circle_rounded,
                    size: 70,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * .02),
            BottomSheetContainer(
                buttonText: 'Play',
                onPressed: () {},
                color: const Color(0xFFF8F8F8))
          ]),
        ),
      ),
    );
  }
}
