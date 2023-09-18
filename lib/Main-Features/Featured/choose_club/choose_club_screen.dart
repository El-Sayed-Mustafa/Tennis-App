import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tennis_app/core/utils/widgets/no_data_text.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import '../../../generated/l10n.dart';
import '../../../models/club.dart';
import 'choose_club_item.dart';

class ClubInvitationsPage extends StatefulWidget {
  const ClubInvitationsPage({super.key});

  @override
  _ClubInvitationsPageState createState() => _ClubInvitationsPageState();
}

class _ClubInvitationsPageState extends State<ClubInvitationsPage> {
  String? currentUserId;
  final _pageController = PageController();
  List<String> clubInvitationsIds = []; // Declare as an instance variable
  Map<String, dynamic>? playerData; // Declare playerData here

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

  void _joinClub(String clubId) async {
    final playerRef =
        FirebaseFirestore.instance.collection('players').doc(currentUserId);
    try {
      final playerSnapshot = await playerRef.get();

      if (playerSnapshot.exists) {
        await playerRef.update({'participatedClubId': clubId});

        // Add the current userId to the clubMembersIds list in the club document
        final clubRef =
            FirebaseFirestore.instance.collection('clubs').doc(clubId);
        await clubRef.update({
          'memberIds': FieldValue.arrayUnion([currentUserId])
        });
      }
      _removeInvitation(clubId);
    } catch (error) {}
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
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                  return Center(
                      child: Text(S.of(context).No_player_data_available));
                }

                final playerData = snapshot.data!.data();
                if (playerData == null) {
                  return Center(
                      child: Text(S.of(context).No_player_data_available));
                }

                clubInvitationsIds =
                    List<String>.from(playerData['clubInvitationsIds'] ?? []);
                if (clubInvitationsIds.isEmpty) {
                  return Column(
                    children: [
                      PoPAppBarWave(
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
                        text: 'Club Invitations',
                        suffixIconPath: '',
                      ),
                      SizedBox(
                        height: screenHeight * .35,
                      ),
                      SizedBox(
                        height: 150,
                        width: screenWidth * .8,
                        child: const NoData(
                          text:
                              'You do not have any club invitations available',
                        ),
                      )
                    ],
                  );
                }
                return FutureBuilder<List<Club>>(
                  future: fetchClubs(clubInvitationsIds),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData) {
                      return Center(
                          child: Text(S.of(context).No_player_data_available));
                    }

                    final clubs = snapshot.data!;
                    if (clubs.isEmpty) {
                      return const Center(
                        child: Text(
                            'You do not have any club invitations available'),
                      );
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
                              onJoinPressed: () => _joinClub(club.clubId),
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
