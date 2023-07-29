import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/chats.dart';
import '../../models/club.dart';
import '../../models/player.dart';

class Method {
  Future<Player> getCurrentUser() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch additional user data from Firestore based on the uid
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('players')
          .doc(user.uid)
          .get();

      return Player.fromSnapshot(snapshot);
    }
    throw Exception("User not found");
  }

  Future<Club> fetchClubData(String clubId) async {
    final clubSnapshot =
        await FirebaseFirestore.instance.collection('clubs').doc(clubId).get();

    // Assuming the Club class has a factory constructor to parse data from Firestore
    final clubData = Club.fromSnapshot(clubSnapshot);
    return clubData;
  }

// Function to get chat messages for the current player
  Future<List<ChatMessage>> getChatMessagesForCurrentPlayer(
      String currentPlayerId) async {
    try {
      // Perform a query to get messages where the senderId or receiverId matches the currentPlayerId
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('messages', arrayContains: {
        'senderId': currentPlayerId,
      }).get();

      // Extract the messages from the query result
      final messages = querySnapshot.docs
          .map((doc) {
            final chatData = doc.data();
            final messagesData = chatData['messages'] as List<dynamic>;
            return messagesData
                .map((messageData) => ChatMessage.fromMap(messageData))
                .toList();
          })
          .expand((element) => element)
          .toList();

      return messages;
    } catch (e) {
      print('Error getting chat messages: $e');
      return [];
    }
  }
}
