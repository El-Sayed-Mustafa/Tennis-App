// ignore_for_file: invalid_return_type_for_catch_error

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tennis_app/core/utils/snackbar.dart';

import '../../../generated/l10n.dart';
import '../../../models/chats.dart';
import '../../../models/player.dart';
import '../widgets/community_message.dart';
import '../widgets/my_reply.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _messageController = TextEditingController();
  Future<Player?> _fetchPlayerData(String playerId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(playerId)
              .get();
      if (playerSnapshot.exists) {
        return Player.fromSnapshot(playerSnapshot);
      }
      return null; // Return null if the player does not exist.
    } catch (error) {
      print('Error fetching player data: $error');
      return null;
    }
  }

  String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _buildChatMessages(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('global-chat')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<ChatMessage> messages = snapshot.data!.docs
              .map((doc) => ChatMessage.fromSnapshot(doc))
              .toList();
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final ChatMessage message = messages[index];

              // Fetch player data for the sender
              return FutureBuilder<Player?>(
                future: _fetchPlayerData(message.senderId.toString()),
                builder: (context, playerSnapshot) {
                  if (playerSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (playerSnapshot.hasData) {
                    final Player? player = playerSnapshot.data;
                    if (player != null) {
                      return message.senderId == currentUserID
                          ? MyReply(message: message)
                          : SenderMessage(
                              message: message,
                              player: player,
                            );
                    }
                  }
                  return Container();
                },
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.05, color: Color(0xFF9A9A9A)),
                  borderRadius: BorderRadius.circular(40),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x26313131),
                    blurRadius: 10,
                    offset: Offset(-5, 5),
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: TextField(
                controller: _messageController,
                decoration:
                    InputDecoration(hintText: S.of(context).enter_your_message),
              ),
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00344E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
              color: Colors.white,
              iconSize: 23,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String messageContent = _messageController.text.trim();
    _messageController.clear();

    if (messageContent.isNotEmpty) {
      String currentUserID = FirebaseAuth.instance.currentUser!.uid;

      CollectionReference chatCollection =
          FirebaseFirestore.instance.collection('global-chat');
      chatCollection.add({
        'senderId': currentUserID,
        'content': messageContent,
        'timestamp': FieldValue.serverTimestamp(),
      }).then((_) {
        // Message sent successfully, do any additional actions if needed
      }).catchError(
          (error) => showSnackBar(context, 'Error sending Message : $error'));
      ;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
