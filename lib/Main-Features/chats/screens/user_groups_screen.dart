// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/chats/screens/groups_screen.dart';
import 'package:tennis_app/Main-Features/chats/widgets/group_card.dart';
import 'package:tennis_app/constants.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/generated/l10n.dart';
import 'package:tennis_app/models/groups.dart';

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
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
        child: Container(
          padding: const EdgeInsets.only(top: 8),
          width: double.infinity,
          decoration: const ShapeDecoration(
            color: kBackgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 3,
                offset: Offset(0, -4),
                spreadRadius: 0,
              )
            ],
          ),
          child: FutureBuilder(
            future: _fetchUserGroups(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text(
                    '${S.of(context).errorLoadingGroups}: ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<GroupChats> userGroups = snapshot.data as List<GroupChats>;

                if (userGroups.isEmpty) {
                  // Show "No groups found" message
                  return Center(
                    child: Text(
                      S.of(context).noGroupsFound,
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  // Build your UI using userGroups
                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: userGroups.length,
                    itemBuilder: (context, index) {
                      GroupChats groupChats = userGroups[index];
                      return ListTile(
                        title: GroupCard(groupChats: groupChats),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupChatScreen(
                                  groupId: groupChats.messageId),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              } else {
                return Center(child: Text(S.of(context).noGroupsFound));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 34, 47, 53),
        onPressed: () {
          GoRouter.of(context).push('/createGroup');
        },
        child: const Icon(
          Icons.add,
        ),
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
      showSnackBar(context, ' ${S.of(context).errorFetchingUserGroups}$error');
    }

    return userGroups;
  }
}
