import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/create_event_match/widgets/button_match_item.dart';
import 'package:tennis_app/generated/l10n.dart';

import '../../core/utils/widgets/pop_app_bar.dart';

class CreateEventMatchesScreen extends StatelessWidget {
  const CreateEventMatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            text: S.of(context).createMatch,
            suffixIconPath: '',
          ),
          ButtonMatchItem(
            icon: Icons.switch_access_shortcut_add_outlined,
            color: const Color(0x5172B8FF),
            text: S.of(context).singleMatch,
            onPressed: () {
              GoRouter.of(context).push('/singleMatches');
            },
          ),
          ButtonMatchItem(
            icon: Icons.personal_injury_outlined,
            color: const Color(0x51EE746C),
            text: S.of(context).doubleMatch,
            onPressed: () {
              GoRouter.of(context).push('/doubleMatches');
            },
          ),
          ButtonMatchItem(
            icon: Icons.transcribe_sharp,
            color: const Color(0x8294D3D3),
            text: S.of(context).singleTournament,
            onPressed: () {
              GoRouter.of(context).push('/singleTournament');
            },
          ),
          ButtonMatchItem(
            icon: Icons.change_circle_rounded,
            color: const Color(0x51FFA372),
            text: S.of(context).doubleTournament,
            onPressed: () {
              GoRouter.of(context).push('/doubleTournament');
            },
          ),
        ],
      ),
    );
  }
}
