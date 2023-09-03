// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/photot_player.dart';
import 'package:tennis_app/models/double_match.dart';
import '../../../models/player.dart';
import '../../methodes/firebase_methodes.dart';

class DoubleMatchCard extends StatefulWidget {
  final DoubleMatch match;
  final String? tournamentId;
  const DoubleMatchCard({Key? key, required this.match, this.tournamentId})
      : super(key: key);

  @override
  State<DoubleMatchCard> createState() => _DoubleMatchCardState();
}

class _DoubleMatchCardState extends State<DoubleMatchCard> {
  Method method = Method();

  Future<List<Player?>> fetchPlayers(List<String> playerIds) async {
    List<Player?> players = [];
    Stream<DocumentSnapshot<Map<String, dynamic>>> getMatchStream() {
      return FirebaseFirestore.instance
          .collection('doubleTournaments')
          .doc(widget.tournamentId)
          .collection('doubleMatches')
          .doc(widget.match.matchId)
          .snapshots();
    }

    try {
      for (String playerId in playerIds) {
        DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
            await FirebaseFirestore.instance
                .collection('players')
                .doc(playerId)
                .get();
        if (playerSnapshot.exists) {
          players.add(Player.fromSnapshot(playerSnapshot));
        } else {
          players.add(null);
        }
      }
    } catch (e) {
      SnackBar(content: Text('Error fetching players: $e'));
    }
    return players;
  }

  String? _selectedWinner1;

  Future<void> _showWinnerDialog() async {
    TextEditingController teamAScoreController = TextEditingController();
    TextEditingController teamBScoreController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Enter Results')),
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

                  int teamAScore = int.tryParse(teamAScoreController.text) ?? 0;
                  int teamBScore = int.tryParse(teamBScoreController.text) ?? 0;
                  String result;
                  result = '$teamAScore : $teamBScore';
                  if (teamAScore > teamBScore) {
                    if (widget.tournamentId != null) {
                      await FirebaseFirestore.instance
                          .collection('doubleTournaments')
                          .doc(widget.tournamentId)
                          .collection('doubleMatches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner1': 'Team A Winner',
                        'result': result,
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('double_matches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner1': 'Team A Winner',
                        'result': result,
                      });
                    }
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player1Id, true);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player2Id, true);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player3Id, false);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player4Id, false);
                  } else if (teamBScore > teamAScore) {
                    if (widget.tournamentId != null) {
                      await FirebaseFirestore.instance
                          .collection('doubleTournaments')
                          .doc(widget.tournamentId)
                          .collection('doubleMatches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner1': 'Team B Winner',
                        'result': result,
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('double_matches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner1': 'Team B Winner',
                        'result': result,
                      });
                    }
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player3Id, true);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player4Id, true);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player1Id, false);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player2Id, false);
                  } else {
                    if (widget.tournamentId != null) {
                      await FirebaseFirestore.instance
                          .collection('doubleTournaments')
                          .doc(widget.tournamentId)
                          .collection('doubleMatches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner1': 'Draw',
                        'result': result,
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('double_matches')
                          .doc(widget.match.matchId)
                          .update({
                        'winner1': 'Draw',
                        'result': result,
                      });
                    }
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player1Id, false);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player2Id, false);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player3Id, false);
                    await method.updateMatchPlayedAndTotalWins(
                        widget.match.player4Id, false);
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
    final double screenWidth = MediaQuery.of(context).size.width;
    ScreenUtil.init(context, designSize: const Size(360, 690));

    return FutureBuilder<List<Player?>>(
      future: fetchPlayers([
        widget.match.player1Id,
        widget.match.player2Id,
        widget.match.player3Id,
        widget.match.player4Id
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.length < 4) {
          return const Text('Error loading player data');
        } else {
          final player1 = snapshot.data![0];
          final player2 = snapshot.data![1];
          final player3 = snapshot.data![2];
          final player4 = snapshot.data![3];

          // Format date and time
          final formattedTime =
              DateFormat('hh:mm a').format(widget.match.startTime);
          final formattedDate =
              DateFormat('dd/MM/yyyy').format(widget.match.startTime);

          return GestureDetector(
            onTap: () async {
              bool hasRight = await method.doesPlayerHaveRight('Enter Results');
              if (hasRight) {
                if (widget.match.result.isNotEmpty) {
                  return showSnackBar(context, 'The Result is already entered');
                }
                _showWinnerDialog();
              }
            },
            child: Container(
              decoration: ShapeDecoration(
                color: const Color(0xFFFCCBB1),
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
                            const Text("Team A",
                                style: TextStyle(
                                  color: Color(0xFF2A2A2A),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 10),
                            PhotoPlayer(url: player1!.photoURL!),
                            const SizedBox(height: 5),
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
                            const SizedBox(height: 15),
                            PhotoPlayer(url: player2!.photoURL!),
                            const SizedBox(height: 5),
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
                        ), // Display player1's name
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedWinner1 ?? widget.match.winner1,
                              style: TextStyle(
                                color: Color(0xFF00344E),
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.asset('assets/images/versus.png'),
                              ),
                            ),
                            Text(
                              '$formattedTime\n$formattedDate',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF00344E),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                color: Color.fromARGB(255, 34, 47, 53),
                                child: Text(
                                  _selectedWinner1 ?? widget.match.result,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
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
                            const Text("Team B",
                                style: TextStyle(
                                  color: Color(0xFF2A2A2A),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                )),
                            const SizedBox(height: 10),
                            PhotoPlayer(url: player3!.photoURL!),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: screenWidth * 0.18,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  player3.playerName,
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
                            const SizedBox(height: 15),
                            PhotoPlayer(url: player4!.photoURL!),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: screenWidth * 0.18,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  player4.playerName,
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
