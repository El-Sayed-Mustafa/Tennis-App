import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/chats/widgets/player_card.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/generated/l10n.dart';
import 'package:tennis_app/models/court.dart';
import 'package:tennis_app/models/player.dart'; // Import the Player class

class CourtDetailsScreen extends StatefulWidget {
  const CourtDetailsScreen({Key? key, required this.court}) : super(key: key);
  final Court court;

  @override
  _CourtDetailsScreenState createState() => _CourtDetailsScreenState();
}

class _CourtDetailsScreenState extends State<CourtDetailsScreen> {
  List<String> selectedTimeSlots = [];
  final String playerId = FirebaseAuth.instance.currentUser!.uid;
  final Method firebaseMethods = Method();

  bool showReversedCourts = false; // Initially hidden

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

    // Update the Court data in Firebase Firestore
    firebaseMethods.updateCourt(widget.court);
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
      appBar: AppBar(
        title: const Text('Court Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Available Time Slots:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.court.availableTimeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = widget.court.availableTimeSlots[index];
                final isChecked = selectedTimeSlots.contains(timeSlot);
                return ListTile(
                  title: Text(timeSlot),
                  leading: Checkbox(
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
            child: Text(
              showReversedCourts
                  ? 'Reversed Courts (Tap to Hide)'
                  : 'Reversed Courts (Tap to Show)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Change the color to your preference
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (showReversedCourts)
            Expanded(
              child: ListView.builder(
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
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data == null) {
                        return Text('Player Data: Unknown');
                      } else {
                        final player = snapshot.data!;
                        return ListTile(
                          title: PlayerCard(player: player),
                          subtitle: Text('Time Slot: $reversedTimeSlot'),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          BottomSheetContainer(
            buttonText: S.of(context).Get_Reserved,
            onPressed: updateFirebaseData,
          ),
        ],
      ),
    );
  }
}
