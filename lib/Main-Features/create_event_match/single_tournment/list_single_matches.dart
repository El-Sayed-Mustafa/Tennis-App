import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/create_event_match/services/firebase_method.dart';
import 'package:tennis_app/Main-Features/create_event_match/widgets/edit_single_match.dart';
import 'package:tennis_app/constants.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import 'package:tennis_app/core/utils/widgets/single_match_card%20copy.dart';
import 'package:tennis_app/models/single_match.dart';

class ListSingleMatches extends StatefulWidget {
  final List<SingleMatch> matches;
  final String tournamentId;

  const ListSingleMatches({
    Key? key,
    required this.matches,
    required this.tournamentId,
  }) : super(key: key);

  @override
  State<ListSingleMatches> createState() => _ListSingleMatchesState();
}

class _ListSingleMatchesState extends State<ListSingleMatches> {
  Future<void> _deleteMatchAndUpdateUI(String matchId) async {
    try {
      MatchesFirebaseMethod delete = MatchesFirebaseMethod();
      await delete.deleteSingleTournamentMatch(matchId, widget.tournamentId);

      // Update the UI by removing the deleted match from the list
      setState(() {
        widget.matches.removeWhere((match) => match.matchId == matchId);
      });
    } catch (error) {
      print('Error deleting match: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();

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
              itemCount: widget.matches.length,
              itemBuilder: (context, index) {
                final singleMatch = widget.matches[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: SizedBox(
                    height: carouselHeight,
                    child: Stack(
                      children: [
                        SingleMatchCard(
                          match: singleMatch,
                          tournamentId: widget.tournamentId,
                        ),
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditSingleMatch(
                                          match: singleMatch,
                                          tournamentId: widget.tournamentId,
                                        )),
                              );
                            },
                            icon: const Icon(
                              Icons.edit_document,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 5,
                          bottom: 5,
                          child: IconButton(
                            onPressed: () {
                              _deleteMatchAndUpdateUI(singleMatch.matchId);
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
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
