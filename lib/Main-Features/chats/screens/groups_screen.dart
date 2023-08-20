import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';

import '../../../models/player.dart';
import '../widgets/group_player_card.dart';
import '../widgets/player_card.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<String> selectedMemberIds = [];
  List<Player> members = []; // Change the type to List<Player>

  @override
  void initState() {
    super.initState();
    fetchClubMembers(); // Rename the function
  }

  void fetchClubMembers() async {
    // Rename the function
    Method method = Method();
    Player player = await method.getCurrentUser();
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('clubs')
        .doc(player.participatedClubId)
        .get();
    if (snapshot.exists) {
      List<String> memberIds = List<String>.from(snapshot.data()!['memberIds']);

      // Fetch players for each member ID
      List<Player> fetchedMembers =
          await Future.wait(memberIds.map((memberId) async {
        DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
            await FirebaseFirestore.instance
                .collection('players')
                .doc(memberId)
                .get();
        return Player.fromSnapshot(playerSnapshot);
      }));

      setState(() {
        members = fetchedMembers;
      });
    }
  }

  void _toggleMemberSelection(String memberId) {
    setState(() {
      if (selectedMemberIds.contains(memberId)) {
        selectedMemberIds.remove(memberId);
      } else {
        selectedMemberIds.add(memberId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Members'),
      ),
      body: ListView.builder(
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          final isSelected = selectedMemberIds.contains(member.playerId);

          return ListTile(
            subtitle: GroupPlayerCard(
              player: member,
            ),
            leading: Checkbox(
              value: isSelected,
              onChanged: (value) => _toggleMemberSelection(member.playerId),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Perform the desired action with selectedMemberIds
          // For example, update the club's member list in Firebase
          // You can call a function to update the Firebase collection here
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
