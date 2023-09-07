import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/chats/screens/private_chat.dart';
import 'package:tennis_app/Main-Features/chats/widgets/message_item.dart';

import '../../../constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/message.dart';
import '../../../models/player.dart'; // Import the ChatMessage model class

class PrivateChats extends StatefulWidget {
  const PrivateChats({
    super.key,
  });

  @override
  State<PrivateChats> createState() => _PrivateChatsState();
}

class _PrivateChatsState extends State<PrivateChats> {
  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

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
                return Center(child: Text(S.of(context).no_chats_found));
              }

              final playerData = snapshot.data!.data();
              final List<String> chatIds =
                  List<String>.from(playerData!['chatIds'] ?? []);

              return StreamBuilder<List<ChatWithLastMessage>>(
                stream: _getChatsStream(chatIds,
                    currentUserId), // Use a stream to listen for changes
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final chatItems = snapshot.data;
                  if (chatItems == null || chatItems.isEmpty) {
                    return Center(child: Text(S.of(context).no_chats_found));
                  }

                  return RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView.builder(
                      itemCount: chatItems.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final chatItem = chatItems[index];

                        return MessageItem(
                          screenWidth: double.infinity,
                          photoUrl: chatItem.player.photoURL,
                          name: chatItem.player.playerName,
                          message: chatItem.lastMessage.content,
                          time: chatItem.lastMessage.timestamp,
                          unreadCount: chatItem.unreadCount,
                          onTap: () async {
                            // Fetch receiver's player data from Firestore
                            final receiverId = chatItem.lastMessage.receiverId;
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
                                  .doc(chatItem.lastMessage.senderId)
                                  .get();
                            }

                            // Check if the receiver's player data exists
                            if (receiverSnapshot.exists) {
                              final receiverPlayerData =
                                  receiverSnapshot.data();
                              final receiverPlayer =
                                  Player.fromMap(receiverPlayerData!);

                              // Navigate to the PrivateChat screen when the item is tapped
                              // ignore: use_build_context_synchronously
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
                              // ignore: use_build_context_synchronously
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(S.of(context).error),
                                  content: Text(
                                      S.of(context).receiver_data_not_found),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(S.of(context).ok),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).push('/searchChat');
        },
        child: Icon(
          Icons.search,
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Perform data fetching or refreshing here, e.g., fetching updated chat data
    // ...

    // Once you've updated the data, you can call setState to rebuild the widget
    setState(() {
      // Update any necessary variables or state
      // ...
    });
  }

  Stream<List<ChatWithLastMessage>> _getChatsStream(
      List<String> chatIds, String currentUserId) {
    // Create a stream that listens for changes in chat data
    return FirebaseFirestore.instance
        .collection('players')
        .doc(currentUserId)
        .snapshots()
        .asyncMap((snapshot) async {
      final playerData = snapshot.data();
      final chatIds = List<String>.from(playerData?['chatIds'] ?? []);
      print('objecdddt');
      return _getChatsWithLastMessage(chatIds, currentUserId);
    });
  }

  Future<List<ChatWithLastMessage>> _getChatsWithLastMessage(
      List<String> chatIds, String currentUserId) async {
    final List<ChatWithLastMessage> chatItems = [];

    for (final chatId in chatIds) {
      final chatSnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .get();
      print('test1');
      if (chatSnapshot.exists) {
        print('test2');

        final unreadCount = currentUserId == chatSnapshot['user1Id']
            ? chatSnapshot['unreadCountUser1']
            : chatSnapshot['unreadCountUser2'];

        final chatMessageSnapshot = await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (chatMessageSnapshot.docs.isNotEmpty) {
          final lastMessage =
              ChatMessage.fromSnapshot(chatMessageSnapshot.docs.first);

          // Fetch player data for the last message's sender or receiver
          Player player;
          if (lastMessage.receiverId != currentUserId) {
            final receiverSnapshot = await FirebaseFirestore.instance
                .collection('players')
                .doc(lastMessage.receiverId)
                .get();
            player = Player.fromSnapshot(receiverSnapshot);
          } else {
            final senderSnapshot = await FirebaseFirestore.instance
                .collection('players')
                .doc(lastMessage.senderId)
                .get();
            player = Player.fromSnapshot(senderSnapshot);
          }

          chatItems.add(ChatWithLastMessage(
            player: player,
            lastMessage: lastMessage,
            unreadCount: unreadCount,
          ));
        }
      }
    }

    // Sort chatItems based on the time of the last message (most recent first)
    chatItems.sort(
        (a, b) => b.lastMessage.timestamp.compareTo(a.lastMessage.timestamp));

    return chatItems;
  }
}

class ChatWithLastMessage {
  final Player player;
  final ChatMessage lastMessage;
  final int unreadCount; // New property

  ChatWithLastMessage({
    required this.player,
    required this.lastMessage,
    required this.unreadCount,
  });
}
