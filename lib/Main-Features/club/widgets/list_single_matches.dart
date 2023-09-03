import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/constants.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import 'package:tennis_app/core/utils/widgets/single_match_card%20copy.dart';
import 'package:tennis_app/models/single_match.dart';

class ListSingleMatches extends StatelessWidget {
  final List<SingleMatch> matches;
  final String tournamentId;

  const ListSingleMatches({
    Key? key,
    required this.matches,
    required this.tournamentId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double carouselHeight = (screenHeight + screenWidth) * 0.18;

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
            text: 'Tournament Matches',
            suffixIconPath: '',
          ),
          Expanded(
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final singleMatch = matches[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: SizedBox(
                    height: carouselHeight,
                    child: Stack(
                      children: [
                        SingleMatchCard(
                          match: singleMatch,
                          tournamentId: tournamentId,
                        ),
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ListSingleMatches(
                                            matches: matches,
                                            tournamentId: tournamentId,
                                          )),
                                );
                              },
                              icon: const Icon(
                                Icons.edit_document,
                                size: 30,
                                color: Colors.black,
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
