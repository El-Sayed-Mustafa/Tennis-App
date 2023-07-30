import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_app/Main-Features/chats/screens/private_chat.dart';

import '../../../models/chats.dart'; // Assuming you have the ChatMessage and Chat class defined.

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

                  final lastMessage = chatDocs.first.data();
                  return ListTile(
                    title: Text('Chat with ${lastMessage['receiverId']}'),
                    subtitle: Text(lastMessage['content']),
                    onTap: () {
                      // Navigate to the PrivateChat screen when the item is tapped
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => PrivateChat(
                      //       chat: Chat.fromMap(lastMessage), // Pass the last message data as chat data
                      //       currentUserId: currentUserId,
                      //     ),
                      //   ),
                      // );
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
