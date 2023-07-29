import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/player.dart';

// Model class for chat messages
class ChatMessage {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String content;
  final Timestamp timestamp;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
  });

  // Convert message to JSON
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp,
    };
  }

  // Factory method to create a message from Firestore snapshot
  factory ChatMessage.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw ArgumentError("Invalid data for ChatMessage from DocumentSnapshot");
    }

    return ChatMessage(
      messageId: snapshot.id,
      senderId: data['senderId'] as String? ?? '',
      receiverId: data['receiverId'] as String? ?? '',
      content: data['content'] as String? ?? '',
      timestamp: data['timestamp'] as Timestamp? ?? Timestamp.now(),
    );
  }

  // Factory method to create a message from map (JSON) data
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      messageId: map['messageId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      receiverId: map['receiverId'] as String? ?? '',
      content: map['content'] as String? ?? '',
      timestamp: map['timestamp'] as Timestamp? ?? Timestamp.now(),
    );
  }
}

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

class PrivateChat extends StatelessWidget {
  final Player player;

  PrivateChat({required this.player});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${player.playerName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: getChatMessages(user!.uid, player.playerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final chatMessages = snapshot.data ?? [];
                  return ListView.builder(
                    reverse: true, // To show latest messages at the bottom
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(chatMessages[index].content),
                        subtitle:
                            Text(chatMessages[index].timestamp.toString()),
                      );
                    },
                  );
                }
              },
            ),
          ),
          MessageInput(
            currentUserId: user.uid,
            otherPlayerId: player.playerId,
          ),
        ],
      ),
    );
  }
}

class MessageInput extends StatefulWidget {
  final String currentUserId;
  final String otherPlayerId;

  MessageInput({required this.currentUserId, required this.otherPlayerId});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _textController = TextEditingController();

  void _sendMessage() {
    final String content = _textController.text.trim();
    if (content.isNotEmpty) {
      final chatId = generateChatId(widget.currentUserId, widget.otherPlayerId);
      final chatRef =
          FirebaseFirestore.instance.collection('chats').doc(chatId);

      final newMessage = ChatMessage(
        messageId: '',
        senderId: widget.currentUserId,
        receiverId: widget.otherPlayerId,
        content: content,
        timestamp: Timestamp.now(),
      );

      chatRef.collection('messages').add(newMessage.toJson());

      // Clear the text input field after sending the message
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border(top: BorderSide(color: Colors.grey[500]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
