import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/models/single_match.dart'; // Replace with your model
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_app/models/single_match.dart';

import '../../../core/utils/widgets/single_match_card copy.dart'; // Replace with your model

class VerticalCarouselSlider extends StatelessWidget {
  final List<SingleMatch> matches;

  VerticalCarouselSlider({required this.matches});

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
        viewportFraction: 0.7,
        initialPage: 0,
        enableInfiniteScroll: false,
        enlargeCenterPage: true, scrollDirection: Axis.vertical,
      ),
      items: matches.map((match) {
        return SingleMatchCard(
          match: match,
        );
      }).toList(),
    );
  }
}

class NestedCarouselSlider extends StatelessWidget {
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
          return CircularProgressIndicator();
        }

        final tournamentDocs = snapshot.data!.docs;

        return CarouselSlider(
          options: CarouselOptions(
            height: tournamentDocs.isNotEmpty
                ? carouselHeight
                : 0, // Set height based on matches list
            aspectRatio: 16 / 9,
            viewportFraction: 0.7,
            initialPage: 0,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
          ),
          items: tournamentDocs.map((tournamentDoc) {
            final tournamentData = tournamentDoc.data();
            if (tournamentData == null) {
              // Handle missing data
              return Container(
                child: Text('sss'),
              ); // Return an empty container or a placeholder widget
            }

            // Fetch the subcollection data for 'singleMatches'
            return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: tournamentDoc.reference.collection('singleMatches').get(),
              builder: (context, matchesSnapshot) {
                if (!matchesSnapshot.hasData) {
                  return CircularProgressIndicator();
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
        );
      },
    );
  }
}
