import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_app/Main-Features/Featured/Event/create_event/view/widgets/input_end_date.dart';
import 'package:tennis_app/Main-Features/create_event_match/single_friendly_match/cubit/single_match_state.dart';
import 'package:tennis_app/core/utils/widgets/input_date_and_time.dart';
import 'package:tennis_app/models/double_match.dart';
import 'package:tennis_app/models/player.dart';
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

      if (tournamentId == '') {
        final matchRef = FirebaseFirestore.instance
            .collection('single_matches')
            .doc(match.matchId);
        await matchRef.update(updatedMatch.toFirestore());
      } else {
        final tournamentRef = FirebaseFirestore.instance
            .collection('singleTournaments')
            .doc(tournamentId);

        // Update the existing match in the tournament collection
        final existingMatchRef =
            tournamentRef.collection('singleMatches').doc(match.matchId);

        await existingMatchRef.update(updatedMatch.toFirestore());
      }
      emit(SaveMatchSuccess());
    } on Exception catch (e) {
      emit(SaveMatchFailure(error: e.toString()));
    }
  }

  void editDoubleMatch({
    required Player selectedPlayer,
    required Player selectedPlayer2,
    required Player selectedPlayer3,
    required Player selectedPlayer4,
    required TextEditingController courtNameController,
    required String tournamentId,
    required DoubleMatch match,
  }) async {
    emit(SaveMatchInProgress());

    try {
      DateTime? selectedStartDateTime = context.read<DateTimeCubit>().state;
      DateTime? selectedEndDateTime = context.read<EndDateTimeCubit>().state;
      DateTime startTime = selectedStartDateTime;
      DateTime endTime = selectedEndDateTime;
      String courtName = courtNameController.text.trim();

      DoubleMatch updatedMatch = DoubleMatch(
        matchId: match.matchId,
        player1Id: selectedPlayer.playerId,
        player2Id: selectedPlayer2.playerId,
        startTime: startTime,
        endTime: endTime,
        winner1: match.winner1,
        courtName: courtName,
        result: match.result,
        player3Id: selectedPlayer3.playerId,
        player4Id: selectedPlayer4.playerId,
      );
      if (tournamentId == '') {
        final matchRef = FirebaseFirestore.instance
            .collection('double_matches')
            .doc(match.matchId);
        await matchRef.update(updatedMatch.toFirestore());
      } else {
        final tournamentRef = FirebaseFirestore.instance
            .collection('doubleTournaments')
            .doc(tournamentId);

        final existingMatchRef =
            tournamentRef.collection('doubleMatches').doc(match.matchId);
        await existingMatchRef.update(updatedMatch.toFirestore());
      }
      emit(SaveMatchSuccess());
    } on Exception catch (e) {
      emit(SaveMatchFailure(error: e.toString()));
    }
  }
}
