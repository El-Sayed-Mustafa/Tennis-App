import 'package:tennis_app/models/message.dart';

class Chat {
  String chatId;
  String user1Id;
  String user2Id;
  int unreadCountUser1;
  int unreadCountUser2;
  List<ChatMessage> messages;

  Chat({
    required this.chatId,
    required this.user1Id,
    required this.user2Id,
    required this.unreadCountUser1,
    required this.unreadCountUser2,
    required this.messages,
  });

  factory Chat.fromSnapshot(Map<String, dynamic> snapshot) {
    return Chat(
      chatId: snapshot['chatId'] as String? ?? '',
      user1Id: snapshot['user1Id'] as String? ?? '',
      user2Id: snapshot['user2Id'],
      unreadCountUser1: snapshot['unreadCountUser1'] as int? ?? 0,
      unreadCountUser2: snapshot['unreadCountUser2'] as int? ?? 0,
      messages: (snapshot['messages'] as List<dynamic>)
          .map((message) => ChatMessage.fromSnapshot(message))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'unreadCountUser1': unreadCountUser1,
      'unreadCountUser2': unreadCountUser2,
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
