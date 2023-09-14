import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/generated/l10n.dart';

Future<void> showWinnerDialog(method, context, match, tournamentId) async {
  TextEditingController teamAScoreController1 = TextEditingController();
  TextEditingController teamAScoreController2 = TextEditingController();
  TextEditingController teamAScoreController3 = TextEditingController();
  TextEditingController teamAScoreController4 = TextEditingController();
  TextEditingController teamAScoreController5 = TextEditingController();
  TextEditingController teamBScoreController1 = TextEditingController();
  TextEditingController teamBScoreController2 = TextEditingController();
  TextEditingController teamBScoreController3 = TextEditingController();
  TextEditingController teamBScoreController4 = TextEditingController();
  TextEditingController teamBScoreController5 = TextEditingController();

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(S.of(context).selectWinners),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: teamAScoreController1,
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
                    controller: teamBScoreController1,
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: teamAScoreController2,
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
                    controller: teamBScoreController2,
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: teamAScoreController3,
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
                    controller: teamBScoreController3,
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: teamAScoreController4,
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
                    controller: teamBScoreController4,
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: teamAScoreController5,
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
                    controller: teamBScoreController5,
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
                int teamAScore1 = int.tryParse(teamAScoreController1.text) ?? 0;
                int teamBScore1 = int.tryParse(teamBScoreController1.text) ?? 0;
                int teamAScore2 = int.tryParse(teamAScoreController2.text) ?? 0;
                int teamBScore2 = int.tryParse(teamBScoreController2.text) ?? 0;
                int teamAScore3 = int.tryParse(teamAScoreController3.text) ?? 0;
                int teamBScore3 = int.tryParse(teamBScoreController3.text) ?? 0;
                int teamAScore4 = int.tryParse(teamAScoreController4.text) ?? 0;
                int teamBScore4 = int.tryParse(teamBScoreController4.text) ?? 0;
                int teamAScore5 = int.tryParse(teamAScoreController5.text) ?? 0;
                int teamBScore5 = int.tryParse(teamBScoreController5.text) ?? 0;

                int teamAScore = teamAScore1 +
                    teamAScore2 +
                    teamAScore3 +
                    teamAScore4 +
                    teamAScore5;
                int teamBScore = teamBScore1 +
                    teamBScore2 +
                    teamBScore3 +
                    teamBScore4 +
                    teamAScore5;

                String result;
                result =
                    '$teamAScore1 : $teamBScore1 \n$teamAScore2 : $teamBScore2 \n$teamAScore3 : $teamBScore3 \n$teamAScore4 : $teamBScore4 \n$teamAScore5 : $teamBScore5';

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
              child: Text(S.of(context).submit),
            ),
          ],
        ),
      );
    },
  );
}
