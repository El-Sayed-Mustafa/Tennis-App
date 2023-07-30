import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_app/Main-Features/chats/screens/private_chat.dart';

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
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final chatDocs = chatSnapshot.data!.docs;
                  if (chatDocs.isEmpty) {
                    return ListTile(
                      title: Text('Chat with ${chatId}'),
                      subtitle: Text('No messages'),
                    );
                  }

                  final lastMessage = ChatMessage.fromSnapshot(chatDocs.first);
                  return ListTile(
                    title: Text('Chat with ${lastMessage.receiverId}'),
                    subtitle: Text(lastMessage.content),
                    onTap: () async {
                      // Fetch receiver's player data from Firestore
                      final receiverId = lastMessage.receiverId;
                      DocumentSnapshot<Map<String, dynamic>> receiverSnapshot;

                      if (receiverId != currentUserId) {
                        receiverSnapshot = await FirebaseFirestore.instance
                            .collection('players')
                            .doc(receiverId)
                            .get();
                      } else {
                        receiverSnapshot = await FirebaseFirestore.instance
                            .collection('players')
                            .doc(lastMessage.senderId)
                            .get();
                      }

                      // Check if the receiver's player data exists
                      if (receiverSnapshot.exists) {
                        final receiverPlayerData = receiverSnapshot.data();
                        final receiverPlayer =
                            Player.fromMap(receiverPlayerData!);

                        // Navigate to the PrivateChat screen when the item is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrivateChat(
                              player:
                                  receiverPlayer, // Pass the receiver's player data to the PrivateChat screen
                            ),
                          ),
                        );
                      } else {
                        // Handle the case when the receiver's player data doesn't exist (optional)
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Error'),
                            content: Text('Receiver player data not found.'),
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
      ),
    );
  }
}
