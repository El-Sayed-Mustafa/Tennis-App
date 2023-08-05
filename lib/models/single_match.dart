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
  factory SingleMatch.fromFirestore(Map<String, dynamic> doc) {
    return SingleMatch(
      matchId: doc['matchId'],
      player1Id: doc['player1Id'],
      player2Id: doc['player2Id'],
      startTime: (doc['startTime'] as Timestamp).toDate(),
      endTime: (doc['endTime'] as Timestamp).toDate(),
      winner: doc['winner'],
    );
  }

  // Method to convert a SingleMatch object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'matchId': matchId,
      'player1Id': player1Id,
      'player2Id': player2Id,
      'startTime': startTime,
      'endTime': endTime,
      'winner': winner,
    };
  }
}
