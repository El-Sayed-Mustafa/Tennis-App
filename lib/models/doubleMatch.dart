import 'package:cloud_firestore/cloud_firestore.dart';

class DoubleMatch {
  String matchId;
  String player1Id;
  String player2Id;
  String player3Id;
  String player4Id;
  DateTime startTime;
  DateTime endTime;
  String winner1;
  String winner2;

  DoubleMatch({
    required this.matchId,
    required this.player1Id,
    required this.player2Id,
    required this.player3Id,
    required this.player4Id,
    required this.startTime,
    required this.endTime,
    required this.winner1,
    required this.winner2,
  });

  // Factory method to create a DoubleMatch object from a Firestore document
  factory DoubleMatch.fromFirestore(Map<String, dynamic> doc) {
    return DoubleMatch(
      matchId: doc['matchId'],
      player1Id: doc['player1Id'],
      player2Id: doc['player2Id'],
      player3Id: doc['player3Id'],
      player4Id: doc['player4Id'],
      startTime: (doc['startTime'] as Timestamp).toDate(),
      endTime: (doc['endTime'] as Timestamp).toDate(),
      winner1: doc['winner1'],
      winner2: doc['winner2'],
    );
  }

  // Method to convert a DoubleMatch object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'matchId': matchId,
      'player1Id': player1Id,
      'player2Id': player2Id,
      'player3Id': player3Id,
      'player4Id': player4Id,
      'startTime': startTime,
      'endTime': endTime,
      'winner1': winner1,
      'winner2': winner2,
    };
  }
}
