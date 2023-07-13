import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventId;
  final String eventName;
  final DateTime eventStartAt;
  final DateTime eventEndsAt;
  final String eventAddress;
  final String eventType;
  final String courtName;
  final String instructions;
  final List<String> playerIds;

  Event({
    required this.eventId,
    required this.eventName,
    required this.eventStartAt,
    required this.eventEndsAt,
    required this.eventAddress,
    required this.eventType,
    required this.courtName,
    required this.instructions,
    required this.playerIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'eventStartAt': eventStartAt,
      'eventEndsAt': eventEndsAt,
      'eventAddress': eventAddress,
      'eventType': eventType,
      'courtName': courtName,
      'instructions': instructions,
      'playerIds': playerIds,
    };
  }

  static Event fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Event(
      eventId: snapshot.id,
      eventName: data['eventName'] as String,
      eventStartAt: (data['eventStartAt'] as Timestamp).toDate(),
      eventEndsAt: (data['eventEndsAt'] as Timestamp).toDate(),
      eventAddress: data['eventAddress'] as String,
      eventType: data['eventType'] as String,
      courtName: data['courtName'] as String,
      instructions: data['instructions'] as String,
      playerIds: List<String>.from(data['playerIds'] ?? []),
    );
  }
}
