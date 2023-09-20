// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/create_event_match/services/firebase_method.dart';
import 'package:tennis_app/Main-Features/create_event_match/single_tournment/edit_single_match.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/methodes/roles_manager.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/confirmation_dialog.dart';
import 'package:tennis_app/core/utils/widgets/custom_dialouge.dart';
import 'package:tennis_app/core/utils/widgets/no_data_text.dart';
import 'package:tennis_app/models/single_match.dart';
import '../../../core/utils/widgets/single_match_card copy.dart';
import '../../../generated/l10n.dart';
import '../../../models/player.dart';

class ClubSingleMatches extends StatefulWidget {
  const ClubSingleMatches({Key? key}) : super(key: key);

  @override
  State<ClubSingleMatches> createState() => _ClubSingleMatchesState();
}

class _ClubSingleMatchesState extends State<ClubSingleMatches> {
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
        showSnackBar(context, S.of(context).NoUserIsCurrentlySignedIn);
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
            context, S.of(context).PlayerDocumentDoesNotExistForCurrentUser);
        return;
      }

      // Create a Player instance from the snapshot data
      Player currentPlayer = Player.fromSnapshot(playerSnapshot);

      Method methodes = Method();
      final clubData =
          await methodes.fetchClubData(currentPlayer.participatedClubId);
// Get the matches data from the Club instance
      matches = clubData.singleMatchesIds;

      // Update the carousel with the fetched data
      setState(() {});
    } catch (error) {
      showSnackBar(
          context, ' ${S.of(context).ErrorFetchingMatchesData} $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double carouselHeight = (screenHeight + screenWidth) * 0.22;
    Method method = Method();

    return Column(
      children: [
        matches.isNotEmpty
            ? Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: matches.isNotEmpty
                          ? carouselHeight
                          : 0, // Set height based on matches list
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.85,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: false,
                    ),
                    carouselController: _carouselController,
                    items: matches.map((matchData) {
                      return StreamBuilder<
                          DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('single_matches')
                            .doc(matchData)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                S.of(context).Error_fetching_match_data);
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final courtData = snapshot.data?.data();
                          if (courtData == null) {
                            return Center(
                              child: SizedBox(
                                child: NoData(
                                  text: S.of(context).You_Dont_have_Matches,
                                  buttonText: S.of(context).clickToCreateMatch,
                                  onPressed: () async {
                                    bool hasRight = await RolesManager.instance
                                        .doesPlayerHaveRight('Create Match');
                                    if (hasRight) {
                                      GoRouter.of(context).push('/createMatch');
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) => CustomDialog(
                                          text: S.of(context).noRightMessage,
                                        ),
                                      );
                                    }
                                  },
                                  height: screenHeight * .2,
                                  width: screenWidth * .8,
                                ),
                              ),
                            );
                          }

                          // Create a Matches instance from the snapshot data
                          final match =
                              SingleMatch.fromFirestore(snapshot.data!);

                          // Build the carousel item using the MatchItem widget
                          return Stack(
                            children: [
                              SingleMatchCard(match: match),
                              Positioned(
                                right: 0,
                                bottom: 15,
                                child: IconButton(
                                    onPressed: () async {
                                      bool hasRight = await method
                                          .doesPlayerHaveRight('Edit Match');
                                      if (hasRight) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditSingleMatch(
                                                    match: match,
                                                    tournamentId: '',
                                                  )),
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => CustomDialog(
                                            text: S.of(context).noRightMessage,
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 25,
                                      color: Colors.black,
                                    )),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 15,
                                child: IconButton(
                                    onPressed: () async {
                                      bool hasRight = await method
                                          .doesPlayerHaveRight('Delete Match');
                                      if (hasRight) {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (BuildContext dialogContext) {
                                            return ConfirmationDialog(
                                              title: S.of(context).Confirm,
                                              content: S
                                                  .of(context)
                                                  .AreYouSureYouWantToDeleteThisMatch,
                                              confirmText: S.of(context).Delete,
                                              cancelText: S.of(context).cancel,
                                              onConfirm: () async {
                                                MatchesFirebaseMethod delete =
                                                    MatchesFirebaseMethod();
                                                await delete.deleteSingleMatch(
                                                    match.matchId);
                                                setState(() {});
                                              },
                                            );
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) => CustomDialog(
                                            text: S.of(context).noRightMessage,
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 25,
                                      color: Colors.black,
                                    )),
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              )
            : NoData(
                text: S.of(context).You_Dont_have_Matches,
                buttonText: S.of(context).clickToCreateMatch,
                onPressed: () async {
                  bool hasRight = await RolesManager.instance
                      .doesPlayerHaveRight('Create Match');
                  if (hasRight) {
                    GoRouter.of(context).push('/createMatch');
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                        text: S.of(context).noRightMessage,
                      ),
                    );
                  }
                },
                height: screenHeight * .2,
                width: screenWidth * .8,
              ),
      ],
    );
  }
}
