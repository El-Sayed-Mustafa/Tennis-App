import 'package:cloud_firestore/cloud_firestore.dart';

class SingleTournament {
  String id;
  String name;
  bool isDoubles;
  List<String> singleMatchIds;

  SingleTournament({
    required this.id,
    required this.name,
    required this.isDoubles,
    required this.singleMatchIds,
  });

  // Factory method to create a Tournament object from a Firestore document
  factory SingleTournament.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SingleTournament(
      id: doc.id,
      name: data['name'],
      isDoubles: data['isDoubles'],
      singleMatchIds: List<String>.from(data['singleMatchIds']),
    );
  }

  // Method to convert a Tournament object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'isDoubles': isDoubles,
      'singleMatchIds': singleMatchIds,
    };
  }
}
