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
  final String participatedClubIds;
  final List<String> clubInvitationsIds;
  final List<Map<String, dynamic>> matches;
  bool isInvitationSent = false;
  final List<String> reversedCourtsIds;

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
    required this.reversedCourtsIds,
    required this.matches,
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
      'clubInvitationsIds': clubInvitationsIds,
      'phoneNumber': phoneNumber,
      'clubRoles': clubRoles,
      'reversedCourtsIds': reversedCourtsIds,
      'matchId': matches,
    };
  }

  factory Player.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw ArgumentError("Invalid data for Player from DocumentSnapshot");
    }

    return Player(
      playerId: snapshot.id,
      playerName: data['playerName'] as String? ?? '',
      photoURL: data['photoURL'] as String?,
      playerLevel: data['playerLevel'] as String? ?? '',
      matchPlayed: data['matchPlayed'] as int? ?? 0,
      totalWins: data['totalWins'] as int? ?? 0,
      skillLevel: data['skillLevel'] as String? ?? '0',
      createdClubId: data['createdClubId'] as String? ?? '',
      eventIds: List<String>.from(data['eventIds'] ?? []),
      gender: data['gender'] as String? ?? '',
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      preferredPlayingTime: data['preferredPlayingTime'] as String? ?? '',
      playerType: data['playerType'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      clubRoles: Map<String, String>.from(data['clubRoles'] ?? {}),
      participatedClubIds: data['participatedClubIds'] as String? ?? '',
      clubInvitationsIds: List<String>.from(data['clubInvitationsIds'] ?? []),
      matches: List<Map<String, dynamic>>.from(data['matchId'] ?? []),
      reversedCourtsIds: List<String>.from(data['reversedCourtsIds'] ?? []),
    );
  }
}
