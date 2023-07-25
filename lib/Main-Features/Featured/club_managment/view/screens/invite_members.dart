import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/club_managment/view/widgets/item_invite.dart';
import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../models/club.dart';
import '../../../../../models/player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/member_item.dart';

class InviteMember extends StatefulWidget {
  const InviteMember({super.key, required this.club});
  final Club club;

  @override
  State<InviteMember> createState() => _InviteMemberState();
}

class _InviteMemberState extends State<InviteMember> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            text: '   Send Invitations',
            suffixIconPath: '',
          ),
          Expanded(
            child: FutureBuilder<List<Player>>(
              future: getEligiblePlayers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final players = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      return Container(
                        padding: EdgeInsets.all(8.0),
                        child: ItemInvite(
                          // Pass the player to the MemberItem widget
                          member: player,
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Player>> getEligiblePlayers() async {
    try {
      // Get all players from the Firestore "players" collection
      final playersSnapshot =
          await FirebaseFirestore.instance.collection('players').get();

      // Filter out players who are already members of the current club
      final existingMembers = widget.club.memberIds;
      final eligiblePlayers = playersSnapshot.docs
          .map((doc) => Player.fromSnapshot(doc))
          .where((player) => !existingMembers.contains(player.playerId))
          .toList();

      // Sort players based on the number of clubs involved in ascending order
      eligiblePlayers.sort((a, b) =>
          a.participatedClubIds.length.compareTo(b.participatedClubIds.length));

      // Take the first ten players (or less if the list is smaller)
      final firstTenPlayers = eligiblePlayers.take(10).toList();

      return firstTenPlayers;
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error getting eligible players: $e');
      return [];
    }
  }
}
