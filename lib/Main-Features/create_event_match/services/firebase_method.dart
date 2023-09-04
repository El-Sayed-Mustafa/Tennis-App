import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/models/club.dart';
import 'package:tennis_app/models/player.dart';

class MatchesFirebaseMethod {
  final Method method = Method();

  Future<void> deleteMyEvent(String eventId) async {
    try {
      Player currentUser = await method.getCurrentUser();
      if (!currentUser.eventIds.contains(eventId)) {
        return;
      }
      currentUser.eventIds.remove(eventId);

      final userDoc = FirebaseFirestore.instance
          .collection('players')
          .doc(currentUser.playerId);

      await userDoc.update({
        'eventIds': currentUser.eventIds,
      });
    } catch (error) {
      print(error);
      // Handle other errors if necessary
    }
  }

  Future<void> deleteMyMatch(String matchId) async {
    try {
      Player currentUser = await method.getCurrentUser();
      if (!currentUser.matches.contains(matchId)) {
        return;
      }

      currentUser.matches.remove(matchId);
      final userDoc = FirebaseFirestore.instance
          .collection('players')
          .doc(currentUser.playerId);

      await userDoc.update({
        'matchId': currentUser.matches,
      });
    } catch (error) {
      print(error);
      // Handle other errors if necessary
    }
  }

  Future<void> deleteMySingleMatch(String matchId) async {
    try {
      Player currentUser = await method.getCurrentUser();
      if (!currentUser.singleMatchesIds.contains(matchId)) {
        return;
      }

      currentUser.singleMatchesIds.remove(matchId);
      final userDoc = FirebaseFirestore.instance
          .collection('players')
          .doc(currentUser.playerId);

      await userDoc.update({
        'singleMatchesIds': currentUser.singleMatchesIds,
      });
    } catch (error) {
      print(error);
      // Handle other errors if necessary
    }
  }

  Future<void> deleteMyDoubleMatch(String matchId) async {
    try {
      Player currentUser = await method.getCurrentUser();
      if (!currentUser.doubleMatchesIds.contains(matchId)) {
        return;
      }

      currentUser.doubleMatchesIds.remove(matchId);
      final userDoc = FirebaseFirestore.instance
          .collection('players')
          .doc(currentUser.playerId);

      await userDoc.update({
        'doubleMatchesIds': currentUser.doubleMatchesIds,
      });
    } catch (error) {
      print(error);
      // Handle other errors if necessary
    }
  }

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

      Player currentUser = await method.getCurrentUser();

      Club clubData =
          await method.fetchClubData(currentUser.participatedClubId);

      clubData.singleTournamentsIds.remove(matchId);
      // Update the club's data in Firestore
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc(currentUser.participatedClubId)
          .update({
        'singleTournamentsIds': clubData.singleTournamentsIds,
      });
    } catch (error) {
      // Handle any errors that occur during deletion
    }
  }

  Future<void> deleteDoubleTournamentMatch(
      String matchId, String tournamentId) async {
    try {
      // Get a reference to the tournament's matches collection
      final tournamentRef = FirebaseFirestore.instance
          .collection('doubleTournaments')
          .doc(tournamentId);
      final matchesCollection = tournamentRef.collection('doubleMatches');

      // Delete the match document
      await matchesCollection.doc(matchId).delete();

      Player currentUser = await method.getCurrentUser();

      Club clubData =
          await method.fetchClubData(currentUser.participatedClubId);

      clubData.doubleTournamentsIds.remove(matchId);
      // Update the club's data in Firestore
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc(currentUser.participatedClubId)
          .update({
        'doubleTournamentsIds': clubData.doubleTournamentsIds,
      });
    } catch (error) {
      // Handle any errors that occur during deletion
    }
  }

  Future<void> deleteSingleMatch(String matchId) async {
    final CollectionReference matchesCollection =
        FirebaseFirestore.instance.collection('single_matches');

    try {
      // Use the matchId to create a reference to the match document
      final matchRef = matchesCollection.doc(matchId);

      // Fetch the current user

      // Delete the match document
      await matchRef.delete();

      Player currentUser = await method.getCurrentUser();

      // Fetch the club data for the current user
      Club clubData =
          await method.fetchClubData(currentUser.participatedClubId);

      clubData.singleMatchesIds.remove(matchId);
      currentUser.singleMatchesIds.remove(matchId);

      // Update the club's data in Firestore
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc(currentUser.participatedClubId)
          .update({
        'singleMatchesIds': clubData.singleMatchesIds,
      });

      await FirebaseFirestore.instance
          .collection('players')
          .doc(currentUser.participatedClubId)
          .update({
        'singleMatchesIds': currentUser.singleMatchesIds,
      });
    } catch (error) {
      // Handle errors if necessary
    }
  }

  Future<void> deleteDoubleMatch(String matchId) async {
    final CollectionReference matchesCollection =
        FirebaseFirestore.instance.collection('double_matches');
    try {
      // Use the matchId to create a reference to the match document
      final matchRef = matchesCollection.doc(matchId);

      // Delete the match document
      await matchRef.delete();

      Player currentUser = await method.getCurrentUser();

      // Fetch the club data for the current user
      Club clubData =
          await method.fetchClubData(currentUser.participatedClubId);

      clubData.doubleMatchesIds.remove(matchId);
      currentUser.doubleMatchesIds.remove(matchId);

      // Update the club's data in Firestore
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc(currentUser.participatedClubId)
          .update({
        'doubleMatchesIds': clubData.doubleMatchesIds,
      });

      await FirebaseFirestore.instance
          .collection('players')
          .doc(currentUser.participatedClubId)
          .update({
        'doubleMatchesIds': currentUser.doubleMatchesIds,
      });
    } catch (error) {}
  }
}
