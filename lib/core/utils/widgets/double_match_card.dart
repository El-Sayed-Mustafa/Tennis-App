import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:tennis_app/models/double_match.dart';

import '../../../models/single_match.dart';
import '../../../models/player.dart';

class DoubleMatchCard extends StatefulWidget {
  final DoubleMatch match;
  final String? tournamentId;
  const DoubleMatchCard({Key? key, required this.match, this.tournamentId})
      : super(key: key);

  @override
  State<DoubleMatchCard> createState() => _DoubleMatchCardState();
}

class _DoubleMatchCardState extends State<DoubleMatchCard> {
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
      print('Error fetching players: $e');
    }
    return players;
  }

  String? _selectedWinner1;
  String? _selectedWinner2;

  Future<void> _showWinnerDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Winners'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Team A Winner'),
                onTap: () async {
                  setState(() {
                    _selectedWinner1 = 'Team A Winner';
                  });
                  await FirebaseFirestore.instance
                      .collection('doubleTournaments')
                      .doc(widget.tournamentId)
                      .collection('doubleMatches')
                      .doc(widget.match.matchId)
                      .update({
                    'winner1': 'Team A Winner',
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Team B Winner'),
                onTap: () async {
                  setState(() {
                    _selectedWinner1 = 'Team B Winner';
                  });
                  await FirebaseFirestore.instance
                      .collection('doubleTournaments')
                      .doc(widget.tournamentId)
                      .collection('doubleMatches')
                      .doc(widget.match.matchId)
                      .update({
                    'winner1': 'Team B Winner',
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('Draw'),
                onTap: () async {
                  setState(() {
                    _selectedWinner1 = 'Draw';
                  });
                  await FirebaseFirestore.instance
                      .collection('doubleTournaments')
                      .doc(widget.tournamentId)
                      .collection('doubleMatches')
                      .doc(widget.match.matchId)
                      .update({
                    'winner1': 'Draw',
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTeamAWinner = _selectedWinner1 == 'Team A Winner';

    final isTeamBWinner = _selectedWinner1 == 'Team B Winner';

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
            onTap: () {
              _showWinnerDialog();
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
                            if (isTeamAWinner)
                              const Text("Winner",
                                  style: TextStyle(
                                      color:
                                          Colors.green)), // Customize as needed

                            PhotoPlayer(url: player1!.photoURL!),
                            const SizedBox(height: 10),
                            Text(
                              player1.playerName,
                              style: const TextStyle(
                                color: Color(0xFF2A2A2A),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15),
                            PhotoPlayer(url: player2!.photoURL!),
                            const SizedBox(height: 10),
                            Text(
                              player2.playerName,
                              style: const TextStyle(
                                color: Color(0xFF2A2A2A),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ), // Display player1's name
                        Column(
                          children: [
                            Text(_selectedWinner1 ?? widget.match.winner1),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: Image.asset('assets/images/versus.png'),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '$formattedTime\n$formattedDate',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF00344E),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            if (isTeamBWinner)
                              const Text("Winner",
                                  style: TextStyle(
                                      color:
                                          Colors.green)), // Customize as needed

                            PhotoPlayer(url: player3!.photoURL!),
                            const SizedBox(height: 10),
                            Text(
                              player3.playerName,
                              style: const TextStyle(
                                color: Color(0xFF2A2A2A),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 15),
                            PhotoPlayer(url: player4!.photoURL!),
                            const SizedBox(height: 10),
                            Text(
                              player4.playerName,
                              style: const TextStyle(
                                color: Color(0xFF2A2A2A),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ), // Display player2's name
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

class PhotoPlayer extends StatelessWidget {
  final String url;

  const PhotoPlayer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenHeight * 0.065,
      height: screenHeight * 0.065,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: (url != null
            ? FadeInImage.assetNetwork(
                placeholder: 'assets/images/loadin.gif',
                image: url,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/profile-event.jpg',
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.asset(
                'assets/images/internet.png',
                fit: BoxFit.cover,
              )),
      ),
    );
  }
}
