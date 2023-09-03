import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/create_event_match/double_tournment/edit_double_match.dart';
import 'package:tennis_app/Main-Features/create_event_match/services/firebase_method.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/double_match_card.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import 'package:tennis_app/models/double_match.dart';

class ListDoubleMatches extends StatefulWidget {
  final List<DoubleMatch> matches;
  final String tournamentId;

  const ListDoubleMatches({
    Key? key,
    required this.matches,
    required this.tournamentId,
  }) : super(key: key);

  @override
  State<ListDoubleMatches> createState() => _ListDoubleMatchesState();
}

class _ListDoubleMatchesState extends State<ListDoubleMatches> {
  Future<void> _deleteMatchAndUpdateUI(String matchId) async {
    try {
      MatchesFirebaseMethod delete = MatchesFirebaseMethod();
      await delete.deleteDoubleTournamentMatch(matchId, widget.tournamentId);

      // Update the UI by removing the deleted match from the list
      setState(() {
        widget.matches.removeWhere((match) => match.matchId == matchId);
      });
    } catch (error) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Error while deleting');
    }
  }

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
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: widget.matches.length,
              itemBuilder: (context, index) {
                final DoubleMatch = widget.matches[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: SizedBox(
                    height: carouselHeight,
                    child: Stack(
                      children: [
                        DoubleMatchCard(
                          match: DoubleMatch,
                          tournamentId: widget.tournamentId,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditDoubleMatch(
                                          match: DoubleMatch,
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
                          left: 0,
                          bottom: 0,
                          child: IconButton(
                            onPressed: () {
                              _deleteMatchAndUpdateUI(DoubleMatch.matchId);
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
