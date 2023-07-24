import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/club_managment/view/widgets/member_item.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../models/Match.dart';
import '../widgets/match_item.dart';

class PeopleRequirement extends StatelessWidget {
  PeopleRequirement({super.key, required this.match});
  final Matches match;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xF8F8F8F8),
        child: Column(
          children: [
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
              'Your Requirements',
              style: TextStyle(
                color: Color(0xFF313131),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            //TODO: add member
            Expanded(
                child: SingleChildScrollView(child: MatchItem(match: match))),
            Text(
              match.clubName,
              style: const TextStyle(
                color: Color(0xFF313131),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
