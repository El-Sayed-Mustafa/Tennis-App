import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_app/Main-Features/chats/screens/groups_screen.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/models/groups.dart';
import 'package:tennis_app/models/player.dart'; // Import your Player model

class UserGroupsScreen extends StatefulWidget {
  const UserGroupsScreen({
    super.key,
  });

  @override
  _UserGroupsScreenState createState() => _UserGroupsScreenState();
}

class _UserGroupsScreenState extends State<UserGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groups'),
      ),
      body: FutureBuilder(
        future: _fetchUserGroups(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show loading indicator
          } else if (snapshot.hasError) {
            return Text('Error loading groups: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<GroupChats> userGroups = snapshot.data as List<GroupChats>;

            // Build your UI using userGroups
            return ListView.builder(
              itemCount: userGroups.length,
              itemBuilder: (context, index) {
                GroupChats groupChats = userGroups[index];
                return ListTile(
                  title: Text(groupChats.groupName), // Use groupName property
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupChatScreen(groupId: groupChats.messageId),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Text('No groups found.');
          }
        },
      ),
    );
  }

  Future<List<GroupChats>> _fetchUserGroups() async {
    List<GroupChats> userGroups = [];
    Method method = Method();
    final player = await method.getCurrentUser();
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('group_chats')
              .where('participants', arrayContains: player.playerId)
              .get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> docSnapshot
          in querySnapshot.docs) {
        GroupChats groupChats = GroupChats.fromSnapshot(docSnapshot);
        userGroups.add(groupChats);
      }
    } catch (error) {
      print('Error fetching user groups: $error');
    }

    return userGroups;
  }
}
