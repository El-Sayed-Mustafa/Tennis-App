import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String clubId;
  final String clubName;
  final String clubType;
  final String clubAdmin;
  final String phoneNumber;
  final String rulesAndRegulations;
  final String ageRestriction;
  final String address;
  final double rate; // Added property for rate
  final List<String> eventIds;
  final List<String> memberIds;
  final String? photoURL;
  final int matchPlayed;
  final int totalWins;
  final List<String> roleIds;
  final String clubChatId;
  final List<String> singleMatchesIds;
  final List<String> doubleMatchesIds;
  final List<String> singleTournamentsIds;
  final List<String> doubleTournamentsIds;
  final int numberOfRatings; // New property for the number of ratings
  final List<String> courtIds; // New property for the list of court IDs

  Club({
    required this.clubChatId,
    required this.clubId,
    required this.clubName,
    required this.numberOfRatings,
    required this.courtIds,
    required this.clubType,
    required this.clubAdmin,
    required this.phoneNumber,
    required this.matchPlayed,
    required this.totalWins,
    required this.rulesAndRegulations,
    required this.ageRestriction,
    required this.address,
    required this.rate,
    required this.eventIds,
    required this.memberIds,
    this.photoURL,
    required this.roleIds,
    required this.singleMatchesIds,
    required this.doubleMatchesIds,
    required this.singleTournamentsIds,
    required this.doubleTournamentsIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'clubId': clubId,
      'clubName': clubName,
      'clubType': clubType,
      'clubAdmin': clubAdmin,
      'phoneNumber': phoneNumber,
      'numberOfRatings': numberOfRatings,
      'courtIds': courtIds,
      'rulesAndRegulations': rulesAndRegulations,
      'ageRestriction': ageRestriction,
      'address': address, // Include address in the JSON
      'matchPlayed': matchPlayed,
      'totalWins': totalWins, 'rate': rate, // Include rate in the JSON
      'eventIds': eventIds,
      'memberIds': memberIds,
      'clubImageURL': photoURL,
      'roleIds': roleIds, // Include role IDs in the JSON
      'clubChatId': clubChatId,
      'singleMatchesIds': singleMatchesIds,
      'doubleMatchesIds': doubleMatchesIds,
      'singleTournamentsIds': singleTournamentsIds,
      'doubleTournamentsIds': doubleTournamentsIds,
    };
  }

  static Club fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw ArgumentError("Invalid data for Player from DocumentSnapshot");
    }
    return Club(
      clubId: snapshot.id,
      clubName: data['clubName'] as String? ?? '',
      clubType: data['clubType'] as String? ?? '',
      clubAdmin: data['clubAdmin'] as String? ?? '',
      phoneNumber: data['phoneNumber'] as String? ?? '',
      matchPlayed: data['matchPlayed'] as int? ?? 0,
      numberOfRatings: data['numberOfRatings'] as int? ?? 0,
      totalWins: data['totalWins'] as int? ?? 0,
      rulesAndRegulations: data['rulesAndRegulations'] as String? ?? '',
      ageRestriction: data['ageRestriction'] as String? ?? '',
      address: data['address'] as String? ?? '',
      rate: (data['rate'] as num?)?.toDouble() ?? 0.0,
      eventIds: List<String>.from(data['eventIds'] ?? []),
      courtIds: List<String>.from(data['courtIds'] ?? []),
      memberIds: List<String>.from(data['memberIds'] ?? []),
      photoURL: data['clubImageURL'] as String?,
      roleIds: List<String>.from(data['roleIds'] ?? []),
      clubChatId: data['clubChatId'] as String? ?? '',
      singleMatchesIds: List<String>.from(data['singleMatchesIds'] ?? []),
      doubleMatchesIds: List<String>.from(data['doubleMatchesIds'] ?? []),
      singleTournamentsIds:
          List<String>.from(data['singleTournamentsIds'] ?? []),
      doubleTournamentsIds:
          List<String>.from(data['doubleTournamentsIds'] ?? []),
    );
  }
}
