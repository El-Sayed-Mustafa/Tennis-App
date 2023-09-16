import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/chats/widgets/player_card.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/utils/widgets/chosen_court.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import 'package:tennis_app/generated/l10n.dart';
import 'package:tennis_app/models/court.dart';
import 'package:tennis_app/models/player.dart'; // Import the Player class

class CourtDetailsScreen extends StatefulWidget {
  const CourtDetailsScreen(
      {Key? key, required this.court, required this.isSaveUser})
      : super(key: key);
  final Court court;
  final bool isSaveUser;
  @override
  _CourtDetailsScreenState createState() => _CourtDetailsScreenState();
}

class _CourtDetailsScreenState extends State<CourtDetailsScreen> {
  List<String> selectedTimeSlots = [];
  final String playerId = FirebaseAuth.instance.currentUser!.uid;
  final Method firebaseMethods = Method();

  bool showReversedCourts = false; // Initially hidden
  bool showAvailableCourts = true; // Initially hidden

  Future<Player?> fetchPlayer(String playerId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(playerId)
              .get();
      if (playerSnapshot.exists) {
        return Player.fromSnapshot(playerSnapshot);
      }
    } catch (e) {
      SnackBar(
          content: Text('${S.of(context).Error_fetching_player_data}: $e'));
    }
    return null;
  }

  void handleCheckboxChanged(String timeSlot, bool isChecked) {
    setState(() {
      if (isChecked) {
        // Add the time slot to reversedTimeSlots
        widget.court.reversedTimeSlots[timeSlot] =
            playerId; // Replace with your user ID logic
        selectedTimeSlots.add(timeSlot); // Add it to selectedTimeSlots
      } else {
        // Remove the time slot from reversedTimeSlots
        widget.court.reversedTimeSlots.remove(timeSlot);
        selectedTimeSlots.remove(timeSlot); // Remove it from selectedTimeSlots
      }
    });
  }

  void updateFirebaseData() {
    // Remove selected items from availableTimeSlots
    widget.court.availableTimeSlots
        .removeWhere((timeSlot) => selectedTimeSlots.contains(timeSlot));

    // Update the Court data in Firebase Firestore
    firebaseMethods.updateCourt(widget.court);

    // Clear the selectedTimeSlots list
    selectedTimeSlots.clear();
    setState(() {}); // Trigger a rebuild to update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PoPAppBarWave(
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
            text: S.of(context).Courts,
            suffixIconPath: '',
          ),
          const SizedBox(height: 16),
          Center(
            child: ChosenCourt(
                courtId: widget.court.courtId,
                isUser: true,
                isSaveUser: widget.isSaveUser),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                showAvailableCourts = !showAvailableCourts;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                showAvailableCourts
                    ? 'Available Courts (Tap to Hide)'
                    : 'Available Courts (Tap to Show)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 47, 53),
                ),
              ),
            ),
          ),
          if (showAvailableCourts)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.court.availableTimeSlots.length,
                itemBuilder: (context, index) {
                  final timeSlot = widget.court.availableTimeSlots[index];
                  final isChecked = selectedTimeSlots.contains(timeSlot);
                  return ListTile(
                    title: Text(
                      timeSlot,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 86, 84, 84),
                          fontWeight: FontWeight.w500),
                    ),
                    leading: Checkbox(
                      activeColor: const Color.fromARGB(255, 34, 47, 53),
                      value: isChecked,
                      onChanged: (bool? isChecked) {
                        handleCheckboxChanged(timeSlot, isChecked ?? false);
                      },
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              setState(() {
                showReversedCourts = !showReversedCourts;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                showReversedCourts
                    ? 'Reversed Courts (Tap to Hide)'
                    : 'Reversed Courts (Tap to Show)',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 34, 47, 53),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (showReversedCourts)
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widget.court.reversedTimeSlots.length,
                itemBuilder: (context, index) {
                  final reversedTimeSlot =
                      widget.court.reversedTimeSlots.keys.toList()[index];
                  final reversedPlayerId =
                      widget.court.reversedTimeSlots[reversedTimeSlot];
                  return FutureBuilder<Player?>(
                    future: fetchPlayer(reversedPlayerId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: const Color.fromARGB(255, 34, 47, 53),
                        ));
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return const Text('Player Data: Unknown');
                      } else {
                        final player = snapshot.data!;
                        return PlayerCard(
                            player: player, timeSlot: reversedTimeSlot);
                      }
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          BottomSheetContainer(
            buttonText: S.of(context).Get_Reserved,
            onPressed: () {
              updateFirebaseData();
              updateCourtReservedStatus(widget.court.courtId);
            },
          ),
        ],
      ),
    );
  }

  void updateCourtReservedStatus(String courtId) async {
    try {
      // Step 1: Get the current user ID from Firebase Authentication
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return;
      }

      String currentUserId = currentUser.uid;

      // Step 2: Fetch the player document for the current user
      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(currentUserId)
              .get();

      if (!playerSnapshot.exists) {
        return;
      }

      // Step 3: Update the 'reversedCourtsIds' property with the new courtId
      Player currentPlayer = Player.fromSnapshot(playerSnapshot);
      List<String> updatedReversedCourtsIds = currentPlayer.reversedCourtsIds;
      updatedReversedCourtsIds.add(courtId);
      print('hi');
      // Step 4: Save the updated player document back to Firestore
      await FirebaseFirestore.instance
          .collection('players')
          .doc(currentUserId)
          .update({
        'reversedCourtsIds': updatedReversedCourtsIds,
      });
    } catch (error) {}
  }
}
