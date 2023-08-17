import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/models/single_match.dart'; // Replace with your model
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/utils/widgets/single_match_card copy.dart';
import '../../../generated/l10n.dart'; // Replace with your model

class VerticalCarouselSlider extends StatelessWidget {
  final List<SingleMatch> matches;

  VerticalCarouselSlider({super.key, required this.matches});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double carouselHeight = (screenHeight + screenWidth) * 0.18;

    return CarouselSlider(
      options: CarouselOptions(
        height: matches.isNotEmpty
            ? carouselHeight
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
          child: SingleMatchCard(
            match: match,
          ),
        );
      }).toList(),
    );
  }
}

class SingleTournamentsClub extends StatelessWidget {
  const SingleTournamentsClub({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double carouselHeight = (screenHeight + screenWidth) * 0.22;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('singleTournaments')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final tournamentDocs = snapshot.data!.docs;

        return Column(
          children: [
            const SizedBox(height: 10),
            Text(
              S.of(context).SingleTournaments,
              style: const TextStyle(
                color: Color(0xFF313131),
                fontSize: 19,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: tournamentDocs.isNotEmpty
                    ? carouselHeight
                    : 0, // Set height based on matches list
                aspectRatio: 1,
                viewportFraction: 0.7,
                initialPage: 0,
                enableInfiniteScroll: false,
                enlargeCenterPage: true, autoPlayCurve: Curves.linear,
              ),
              items: tournamentDocs.map((tournamentDoc) {
                final tournamentData = tournamentDoc.data();
                if (tournamentData == null) {
                  // Handle missing data
                  return Container(
                    child: const Text('sss'),
                  ); // Return an empty container or a placeholder widget
                }

                // Fetch the subcollection data for 'singleMatches'
                return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future:
                      tournamentDoc.reference.collection('singleMatches').get(),
                  builder: (context, matchesSnapshot) {
                    if (!matchesSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final tournamentMatches = matchesSnapshot.data!.docs
                        .map((matchDoc) => SingleMatch.fromFirestore(matchDoc))
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Use the VerticalCarouselSlider to display matches
                        VerticalCarouselSlider(matches: tournamentMatches),
                      ],
                    );
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
