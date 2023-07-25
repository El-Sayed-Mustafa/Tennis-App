import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/find_match/view/widgets/match_item.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../models/Match.dart';
import '../../../../../models/player.dart';
import '../../cubit/playing_screen_cubit.dart';

class PlayingScreen extends StatelessWidget {
  const PlayingScreen({super.key, required this.match, required this.opponent});
  final Matches match;
  final Matches opponent;

  // Future<void> fetchPlayersDataAndSaveMatchId(BuildContext context) async {
  //   try {
  //     // Fetch the data for the first player (userId from match)
  //     DocumentSnapshot<
  //         Map<String,
  //             dynamic>> matchPlayerSnapshot = await FirebaseFirestore.instance
  //         .collection('players')
  //         .doc(match
  //             .userId) // Assuming 'players' is the collection where player data is stored
  //         .get();

  //     // Fetch the data for the second player (userId from opponent)
  //     DocumentSnapshot<
  //         Map<String,
  //             dynamic>> opponentPlayerSnapshot = await FirebaseFirestore
  //         .instance
  //         .collection('players')
  //         .doc(opponent
  //             .userId) // Assuming 'players' is the collection where player data is stored
  //         .get();

  //     // Convert the snapshots to Player objects
  //     Player matchPlayer = Player.fromSnapshot(matchPlayerSnapshot);
  //     Player opponentPlayer = Player.fromSnapshot(opponentPlayerSnapshot);

  //     // Add match.matchId for opponentPlayer in matches
  //     opponentPlayer.matches.add({
  //       'matchId': opponent.matchId,
  //       // Add any other relevant match data you want to store in the player's matches list
  //     });

  //     // Add opponent.matchId for matchPlayer in matches
  //     matchPlayer.matches.add({
  //       'matchId': match.matchId,
  //       // Add any other relevant match data you want to store in the player's matches list
  //     });

  //     // Save the updated player data
  //     await FirebaseFirestore.instance
  //         .collection('players')
  //         .doc(match.userId)
  //         .update(matchPlayer.toJson());

  //     await FirebaseFirestore.instance
  //         .collection('players')
  //         .doc(opponent.userId)
  //         .update(opponentPlayer.toJson());

  //     // Show a success message to the user (optional)
  //     showSnackbar(context, "Match data saved successfully!");
  //   } catch (e) {
  //     // Handle the exception and show an error message to the user
  //     showSnackbar(context, "Error: $e");
  //   }
  // }

  // // Helper function to show a snackbar with the given message
  // void showSnackbar(BuildContext context, String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final playingCubit = PlayingCubit();

    return BlocProvider(
      create: (context) => playingCubit,
      child: BlocBuilder<PlayingCubit, PlayingStatus>(
        builder: (context, state) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                color: const Color(0xF8F8F8F8),
                child: Column(
                  children: [
                    AppBarWaveHome(
                      prefixIcon: IconButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      text: '    Find Match',
                      suffixIconPath: '',
                    ),
                    const Text(
                      'You',
                      style: TextStyle(
                        color: Color(0xFF313131),
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenHeight * .02),
                    MatchItem(match: match),
                    const Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text(
                        'Opponent',
                        style: TextStyle(
                          color: Color(0xFF313131),
                          fontSize: 18,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    MatchItem(match: opponent),
                    Center(
                      // Wrap the IconButton in Center to center it horizontally
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: IconButton(
                          onPressed: () {
                            GoRouter.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.change_circle_rounded,
                            size: 70,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * .02),
                    if (state == PlayingStatus.loading)
                      CircularProgressIndicator()
                    else if (state == PlayingStatus.success)
                      const Text('Match data saved successfully!')
                    else if (state == PlayingStatus.error)
                      const Text('Error occurred while saving match data!')
                    else
                      BottomSheetContainer(
                        buttonText: 'Play',
                        onPressed: () {
                          playingCubit.fetchPlayersDataAndSaveMatchId(
                              match, opponent, context);
                        },
                        color: const Color(0xFFF8F8F8),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
