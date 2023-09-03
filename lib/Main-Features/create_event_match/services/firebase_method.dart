import 'package:cloud_firestore/cloud_firestore.dart';

class MatchesFirebaseMethod {
  // Function to delete a match from Firestore
  Future<void> deleteSingleTournamentMatch(
      String matchId, String tournamentId) async {
    try {
      // Get a reference to the tournament's matches collection
      final tournamentRef = FirebaseFirestore.instance
          .collection('singleTournaments')
          .doc(tournamentId);
      final matchesCollection = tournamentRef.collection('singleMatches');

      // Delete the match document
      await matchesCollection.doc(matchId).delete();
      print('sucess');

      // You can also update the UI or show a confirmation message here.
    } catch (error) {
      // Handle any errors that occur during deletion
      print('Error deleting match: $error');
    }
  }
}
