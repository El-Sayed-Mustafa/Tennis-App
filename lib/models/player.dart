import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String playerId;
  final String? photoURL;
  final String playerName;
  final String playerLevel;
  final int matchPlayed;
  final int totalWins;
  final String skillLevel;
  final String createdClubId;
  final List<String> eventIds;
  final List<String>
      participatedClubIds; // Added property for participated club IDs
  final String gender;
  final DateTime birthDate;
  final String preferredPlayingTime;
  final String playerType;
  final String phoneNumber;
  final Map<String, String> clubRoles;

  Player({
    required this.playerId,
    required this.playerName,
    required this.photoURL,
    required this.playerLevel,
    required this.matchPlayed,
    required this.totalWins,
    required this.skillLevel,
    required this.createdClubId,
    required this.eventIds,
    required this.participatedClubIds,
    required this.gender,
    required this.birthDate,
    required this.clubRoles,
    required this.preferredPlayingTime,
    required this.playerType,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerId': playerId,
      'playerName': playerName,
      'photoURL': photoURL,
      'playerLevel': playerLevel,
      'matchPlayed': matchPlayed,
      'totalWins': totalWins,
      'skillLevel': skillLevel,
      'createdClubId': createdClubId,
      'eventIds': eventIds,
      'participatedClubIds':
          participatedClubIds, // Include participated club IDs in the JSON
      'gender': gender,
      'birthDate': birthDate,
      'preferredPlayingTime': preferredPlayingTime,
      'playerType': playerType,
      'phoneNumber': phoneNumber,
      'clubRoles': clubRoles,
    };
  }

  static Player fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Player(
      playerId: snapshot.id,
      playerName: data['playerName'] as String,
      photoURL: data['photoURL'] as String?,
      playerLevel: data['playerLevel'] as String,
      matchPlayed: data['matchPlayed'] as int,
      totalWins: data['totalWins'] as int,
      skillLevel: data['skillLevel'] as String,
      createdClubId: data['createdClubId'] as String,
      eventIds: List<String>.from(data['eventIds'] ?? []),
      participatedClubIds: List<String>.from(data['participatedClubIds'] ??
          []), // Assign participated club IDs from snapshot
      gender: data['gender'] as String,
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      preferredPlayingTime: data['preferredPlayingTime'] as String,
      playerType: data['playerType'] as String,
      phoneNumber: data['phoneNumber'] as String,
      clubRoles: Map<String, String>.from(data['clubRoles'] ?? {}),
    );
  }
}
