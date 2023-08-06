import 'package:cloud_firestore/cloud_firestore.dart';

class SingleMatch {
  String matchId;
  String player1Id;
  String player2Id;
  DateTime startTime;
  DateTime endTime;
  String winner;

  SingleMatch({
    required this.matchId,
    required this.player1Id,
    required this.player2Id,
    required this.startTime,
    required this.endTime,
    required this.winner,
  });

  // Factory method to create a SingleMatch object from a Firestore document
  factory SingleMatch.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SingleMatch(
      matchId: doc.id,
      player1Id: data['player1Id'],
      player2Id: data['player2Id'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      winner: data['winner'],
    );
  }

  // Method to convert a SingleMatch object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'player1Id': player1Id,
      'player2Id': player2Id,
      'startTime': startTime,
      'endTime': endTime,
      'winner': winner,
    };
  }
}
