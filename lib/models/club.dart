import 'package:cloud_firestore/cloud_firestore.dart';

class Club {
  final String clubId;
  final String clubName;
  final String clubType;
  final String clubAdmin;
  final String nationalIdNumber;
  final String phoneNumber;
  final String email;
  final String rulesAndRegulations;
  final String ageRestriction;
  final List<String> eventIds;
  final List<String> memberIds;
  final String? photoURL; // Added field for photo URL

  Club({
    required this.clubId,
    required this.clubName,
    required this.clubType,
    required this.clubAdmin,
    required this.nationalIdNumber,
    required this.phoneNumber,
    required this.email,
    required this.rulesAndRegulations,
    required this.ageRestriction,
    required this.eventIds,
    required this.memberIds,
    this.photoURL, // Initialized as nullable
  });

  Map<String, dynamic> toJson() {
    return {
      'clubId': clubId,
      'clubName': clubName,
      'clubType': clubType,
      'clubAdmin': clubAdmin,
      'nationalIdNumber': nationalIdNumber,
      'phoneNumber': phoneNumber,
      'email': email,
      'rulesAndRegulations': rulesAndRegulations,
      'ageRestriction': ageRestriction,
      'eventIds': eventIds,
      'memberIds': memberIds,
      'photoURL': photoURL, // Included in the JSON
    };
  }

  static Club fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Club(
      clubId: snapshot.id,
      clubName: data['clubName'] as String,
      clubType: data['clubType'] as String,
      clubAdmin: data['clubAdmin'] as String,
      nationalIdNumber: data['nationalIdNumber'] as String,
      phoneNumber: data['phoneNumber'] as String,
      email: data['email'] as String,
      rulesAndRegulations: data['rulesAndRegulations'] as String,
      ageRestriction: data['ageRestriction'] as String,
      eventIds: List<String>.from(data['eventIds'] ?? []),
      memberIds: List<String>.from(data['memberIds'] ?? []),
      photoURL: data['photoURL'] as String?, // Assigned to the nullable field
    );
  }
}
