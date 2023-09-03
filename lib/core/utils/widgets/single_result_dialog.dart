import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showWinnerDialog(method, context, match, tournamentId) async {
  TextEditingController teamAScoreController = TextEditingController();
  TextEditingController teamBScoreController = TextEditingController();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Select Winners'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: teamAScoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Team A',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Add spacing between text fields
                Expanded(
                  child: TextFormField(
                    controller: teamBScoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Team B',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Color.fromARGB(255, 34, 47, 53), // Set the background color
              ),
              onPressed: () async {
                GoRouter.of(context).pop();
                if (match.result.isNotEmpty) {
                  List<String> scores = match.result.split(':');

// Trim and parse the extracted scores as integers
                  int teamAScore = int.tryParse(scores[0].trim()) ?? 0;
                  int teamBScore = int.tryParse(scores[1].trim()) ?? 0;

                  if (teamAScore > teamBScore) {
                    await method.reEnterResult(match.player1Id, true);
                    await method.reEnterResult(match.player2Id, false);
                  } else if (teamBScore > teamAScore) {
                    await method.reEnterResult(match.player1Id, false);
                    await method.reEnterResult(match.player2Id, true);
                  } else {
                    await method.reEnterResult(match.player1Id, false);
                    await method.reEnterResult(match.player2Id, false);
                  }
                }
                int teamAScore = int.tryParse(teamAScoreController.text) ?? 0;
                int teamBScore = int.tryParse(teamBScoreController.text) ?? 0;
                String result;
                result = '$teamAScore : $teamBScore';
                if (teamAScore > teamBScore) {
                  if (tournamentId != null) {
                    await FirebaseFirestore.instance
                        .collection('singleTournaments')
                        .doc(tournamentId)
                        .collection('singleMatches')
                        .doc(match.matchId)
                        .update({
                      'winner': 'A Winner',
                      'result': result,
                    });
                  } else {
                    await FirebaseFirestore.instance
                        .collection('single_matches')
                        .doc(match.matchId)
                        .update({
                      'winner': 'A Winner',
                      'result': result,
                    });
                  }
                  await method.updateMatchPlayedAndTotalWins(
                      match.player1Id, true);
                  await method.updateMatchPlayedAndTotalWins(
                      match.player2Id, false);
                } else if (teamBScore > teamAScore) {
                  if (tournamentId != null) {
                    await FirebaseFirestore.instance
                        .collection('singleTournaments')
                        .doc(tournamentId)
                        .collection('singleMatches')
                        .doc(match.matchId)
                        .update({
                      'winner': 'B Winner',
                      'result': result,
                    });
                  } else {
                    await FirebaseFirestore.instance
                        .collection('single_matches')
                        .doc(match.matchId)
                        .update({
                      'winner': 'B Winner',
                      'result': result,
                    });
                  }

                  await method.updateMatchPlayedAndTotalWins(
                      match.player2Id, true);
                  await method.updateMatchPlayedAndTotalWins(
                      match.player1Id, false);
                } else {
                  if (tournamentId != null) {
                    await FirebaseFirestore.instance
                        .collection('singleTournaments')
                        .doc(tournamentId)
                        .collection('singleMatches')
                        .doc(match.matchId)
                        .update({
                      'winner': 'Draw',
                      'result': result,
                    });
                  } else {
                    await FirebaseFirestore.instance
                        .collection('single_matches')
                        .doc(match.matchId)
                        .update({
                      'winner': 'Draw',
                      'result': result,
                    });
                  }
                  await method.updateMatchPlayedAndTotalWins(
                      match.player1Id, false);
                  await method.updateMatchPlayedAndTotalWins(
                      match.player2Id, false);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      );
    },
  );
}
