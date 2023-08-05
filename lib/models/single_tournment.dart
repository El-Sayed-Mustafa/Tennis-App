import 'package:tennis_app/models/single_match.dart';

class SingleTournament {
  String id;
  String name;
  bool isDoubles;
  List<SingleMatch> singleMatches;

  SingleTournament({
    required this.id,
    required this.name,
    required this.isDoubles,
    required this.singleMatches,
  });

  // Factory method to create a Tournament object from a Firestore document
  factory SingleTournament.fromFirestore(Map<String, dynamic> doc) {
    return SingleTournament(
      id: doc['id'],
      name: doc['name'],
      isDoubles: doc['isDoubles'],
      singleMatches: List.from(doc['singleMatches'])
          .map((match) => SingleMatch.fromFirestore(match))
          .toList(),
    );
  }

  // Method to convert a Tournament object to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'isDoubles': isDoubles,
      'singleMatches':
          singleMatches.map((match) => match.toFirestore()).toList(),
    };
  }
}
