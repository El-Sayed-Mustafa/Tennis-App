// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/double_match_card.dart';
import 'package:tennis_app/core/utils/widgets/no_data_text.dart';
import '../../../generated/l10n.dart';
import '../../../models/double_match.dart';
import '../../../models/player.dart';

class MyDoubleMatches extends StatefulWidget {
  const MyDoubleMatches({Key? key}) : super(key: key);

  @override
  State<MyDoubleMatches> createState() => _MyDoubleMatchesState();
}

class _MyDoubleMatchesState extends State<MyDoubleMatches> {
  int selectedPageIndex = 0;
  final CarouselController _carouselController = CarouselController();
  List<String> matches = []; // List to store matches data

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
        showSnackBar(context, 'No user is currently signed in.');
        return;
      }

      String currentUserId = currentUser.uid;

      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(currentUserId)
              .get();

      if (!playerSnapshot.exists) {
        showSnackBar(
            context, 'Player document does not exist for current user.');
        return;
      }

      // Create a Player instance from the snapshot data
      Player currentPlayer = Player.fromSnapshot(playerSnapshot);

      // Get the matches data from the Player instance
      matches = currentPlayer.doubleMatchesIds;

      // Update the carousel with the fetched data
      setState(() {});
    } catch (error) {
      showSnackBar(context, 'Error fetching matches data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double carouselHeight = (screenHeight + screenWidth) * 0.2;

    return Column(
      children: [
        matches.isNotEmpty
            ? CarouselSlider(
                options: CarouselOptions(
                  height: matches.isNotEmpty
                      ? carouselHeight
                      : 0, // Set height based on matches list
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.75,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                ),
                carouselController: _carouselController,
                items: matches.map((matchData) {
                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('double_matches')
                        .doc(matchData)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(S.of(context).Error_fetching_match_data);
                      }

                      if (!snapshot.hasData) {
                        return Center(child: const CircularProgressIndicator());
                      }

                      final courtData = snapshot.data?.data();
                      if (courtData == null) {
                        return Center(
                          child: NoData(
                            text: S.of(context).You_Dont_have_Matches,
                            buttonText: S.of(context).clickToCreateMatch,
                            onPressed: () {
                              GoRouter.of(context).push('/findPartner');
                            },
                            height: screenHeight * .15,
                            width: screenWidth * .8,
                          ),
                        );
                      }

                      // Create a Matches instance from the snapshot data
                      final match = DoubleMatch.fromFirestore(snapshot.data!);

                      // Build the carousel item using the MatchItem widget
                      return DoubleMatchCard(match: match);
                    },
                  );
                }).toList(),
              )
            : NoData(
                text: S.of(context).You_Dont_have_Matches,
                buttonText: S.of(context).clickToCreateMatch,
                onPressed: () {
                  GoRouter.of(context).push('/findPartner');
                },
                height: screenHeight * .15,
                width: screenWidth * .8,
              ),
      ],
    );
  }
}
