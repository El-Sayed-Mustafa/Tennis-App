import 'package:cloud_firestore/cloud_firestore.dart';

class Matches {
  final String matchId;
  final String? photoURL;
  final String playerName;
  final String address;
  final DateTime dob;
  final String preferredPlayingTime;
  final String playerType;
  final String clubName;

  Matches({
    required this.matchId,
    required this.playerName,
    required this.photoURL,
    required this.address,
    required this.dob,
    required this.preferredPlayingTime,
    required this.playerType,
    required this.clubName,
  });
  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'playerName': playerName,
      'photoURL': photoURL,
      'address': address,
      'dob': dob,
      'preferredPlayingTime': preferredPlayingTime,
      'playerType': playerType,
      'clubName': clubName,
    };
  }

  factory Matches.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw ArgumentError("Invalid data for Match from DocumentSnapshot");
    }

    return Matches(
      matchId: snapshot.id,
      playerName:
          data['playerName'] as String? ?? '', // Use default value if null
      photoURL: data['photoURL'] as String?, // Nullable String
      address: data['address'] as String? ?? '', // Use default value if null
      dob: (data['dob'] as Timestamp).toDate(),
      preferredPlayingTime: data['preferredPlayingTime'] as String? ??
          '', // Use default value if null
      playerType:
          data['playerType'] as String? ?? '', // Use default value if null
      clubName: data['clubName'] as String? ?? '', // Use default value if null
    );
  }
}
