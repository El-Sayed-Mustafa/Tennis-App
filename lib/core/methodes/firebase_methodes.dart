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

// Function to get all chats for the current player sorted from newest to oldest
  Future<List<ChatMessage>> getAllChatsForCurrentPlayer(
      String currentPlayerId) async {
    try {
      // Perform a query to get chats where the current player is either the sender or receiver
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('messages', arrayContainsAny: [
        {'senderId': currentPlayerId},
        {'receiverId': currentPlayerId},
      ]).get();

      // Extract the chats from the query result
      final chats = querySnapshot.docs.map((doc) {
        final chatData = doc.data();
        final messagesData = chatData['messages'] as List<dynamic>;
        // Sort the messages based on the timestamp (newest to oldest)
        messagesData.sort((a, b) {
          final aTimestamp = a['timestamp'] as Timestamp;
          final bTimestamp = b['timestamp'] as Timestamp;
          return bTimestamp.compareTo(aTimestamp);
        });

        // Create the ChatMessage instance from the first (latest) message in each chat
        return ChatMessage.fromMap(messagesData.first);
      }).toList();

      return chats;
    } catch (e) {
      print('Error getting chats: $e');
      return [];
    }
  }
}
