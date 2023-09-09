// private_chat.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/chats/widgets/community_message.dart';
import 'package:tennis_app/Main-Features/chats/widgets/my_reply.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import '../../../generated/l10n.dart';
import '../../../models/message.dart';
import '../../../models/player.dart';
import '../widgets/message_input.dart';

// Function to get chat messages for the chat conversation between the current user and the other player
Stream<List<ChatMessage>> getChatMessages(
    String currentUserId, String otherPlayerId) {
  final chatId = generateChatId(currentUserId, otherPlayerId);
  final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

  return chatRef
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => ChatMessage.fromSnapshot(doc)).toList();
  });
}

// Helper function to generate a chat ID based on player IDs to keep conversation unique
String generateChatId(String currentUserId, String otherPlayerId) {
  List<String> ids = [currentUserId, otherPlayerId];
  ids.sort();
  return ids.join('_');
}

class PrivateChat extends StatefulWidget {
  final Player player;

  PrivateChat({required this.player});

  @override
  State<PrivateChat> createState() => _PrivateChatState();
}

class _PrivateChatState extends State<PrivateChat> {
  @override
  void initState() {
    super.initState();
    markMessagesAsRead();
  }

// Function to mark the unread messages as read
  Future<void> markMessagesAsRead() async {
    final user = FirebaseAuth.instance.currentUser;
    final chatId = generateChatId(user!.uid, widget.player.playerId);

    try {
      // Fetch the chat document
      final chatDoc = await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .get();

      if (chatDoc.exists) {
        // Update the chat document to set unreadCount for the current user to 0
        await chatDoc.reference.update({
          user.uid == chatDoc['user1Id']
              ? 'unreadCountUser1'
              : 'unreadCountUser2': 0,
        });
      }
    } catch (e) {
      // Handle any errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          PoPAppBarWave(
            prefixIcon: IconButton(
              onPressed: () {
                GoRouter.of(context).push('/chat');
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
            ),
            text: S.of(context).chat,
            suffixIconPath: '',
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: screenHeight * 0.13,
                  width: screenHeight * 0.13,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: (widget.player.photoURL != ''
                        ? FadeInImage.assetNetwork(
                            placeholder: 'assets/images/loadin.gif',
                            image: widget.player.photoURL!,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/profileimage.png',
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/profile-event.jpg',
                            fit: BoxFit.cover,
                          )),
                  ),
                ),
                SizedBox(height: screenHeight * .005),
                Text(
                  widget.player.playerName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenHeight * .02),
                Flexible(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const ShapeDecoration(
                      color: Color(0xF8F8F8F8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5,
                          offset: Offset(0, -4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: StreamBuilder<List<ChatMessage>>(
                      stream:
                          getChatMessages(user!.uid, widget.player.playerId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                                '${S.of(context).error}: ${snapshot.error}'),
                          );
                        } else {
                          final chatMessages = snapshot.data?.toList() ?? [];
                          return ListView.builder(
                            reverse: true,
                            itemCount: chatMessages.length,
                            itemBuilder: (context, index) {
                              final message = chatMessages[index];
                              return message.senderId == user.uid
                                  ? MyReply(message: message)
                                  : SenderMessage(
                                      message: message,
                                      player: widget.player,
                                    );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          MessageInput(
            currentUserId: user.uid,
            otherPlayerId: widget.player.playerId,
          ),
        ],
      ),
    );
  }
}
