import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_app/create_event/double_friendly_match/player_match_item.dart';

import '../../Main-Features/Featured/create_event/view/widgets/input_end_date.dart';

class DoubleMatchScreen extends StatelessWidget {
  const DoubleMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlayerMatchItem(),
    );
  }
}
