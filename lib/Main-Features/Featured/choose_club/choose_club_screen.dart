import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../models/club.dart';
import 'choose_club_item.dart';

class ClubInvitationsPage extends StatefulWidget {
  @override
  _ClubInvitationsPageState createState() => _ClubInvitationsPageState();
}

class _ClubInvitationsPageState extends State<ClubInvitationsPage> {
  String? currentUserId;
  final _pageController = PageController();
  List<String> clubInvitationsIds = []; // Declare as an instance variable

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  // Method to get the current user ID
  void _getCurrentUserId() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  // Method to handle the removal of the club invitation ID
  void _removeInvitation(String clubId) {
    final playerRef =
        FirebaseFirestore.instance.collection('players').doc(currentUserId);
    setState(() {
      clubInvitationsIds.remove(clubId);
    });

    // Update the clubInvitationsIds field in Firestore
    playerRef.update({'clubInvitationsIds': clubInvitationsIds});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentUserId == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('players')
                  .doc(currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text('No player data available'));
                }

                final playerData = snapshot.data!.data();
                if (playerData == null) {
                  return const Center(child: Text('Player data not found'));
                }

                clubInvitationsIds =
                    List<String>.from(playerData['clubInvitationsIds'] ?? []);

                return FutureBuilder<List<Club>>(
                  future: fetchClubs(clubInvitationsIds),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                          child: Text('No club invitations found'));
                    }

                    final clubs = snapshot.data!;
                    if (clubs.isEmpty) {
                      return const Center(
                          child: Text('No club invitations found'));
                    }

                    return Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: clubs.length,
                          itemBuilder: (context, index) {
                            final club = clubs[index];
                            return ChooseClubItem(
                              club: club,
                              onCancelPressed: () =>
                                  _removeInvitation(club.clubId),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: clubs.length,
                            effect: const ExpandingDotsEffect(
                              dotColor: Colors.grey,
                              activeDotColor: Colors.blue,
                              dotHeight: 8,
                              dotWidth: 8,
                              spacing: 10,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }

  Future<List<Club>> fetchClubs(List<String> clubIds) async {
    final List<Club> clubs = [];

    for (final clubId in clubIds) {
      final clubSnapshot = await FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubId)
          .get();
      if (clubSnapshot.exists) {
        final club = Club.fromSnapshot(clubSnapshot);
        clubs.add(club);
      }
    }

    return clubs;
  }
}
