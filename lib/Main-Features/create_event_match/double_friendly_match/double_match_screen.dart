import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/create_event_match/double_friendly_match/player_match_item.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';

class DoubleMatchScreen extends StatelessWidget {
  const DoubleMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
            text: 'Double Match',
            suffixIconPath: '',
          ),
          SizedBox(height: screenHeight * .02),
          const Expanded(child: PlayerMatchItem()),
        ],
      ),
    );
  }
}
