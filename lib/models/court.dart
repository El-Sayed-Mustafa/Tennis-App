import 'package:cloud_firestore/cloud_firestore.dart';

class Court {
  final String courtId;
  final String courtName;
  final String phoneNumber;
  final DateTime availableDay;
  final String courtAddress;
  final String photoURL;
  final String from;
  final String to;
  final List<String> availableTimeSlots;
  Map<String, String> reversedTimeSlots;

  Court({
    required this.courtId,
    required this.courtName,
    required this.phoneNumber,
    required this.availableDay,
    required this.courtAddress,
    required this.photoURL,
    required this.from,
    required this.to,
    required this.availableTimeSlots,
    required this.reversedTimeSlots,
  });

  Map<String, dynamic> toJson() {
    return {
      'courtId': courtId,
      'courtName': courtName,
      'phoneNumber': phoneNumber,
      'availableDay': availableDay,
      'courtAddress': courtAddress,
      'photoURL': photoURL,
      'from': from,
      'to': to,
      'reversedTimeSlots': reversedTimeSlots,
      'availableTimeSlots': availableTimeSlots,
    };
  }

  static Court fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    final Map<String, String> reversedTimeSlots =
        Map<String, String>.from(data['reversedTimeSlots'] ?? {});
    final List<String> availableTimeSlots =
        List<String>.from(data['availableTimeSlots'] ?? []);
    return Court(
      courtId: snapshot.id,
      courtName: data['courtName'] as String,
      phoneNumber: data['phoneNumber'] as String,
      availableDay: (data['availableDay'] as Timestamp).toDate(),
      courtAddress: data['courtAddress'] as String,
      photoURL: data['photoURL'] as String,
      from: data['from'] as String,
      to: data['to'] as String,
      availableTimeSlots: availableTimeSlots,
      reversedTimeSlots: reversedTimeSlots,
    );
  }
}
