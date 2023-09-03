import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_app/Main-Features/Featured/Event/create_event/view/widgets/input_end_date.dart';
import 'package:tennis_app/Main-Features/create_event_match/single_friendly_match/cubit/single_match_state.dart';
import 'package:tennis_app/core/utils/widgets/input_date_and_time.dart';
import 'package:tennis_app/models/player.dart';
import '../../../../core/methodes/firebase_methodes.dart';
import '../../../../models/club.dart';
import '../../../../models/single_match.dart';

class EditMatchCubit extends Cubit<SaveMatchState> {
  final BuildContext context;

  EditMatchCubit(this.context) : super(SaveMatchInitial());

  void editMatch({
    required Player selectedPlayer,
    required Player selectedPlayer2,
    required TextEditingController courtNameController,
    required String tournamentId,
    required SingleMatch match,
  }) async {
    emit(SaveMatchInProgress());

    try {
      final tournamentRef = FirebaseFirestore.instance
          .collection('singleTournaments')
          .doc(tournamentId);

      // Check if the match already exists in the tournament collection
      if (match.matchId != null) {
        print('${match.matchId} already exists in the tournament collection');

        // Update the existing match in the tournament collection
        final existingMatchRef =
            tournamentRef.collection('singleMatches').doc(match.matchId);
        DateTime? selectedStartDateTime = context.read<DateTimeCubit>().state;
        DateTime? selectedEndDateTime = context.read<EndDateTimeCubit>().state;
        // Get the selected date and time from InputDateAndTime widget and convert it to DateTime object
        DateTime startTime = selectedStartDateTime;

        // Get the selected end date and time from InputEndDateAndTime widget and convert it to DateTime object
        DateTime endTime = selectedEndDateTime;

        // Get the court name from the text controller
        String courtName = courtNameController.text.trim();

        // Create a SingleMatch object
        SingleMatch updatedMatch = SingleMatch(
          matchId: match.matchId,
          player1Id: selectedPlayer.playerId,
          player2Id: selectedPlayer2.playerId,
          startTime: startTime,
          endTime: endTime,
          winner: match.winner,
          courtName: courtName,
          result: match.result,
        );
        await existingMatchRef.update(updatedMatch.toFirestore());
      } else {
        // If the match doesn't have an ID, it means it's a new match.
        // You can choose to handle this case differently if needed.

        // Create a new match document in the tournament collection
        final newMatchRef = tournamentRef.collection('singleMatches').doc();

        // Set the data for the new match document
        await newMatchRef.set(match.toFirestore());

        // Create a copy of the new match in the 'single_matches' collection
        final newMatchRef2 = await FirebaseFirestore.instance
            .collection('single_matches')
            .add(match.toFirestore());

        // Update the match's ID with the one generated in 'single_matches'
        match.matchId = newMatchRef2.id;
      }

      // Update the club's tournament list
      Method method = Method();
      Player currentUser = await method.getCurrentUser();
      Club clubData =
          await method.fetchClubData(currentUser.participatedClubId);
      if (!clubData.singleTournamentsIds.contains(tournamentRef.id)) {
        clubData.singleTournamentsIds.add(tournamentRef.id);
        await FirebaseFirestore.instance
            .collection('clubs')
            .doc(currentUser.participatedClubId)
            .update({
          'singleTournamentsIds': clubData.singleTournamentsIds,
        });
      }
      emit(SaveMatchSuccess());
    } on Exception catch (e) {
      emit(SaveMatchFailure(error: e.toString()));
    }
  }
}
