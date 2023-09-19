import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';

import 'player_match_item.dart';

class SingleMatchScreen extends StatelessWidget {
  const SingleMatchScreen({super.key});

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
            text: 'S',
            suffixIconPath: '',
          ),
          SizedBox(height: screenHeight * .02),
          Expanded(child: const PlayerMatchItem()),
        ],
      ),
    );
  }
}
