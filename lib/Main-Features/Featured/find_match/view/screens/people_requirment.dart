import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../models/Match.dart';
import '../widgets/match_item.dart';

class PeopleRequirement extends StatelessWidget {
  PeopleRequirement({super.key, required this.match});
  final Matches match;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color(0xF8F8F8F8),
        child: Column(
          children: [
            AppBarWaveHome(
              prefixIcon: IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              text: '    Find Match',
              suffixIconPath: '',
            ),
            const Text(
              'Your Requirements',
              style: TextStyle(
                color: Color(0xFF313131),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: screenHeight * .02),
            MatchItem(match: match),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'People’ Requirements',
                style: TextStyle(
                  color: Color(0xFF313131),
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('matches')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final matches = snapshot.data!.docs
                      .map((doc) => Matches.fromSnapshot(doc))
                      .toList();

                  // Sort matches based on your criteria here
                  matches.sort((a, b) {
                    // Example: Sort by playerType, then dob, then preferredPlayingTime
                    int playerTypeComparison =
                        a.playerType.compareTo(b.playerType);
                    if (playerTypeComparison != 0) {
                      return playerTypeComparison;
                    }

                    int dobComparison = a.dob.compareTo(b.dob);
                    if (dobComparison != 0) {
                      return dobComparison;
                    }
                    int addressComparison = a.address.compareTo(b.address);
                    if (addressComparison != 0) {
                      return addressComparison;
                    }
                    return a.preferredPlayingTime
                        .compareTo(b.preferredPlayingTime);
                  });

                  // Filter out the match you passed above from the list
                  matches.remove(match);

                  // Reverse the matches list before passing it to ListView
                  final reversedMatches = List.of(matches.reversed);
                  final excludedFirstItemMatches = reversedMatches.sublist(1);

                  return ListView.builder(
                    itemCount: excludedFirstItemMatches.length,
                    itemBuilder: (context, index) {
                      final match = excludedFirstItemMatches[index];
                      return MatchItem(match: match);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
