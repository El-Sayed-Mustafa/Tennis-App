import 'package:cloud_firestore/cloud_firestore.dart';

class Court {
  final String courtId;
  final String courtName;
  final String phoneNumber;
  final DateTime startDate;
  final DateTime endDate;
  final String courtAddress;
  final String photoURL; // New photo field

  Court({
    required this.courtId,
    required this.courtName,
    required this.phoneNumber,
    required this.startDate,
    required this.endDate,
    required this.courtAddress,
    required this.photoURL,
  });

  Map<String, dynamic> toJson() {
    return {
      'courtId': courtId,
      'courtName': courtName,
      'phoneNumber': phoneNumber,
      'startDate': startDate,
      'endDate': endDate,
      'courtAddress': courtAddress,
      'photoURL': photoURL,
    };
  }

  static Court fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Court(
      courtId: snapshot.id,
      courtName: data['courtName'] as String,
      phoneNumber: data['phoneNumber'] as String,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      courtAddress: data['courtAddress'] as String,
      photoURL: data['photoURL'] as String,
    );
  }
}
