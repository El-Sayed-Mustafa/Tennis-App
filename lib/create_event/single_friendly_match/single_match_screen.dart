import 'package:flutter/material.dart';

import '../widgets/player_match_item.dart';

class SingleMatchScreen extends StatelessWidget {
  const SingleMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: PlayerMatchItem(),
    );
  }
}
