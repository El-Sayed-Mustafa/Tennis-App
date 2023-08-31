import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/photot_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/single_match.dart';
import '../../../models/player.dart';
import '../../methodes/firebase_methodes.dart';

class SingleMatchCard extends StatefulWidget {
  final SingleMatch match;
  final String? tournamentId;

  SingleMatchCard({Key? key, required this.match, this.tournamentId})
      : super(key: key);

  @override
  State<SingleMatchCard> createState() => _SingleMatchCardState();
}

class _SingleMatchCardState extends State<SingleMatchCard> {
  Method method = Method();
  String? _selectedWinner1;

  Future<Player?> fetchPlayer(String playerId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(playerId)
              .get();
      if (playerSnapshot.exists) {
        return Player.fromSnapshot(playerSnapshot);
      }
    } catch (e) {
      SnackBar(content: Text('Error fetching player: $e'));
    }
    return null;
  }

  Future<void> _showWinnerDialog() async {
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
                  backgroundColor: Color.fromARGB(
                      255, 34, 47, 53), // Set the background color
                ),
                onPressed: () async {
                  GoRouter.of(context).pop();
                  if (widget.match.result.isNotEmpty) {
                    List<String> scores = widget.match.result.split(':');

// Trim and parse the extracted scores as integers
                    int teamAScore = int.tryParse(scores[0].trim()) ?? 0;
                    int teamBScore = int.tryParse(scores[1].trim()) ?? 0;

                    if (teamAScore > teamBScore) {
                      await method.reEnterResult(widget.match.player1Id, true);
                      await method.reEnterResult(widget.match.player2Id, false);
                    } else if (teamBScore > teamAScore) {
                      await method.reEnterResult(widget.match.player1Id, false);
                      await method.reEnterResult(widget.match.player2Id, true);
                    } else {
                      await method.reEnterResult(widget.match.player1Id, false);
                      await method.reEnterResult(widget.match.player2Id, false);
                    }
                  }
                  int teamAScore = int.tryParse(teamAScoreController.text) ?? 0;
                  int teamBScore = int.tryParse(teamBScoreController.text) ?? 0;
                  String winner;
                  String result;
                  result = '$teamAScore : $teamBScore';
                  if (teamAScore > teamBScore) {
                    winner = 'Team A Winner';
                    if (widget.tournamentId != null) {
                      await FirebaseFirestore.instance
                          .collection('singleTournaments')
                          .doc(widget.tournamentId)
                          .collection('singleMatches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner': 'A Winner',
                        'result': result,
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('single_matches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner': 'A Winner',
                        'result': result,
                      });
                    }
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player1Id, true);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player2Id, false);
                  } else if (teamBScore > teamAScore) {
                    if (widget.tournamentId != null) {
                      await FirebaseFirestore.instance
                          .collection('singleTournaments')
                          .doc(widget.tournamentId)
                          .collection('singleMatches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner': 'B Winner',
                        'result': result,
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('single_matches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner': 'B Winner',
                        'result': result,
                      });
                    }

                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player2Id, true);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player1Id, false);
                  } else {
                    winner = 'Draw';

                    if (widget.tournamentId != null) {
                      await FirebaseFirestore.instance
                          .collection('singleTournaments')
                          .doc(widget.tournamentId)
                          .collection('singleMatches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner': 'Draw',
                        'result': result,
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('single_matches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner': 'Draw',
                        'result': result,
                      });
                    }
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player1Id, false);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player2Id, false);
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

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));

    final double screenWidth = MediaQuery.of(context).size.width;
    return FutureBuilder<List<Player?>>(
      future: Future.wait([
        fetchPlayer(widget.match.player1Id),
        fetchPlayer(widget.match.player2Id)
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.length < 2) {
          return const Text('Error loading player data');
        } else {
          final player1 = snapshot.data![0]!;
          final player2 = snapshot.data![1]!;

          // Format date and time
          final formattedTime =
              DateFormat('hh:mm a').format(widget.match.startTime);
          final formattedDate =
              DateFormat('dd/MM/yyyy').format(widget.match.startTime);

          return GestureDetector(
            onTap: () async {
              bool hasRight = await method.doesPlayerHaveRight('Enter Results');
              if (hasRight) {
                _showWinnerDialog();
              }
            },
            child: Container(
              decoration: ShapeDecoration(
                color: Color(0xFFF3ADAB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(31),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text("Player A",
                                style: TextStyle(
                                  color: Color(0xFF2A2A2A),
                                  fontSize: 16.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 10),
                            PhotoPlayer(url: player1.photoURL!),
                            const SizedBox(height: 7),
                            SizedBox(
                              width: screenWidth * 0.18,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  player1.playerName,
                                  style: const TextStyle(
                                    color: Color(0xFF2A2A2A),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ), // Display player1's name
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedWinner1 ?? widget.match.winner,
                              style: TextStyle(
                                color: Color(0xFF00344E),
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(6.0.h),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.asset('assets/images/versus.png'),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                color: Color.fromARGB(255, 34, 47, 53),
                                child: Text(
                                  _selectedWinner1 ?? widget.match.result,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("Player B",
                                style: TextStyle(
                                  color: Color(0xFF2A2A2A),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 10),
                            PhotoPlayer(url: player2.photoURL!),
                            const SizedBox(height: 7),
                            SizedBox(
                              width: screenWidth * 0.18,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  player2.playerName,
                                  style: const TextStyle(
                                    color: Color(0xFF2A2A2A),
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ), // Display player2's name
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),

                  Text(
                    '$formattedTime\n$formattedDate',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF00344E),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ) // Display formatted time and date
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
