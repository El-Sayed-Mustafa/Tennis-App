// ignore_for_file: unnecessary_null_comparison

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/create_event_match/single_tournment/list_single_matches.dart';
import 'package:tennis_app/constants.dart';
import 'package:tennis_app/models/single_match.dart'; // Replace with your model
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/methodes/firebase_methodes.dart';
import '../../../core/utils/widgets/single_match_card copy.dart';
import '../../../generated/l10n.dart';
import '../../../models/club.dart';
import '../../../models/player.dart'; // Replace with your model

class VerticalCarouselSlider extends StatelessWidget {
  final List<SingleMatch> matches;
  final String tournamentId;

  const VerticalCarouselSlider(
      {super.key, required this.matches, required this.tournamentId});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double carouselHeight = (screenHeight + screenWidth) * 0.2;

    return CarouselSlider(
      options: CarouselOptions(
        height: matches.isNotEmpty
            ? carouselHeight * 1.25
            : 0, // Set height based on matches list
        aspectRatio: 16 / 9,
        viewportFraction: .85,
        initialPage: 0,
        enableInfiniteScroll: false,
        enlargeCenterPage: false, scrollDirection: Axis.vertical,
      ),
      items: matches.map((match) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              SingleMatchCard(
                tournamentId: tournamentId,
                match: match,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ListSingleMatches(
                                  matches: matches,
                                  tournamentId: tournamentId,
                                )),
                      );
                    },
                    icon: const Icon(
                      Icons.info_outline,
                      size: 30,
                      color: kPrimaryColor,
                    )),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class SingleTournamentsClub extends StatelessWidget {
  const SingleTournamentsClub({Key? key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double carouselHeight = (screenHeight + screenWidth) * 0.18;

    Method methodes = Method();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('singleTournaments')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tournamentDocs = snapshot.data!.docs;

        return FutureBuilder<Player>(
          future: methodes.getCurrentUser(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final currentPlayer = userSnapshot.data!;
            final clubId = currentPlayer.participatedClubId;

            return FutureBuilder<Club>(
              future: methodes.fetchClubData(clubId),
              builder: (context, clubSnapshot) {
                if (!clubSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final clubData = clubSnapshot.data!;
                final singleTournamentsIds = clubData.singleTournamentsIds;

                if (singleTournamentsIds == null ||
                    singleTournamentsIds.isEmpty) {
                  return Container();
                }

                final filteredTournamentDocs = tournamentDocs.where((doc) {
                  final tournamentData = doc.data();
                  if (tournamentData == null) {
                    return false;
                  }
                  final tournamentId = doc.id;
                  return singleTournamentsIds.contains(tournamentId);
                }).toList();

                return CarouselSlider(
                  options: CarouselOptions(
                    height: filteredTournamentDocs.isNotEmpty
                        ? carouselHeight * 1.4
                        : 0,
                    aspectRatio: 1,
                    viewportFraction: 0.9,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    autoPlayCurve: Curves.linear,
                  ),
                  items: filteredTournamentDocs.map((tournamentDoc) {
                    final tournamentData = tournamentDoc.data();
                    if (tournamentData == null) {
                      return Container(
                        child: Text(S.of(context).No_data_available),
                      );
                    }

                    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: tournamentDoc.reference
                          .collection('singleMatches')
                          .get(),
                      builder: (context, matchesSnapshot) {
                        if (!matchesSnapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final tournamentMatches = matchesSnapshot.data!.docs
                            .map((matchDoc) =>
                                SingleMatch.fromFirestore(matchDoc))
                            .toList();

                        // Check if the tournament has matches
                        if (tournamentMatches.isNotEmpty) {
                          // If the tournament has matches, return the UI
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VerticalCarouselSlider(
                                tournamentId: tournamentDoc.id,
                                matches: tournamentMatches,
                              ),
                            ],
                          );
                        } else {
                          // If the tournament has no matches, delete it
                          // Remove the tournament ID from the club's list
                          clubData.singleTournamentsIds
                              .remove(tournamentDoc.id);
                          // Delete the tournament document from Firebase
                          tournamentDoc.reference.delete();
                          return Container();
                        }
                      },
                    );
                  }).toList(),
                );
              },
            );
          },
        );
      },
    );
  }
}
