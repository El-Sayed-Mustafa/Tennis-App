import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChats {
  final String messageId;
  final String senderId;
  final String content;
  final Timestamp timestamp;
  final List<String> participatedUserIds;

  GroupChats({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.participatedUserIds,
  });

  // Convert message to JSON
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp,
      'participatedUserIds': participatedUserIds,
    };
  }

  // Factory method to create a message from Firestore snapshot
  factory GroupChats.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw ArgumentError("Invalid data for ChatMessage from DocumentSnapshot");
    }

    return GroupChats(
      messageId: snapshot.id,
      senderId: data['senderId'] as String? ?? '',
      content: data['content'] as String? ?? '',
      timestamp: data['timestamp'] as Timestamp? ?? Timestamp.now(),
      participatedUserIds: List<String>.from(data['participatedUserIds'] ?? []),
    );
  }

  // Factory method to create a message from map (JSON) data
  factory GroupChats.fromMap(Map<String, dynamic> map) {
    return GroupChats(
      messageId: map['messageId'] as String? ?? '',
      senderId: map['senderId'] as String? ?? '',
      content: map['content'] as String? ?? '',
      timestamp: map['timestamp'] as Timestamp? ?? Timestamp.now(),
      participatedUserIds: List<String>.from(map['participatedUserIds'] ?? []),
    );
  }
}
