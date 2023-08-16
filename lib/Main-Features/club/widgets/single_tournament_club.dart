import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/models/single_match.dart'; // Replace with your model
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_app/models/single_match.dart'; // Replace with your model

class VerticalCarouselSlider extends StatelessWidget {
  final List<SingleMatch> matches;

  VerticalCarouselSlider({required this.matches});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200, // Adjust the height as needed
        enableInfiniteScroll: false,
        viewportFraction: 1.0, scrollDirection: Axis.vertical,
      ),
      items: matches.map((match) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: Text("Match ID: ${match.matchId}")),
              // Add more match details here
            ],
          ),
        );
      }).toList(),
    );
  }
}

class NestedCarouselSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            height: 300, // Adjust the height as needed
            enableInfiniteScroll: false,
            viewportFraction: 1.0,
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
                    // Display tournament details here
                    Text("Tournament ID: ${tournamentDoc.id}"),
                    // Add more tournament details here

                    SizedBox(height: 8.0),

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
