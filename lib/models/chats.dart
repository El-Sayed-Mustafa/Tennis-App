import 'package:cloud_firestore/cloud_firestore.dart';

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
}

// Function to send a message
Future<void> sendMessage(String chatId, ChatMessage message) async {
  final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
  await chatRef
      .collection('messages')
      .doc(message.messageId)
      .set(message.toJson());
}

// Function to listen for new messages in a chat
Stream<List<ChatMessage>> listenToChat(String chatId) {
  final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
  return chatRef
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => ChatMessage.fromSnapshot(doc)).toList();
  });
}
