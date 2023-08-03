import 'package:cloud_firestore/cloud_firestore.dart';

class FindMatch {
  final String userId;
  final String? photoURL;
  final String playerName;
  final String address;
  final DateTime dob;
  final String preferredPlayingTime;
  final String playerType;
  final String clubName;
  final String matchId; // New property for match ID

  FindMatch({
    required this.userId,
    required this.playerName,
    required this.photoURL,
    required this.address,
    required this.dob,
    required this.preferredPlayingTime,
    required this.playerType,
    required this.clubName,
    required this.matchId, // Initialize the match ID
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'playerName': playerName,
      'photoURL': photoURL,
      'address': address,
      'dob': dob,
      'preferredPlayingTime': preferredPlayingTime,
      'playerType': playerType,
      'clubName': clubName,
      'matchId': matchId, // Serialize the match ID
    };
  }

  factory FindMatch.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw ArgumentError("Invalid data for Match from DocumentSnapshot");
    }

    return FindMatch(
      userId: data['userId'] as String? ?? '',
      playerName: data['playerName'] as String? ?? '',
      photoURL: data['photoURL'] as String?,
      address: data['address'] as String? ?? '',
      dob: (data['dob'] as Timestamp).toDate(),
      preferredPlayingTime: data['preferredPlayingTime'] as String? ?? '',
      playerType: data['playerType'] as String? ?? '',
      clubName: data['clubName'] as String? ?? '',
      matchId: snapshot.id, // Deserialize the match ID
    );
  }

  FindMatch copyWith({
    String? userId,
    String? photoURL,
    String? playerName,
    String? address,
    DateTime? dob,
    String? preferredPlayingTime,
    String? playerType,
    String? clubName,
    String? matchId, // Add matchId to the copyWith method
  }) {
    return FindMatch(
      userId: userId ?? this.userId,
      photoURL: photoURL ?? this.photoURL,
      playerName: playerName ?? this.playerName,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      preferredPlayingTime: preferredPlayingTime ?? this.preferredPlayingTime,
      playerType: playerType ?? this.playerType,
      clubName: clubName ?? this.clubName,
      matchId: matchId ??
          this.matchId, // Copy the match ID when creating a new instance
    );
  }
}
