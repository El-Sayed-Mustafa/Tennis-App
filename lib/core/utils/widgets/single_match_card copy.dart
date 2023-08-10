import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package

import '../../../models/single_match.dart';
import '../../../models/player.dart';

class SingleMatchCard extends StatelessWidget {
  final SingleMatch match;

  SingleMatchCard({Key? key, required this.match}) : super(key: key);

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
      print('Error fetching player: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Player?>>(
      future: Future.wait(
          [fetchPlayer(match.player1Id), fetchPlayer(match.player2Id)]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.length < 2) {
          return const Text('Error loading player data');
        } else {
          final player1 = snapshot.data![0]!;
          final player2 = snapshot.data![1]!;

          // Format date and time
          final formattedTime = DateFormat('hh:mm a').format(match.startTime);
          final formattedDate =
              DateFormat('dd/MM/yyyy').format(match.startTime);

          return Container(
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
                          PhotoPlayer(url: player1.photoURL!),
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
                        ],
                      ), // Display player1's name
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Image.asset('assets/images/versus.png'),
                      ),
                      Column(
                        children: [
                          PhotoPlayer(url: player2.photoURL!),
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
                      ), // Display player2's name
                    ],
                  ),
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
                ) // Display formatted time and date
              ],
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
