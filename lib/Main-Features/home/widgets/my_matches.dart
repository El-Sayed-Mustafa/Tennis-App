import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tennis_app/Main-Features/Featured/find_match/view/widgets/match_item.dart';

import '../../../core/utils/widgets/court_item.dart';
import '../../../models/Match.dart';
import '../../../models/player.dart';
import '../../../models/court.dart'; // Import the Court class

class MyMatches extends StatefulWidget {
  const MyMatches({Key? key}) : super(key: key);

  @override
  State<MyMatches> createState() => _MyMatchesState();
}

class _MyMatchesState extends State<MyMatches> {
  int selectedPageIndex = 0;
  final CarouselController _carouselController = CarouselController();
  List<Map<String, dynamic>> matches = []; // List to store matches data

  @override
  void initState() {
    super.initState();
    _fetchMatches(); // Fetch matches data when the widget initializes
  }

  // Fetch the player data from Firestore and extract matches data
  void _fetchMatches() async {
    try {
      // Fetch the current user's player data from Firestore
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No user is currently signed in.');
        return;
      }

      String currentUserId = currentUser.uid;

      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(currentUserId)
              .get();

      if (!playerSnapshot.exists) {
        print('Player document does not exist for current user.');
        return;
      }

      // Create a Player instance from the snapshot data
      Player currentPlayer = Player.fromSnapshot(playerSnapshot);

      // Get the matches data from the Player instance
      matches = currentPlayer.matches;

      // Update the carousel with the fetched data
      setState(() {});
    } catch (error) {
      print('Error fetching matches data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double carouselHeight = screenHeight * 0.25;

    return Column(
      children: [
        matches.isNotEmpty
            ? CarouselSlider(
                options: CarouselOptions(
                  height: carouselHeight,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: (index, _) {
                    setState(() {
                      selectedPageIndex = index;
                    });
                  },
                ),
                carouselController: _carouselController,
                items: matches.map((matchData) {
                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('matches')
                        .doc(matchData['matchId'])
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error fetching match data');
                      }

                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      final courtData = snapshot.data?.data();
                      if (courtData == null) {
                        return Center(child: Text('No match data available'));
                      }

                      // Create a Matches instance from the snapshot data
                      final Matches match =
                          Matches.fromSnapshot(snapshot.data!);

                      // Build the carousel item using the MatchItem widget
                      return MatchItem(match: match);
                    },
                  );
                }).toList(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No matches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

        buildPageIndicator(matches.length), // Add the smooth page indicator
      ],
    );
  }

  Widget buildPageIndicator(int itemCount) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) {
          final bool isSelected = selectedPageIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 11 : 9,
            height: isSelected ? 11 : 9,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.011),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
