import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewChatScreen extends StatefulWidget {
  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  String _currentUserId = '';
  String _participatedClubId = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _currentUserId = currentUser.uid;
      });
      await _fetchParticipatedClubId();
    }
  }

  Future<void> _fetchParticipatedClubId() async {
    final playerSnapshot = await FirebaseFirestore.instance
        .collection('players')
        .doc(_currentUserId)
        .get();

    if (playerSnapshot.exists) {
      final playerData = playerSnapshot.data();
      if (playerData != null) {
        setState(() {
          _participatedClubId = playerData['participatedClubId'];
        });
      }
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchClubData() async {
    return FirebaseFirestore.instance
        .collection('clubs')
        .doc(_participatedClubId)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchClubChatData() async {
    final clubData = await _fetchClubData();
    final clubChatId = clubData.data()?['clubChatId'];

    return FirebaseFirestore.instance.collection('chats').doc(clubChatId).get();
  }

  Future<void> _createNewChat() async {
    // Create a new chat document
    final newChatRef = FirebaseFirestore.instance.collection('chats').doc();
    final newChatId = newChatRef.id;

    // Update the club's clubChatId field with the new chat ID
    await FirebaseFirestore.instance
        .collection('clubs')
        .doc(_participatedClubId)
        .update({'clubChatId': newChatId});

    // Save the new chat ID in the current player's chatIds list
    await FirebaseFirestore.instance
        .collection('players')
        .doc(_currentUserId)
        .update({
      'chatIds': FieldValue.arrayUnion([newChatId]),
    });

    // Save the new chat ID in the new chat document
    await newChatRef.set({
      'chatId': newChatId,
      'participants': [_currentUserId],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Club Chat'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (_participatedClubId.isNotEmpty) {
              final clubChatSnapshot = await _fetchClubChatData();
              if (clubChatSnapshot.exists) {
                // Chat already exists, navigate to the existing chat screen
                final clubChatData = clubChatSnapshot.data();
                final List<String> participants =
                    List<String>.from(clubChatData?['participants'] ?? []);

                // Check if the current user is a participant in the chat
                if (participants.contains(_currentUserId)) {
                  // Navigate to the chat screen with the existing chat ID
                  final String chatId = clubChatData?['chatId'] ?? '';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClubChatScreen(chatId: chatId),
                    ),
                  );
                } else {
                  // Add the current user as a participant in the chat
                  await clubChatSnapshot.reference.update({
                    'participants': FieldValue.arrayUnion([_currentUserId]),
                  });

                  // Navigate to the chat screen with the existing chat ID
                  final String chatId = clubChatData?['chatId'] ?? '';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClubChatScreen(chatId: chatId),
                    ),
                  );
                }
              } else {
                // Chat does not exist, create a new chat
                await _createNewChat();

                // Fetch the new chat ID from the club data
                final clubData = await _fetchClubData();
                final clubChatId = clubData.data()?['clubChatId'] ?? '';

                // Navigate to the chat screen with the new chat ID
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClubChatScreen(chatId: clubChatId),
                  ),
                );
              }
            }
          },
          child: Text('Start Club Chat'),
        ),
      ),
    );
  }
}

class ClubChatScreen extends StatelessWidget {
  final String chatId;

  ClubChatScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    // Implement the chat screen UI using the provided chatId
    return Scaffold(
      appBar: AppBar(
        title: Text('Club Chat'),
      ),
      body: Center(
        child: Text('Club Chat Screen - Chat ID: $chatId'),
      ),
    );
  }
}
