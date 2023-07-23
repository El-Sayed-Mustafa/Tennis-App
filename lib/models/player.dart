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
  final String gender;
  final DateTime birthDate;
  final String preferredPlayingTime;
  final String playerType;
  final String phoneNumber;
  final Map<String, String> clubRoles;
  final List<String> participatedClubIds;
  final List<String> clubInvitationsIds;

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
    required this.gender,
    required this.birthDate,
    required this.clubRoles,
    required this.preferredPlayingTime,
    required this.playerType,
    required this.phoneNumber,
    required this.participatedClubIds,
    required this.clubInvitationsIds,
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
      'gender': gender,
      'birthDate': birthDate,
      'preferredPlayingTime': preferredPlayingTime,
      'playerType': playerType,
      'phoneNumber': phoneNumber,
      'clubRoles': clubRoles,
    };
  }

  factory Player.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw ArgumentError("Invalid data for Player from DocumentSnapshot");
    }

    return Player(
      playerId: snapshot.id,
      playerName:
          data['playerName'] as String? ?? '', // Use default value if null
      photoURL: data['photoURL'] as String?, // Nullable String
      playerLevel:
          data['playerLevel'] as String? ?? '', // Use default value if null
      matchPlayed:
          data['matchPlayed'] as int? ?? 0, // Use default value if null
      totalWins: data['totalWins'] as int? ?? 0, // Use default value if null
      skillLevel:
          data['skillLevel'] as String? ?? '0', // Use default value if null
      createdClubId:
          data['createdClubId'] as String? ?? '', // Use default value if null
      eventIds: List<String>.from(data['eventIds'] ?? []),
      gender: data['gender'] as String? ?? '', // Nullable String
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      preferredPlayingTime: data['preferredPlayingTime'] as String? ??
          '', // Use default value if null
      playerType:
          data['playerType'] as String? ?? '', // Use default value if null
      phoneNumber:
          data['phoneNumber'] as String? ?? '', // Use default value if null
      clubRoles: Map<String, String>.from(data['clubRoles'] ?? {}),
      participatedClubIds: List<String>.from(data['participatedClubIds'] ?? []),
      clubInvitationsIds: List<String>.from(data['clubInvitationsIds'] ?? []),
    );
  }
}
