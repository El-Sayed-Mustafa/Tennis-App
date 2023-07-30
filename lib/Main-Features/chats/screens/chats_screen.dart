import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_app/Main-Features/chats/screens/private_chat.dart';
import 'package:tennis_app/Main-Features/chats/widgets/message_item.dart';

import '../../../models/chats.dart';
import '../../../models/player.dart'; // Import the ChatMessage model class

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
        child: Container(
          width: double.infinity,
          decoration: const ShapeDecoration(
            color: Colors.white,
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
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('players')
                .doc(currentUserId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('No chats found.'));
              }

              final playerData = snapshot.data!.data();
              final List<String> chatIds =
                  List<String>.from(playerData!['chatIds'] ?? []);

              return ListView.builder(
                itemCount: chatIds.length,
                itemBuilder: (context, index) {
                  final String chatId = chatIds[index];

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(chatId)
                        .collection('messages')
                        .orderBy('timestamp',
                            descending: true) // Sort messages by timestamp
                        .snapshots(),
                    builder: (context, chatSnapshot) {
                      if (chatSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final chatDocs = chatSnapshot.data!.docs;
                      if (chatDocs.isEmpty) {
                        return ListTile(
                          title: Text('Chat with ${chatId}'),
                          subtitle: Text('No messages'),
                        );
                      }

                      final lastMessage =
                          ChatMessage.fromSnapshot(chatDocs.first);

                      // Create an async function to fetch player data
                      Future<Player> fetchPlayerData() async {
                        if (lastMessage.receiverId != currentUserId) {
                          final receiverSnapshot = await FirebaseFirestore
                              .instance
                              .collection('players')
                              .doc(lastMessage.receiverId)
                              .get();
                          return Player.fromSnapshot(receiverSnapshot);
                        } else {
                          final senderSnapshot = await FirebaseFirestore
                              .instance
                              .collection('players')
                              .doc(lastMessage.senderId)
                              .get();
                          return Player.fromSnapshot(senderSnapshot);
                        }
                      }

                      return FutureBuilder<Player>(
                        future: fetchPlayerData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final player = snapshot.data;

                          return MessageItem(
                            screenWidth: double.infinity,
                            photoUrl:
                                player!.photoURL, // Retrieve player's photoUrl
                            name: player!.playerName,
                            message: lastMessage.content,
                            time: lastMessage.timestamp,
                            onTap: () async {
                              // Fetch receiver's player data from Firestore
                              final receiverId = lastMessage.receiverId;
                              DocumentSnapshot<Map<String, dynamic>>
                                  receiverSnapshot;

                              if (receiverId != currentUserId) {
                                receiverSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('players')
                                    .doc(receiverId)
                                    .get();
                              } else {
                                receiverSnapshot = await FirebaseFirestore
                                    .instance
                                    .collection('players')
                                    .doc(lastMessage.senderId)
                                    .get();
                              }

                              // Check if the receiver's player data exists
                              if (receiverSnapshot.exists) {
                                final receiverPlayerData =
                                    receiverSnapshot.data();
                                final receiverPlayer =
                                    Player.fromMap(receiverPlayerData!);

                                // Navigate to the PrivateChat screen when the item is tapped
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrivateChat(
                                      player: receiverPlayer,
                                      // Pass the receiver's player data to the PrivateChat screen
                                    ),
                                  ),
                                );
                              } else {
                                // Handle the case when the receiver's player data doesn't exist (optional)
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Error'),
                                    content:
                                        Text('Receiver player data not found.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
