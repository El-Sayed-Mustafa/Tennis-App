// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/confirmation_dialog.dart';
import 'package:tennis_app/core/utils/widgets/no_data_text.dart';
import '../../../core/utils/widgets/court_item.dart';
import '../../../generated/l10n.dart';
import '../../../models/player.dart';
import '../../../models/court.dart'; // Import the Court class

class ReversedCourts extends StatefulWidget {
  const ReversedCourts({Key? key}) : super(key: key);

  @override
  State<ReversedCourts> createState() => _ReversedCourtsState();
}

class _ReversedCourtsState extends State<ReversedCourts> {
  int selectedPageIndex = 0;
  final CarouselController _carouselController = CarouselController();
  List<String> reversedCourtsIds = []; // List to store reversed court IDs
  final Method firebaseMethods = Method();

  @override
  void initState() {
    super.initState();
    _fetchReversedCourts(); // Fetch reversed courts when the widget initializes
  }

  // Fetch the player data from Firestore and extract reversedCourtsIds
  void _fetchReversedCourts() async {
    try {
      // Fetch the current user's player data from Firestore
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        showSnackBar(context, S.of(context).noUserIsCurrentlySignedIn);
        return;
      }

      String currentUserId = currentUser.uid;

      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(currentUserId)
              .get();

      if (!playerSnapshot.exists) {
        showSnackBar(
            context, S.of(context).playerDocumentDoesNotExistForCurrentUser);
        return;
      }

      // Create a Player instance from the snapshot data
      Player currentPlayer = Player.fromSnapshot(playerSnapshot);

      // Get the reversedCourtsIds from the Player instance
      reversedCourtsIds = currentPlayer.reversedCourtsIds;

      // Update the carousel with the fetched data
      setState(() {});
    } catch (error) {
      showSnackBar(
          context, ' ${S.of(context).errorFetchingReversedCourts} $error');
    }
  }

  void cancelReservation(Court court, String userId) {
    // Find all the time slots reserved by the user
    List<String> userReservedTimeSlots = [];

    court.reversedTimeSlots.forEach((timeSlot, reservedUserId) {
      if (reservedUserId == userId) {
        userReservedTimeSlots.add(timeSlot);
      }
    });

    if (userReservedTimeSlots.isNotEmpty) {
      // Remove the time slots from reversedTimeSlots
      userReservedTimeSlots.forEach((timeSlot) {
        court.reversedTimeSlots.remove(timeSlot);
      });

      // Add the time slots back to availableTimeSlots
      court.availableTimeSlots.addAll(userReservedTimeSlots);

      // Update the court data in Firestore
      firebaseMethods.updateCourt(court);
    }
  }

  Future<void> deleteCourtIdFromPlayer(
      String currentUserId, String courtId) async {
    try {
      // Fetch the player document
      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(currentUserId)
              .get();

      if (!playerSnapshot.exists) {
        // Handle the case when the player document does not exist
        return;
      }

      // Update the player's reversedCourtsIds to remove the courtId
      Player currentPlayer = Player.fromSnapshot(playerSnapshot);
      List<String> updatedReversedCourtsIds = currentPlayer.reversedCourtsIds;
      updatedReversedCourtsIds.remove(courtId);

      // Save the updated player document back to Firestore
      await FirebaseFirestore.instance
          .collection('players')
          .doc(currentUserId)
          .update({
        'reversedCourtsIds': updatedReversedCourtsIds,
      });
    } catch (error) {
      // Handle the error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double carouselHeight = (screenHeight + screenWidth) * 0.17;

    return Column(
      children: [
        // Conditionally render the CarouselSlider or "No courts" message
        reversedCourtsIds.isNotEmpty
            ? CarouselSlider(
                options: CarouselOptions(
                  height: carouselHeight,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: (index, _) {
                    setState(() {
                      selectedPageIndex = index;
                    });
                  },
                ),
                carouselController: _carouselController,
                items: reversedCourtsIds.map((courtId) {
                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('courts')
                        .doc(courtId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(S.of(context).errorFetchingCourtData);
                      }

                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final courtData = snapshot.data?.data();
                      if (courtData == null) {
                        return Text(S.of(context).noCourtDataAvailable);
                      }

                      // Create a Court instance from the snapshot data
                      final Court court = Court.fromSnapshot(snapshot.data!);

                      // Build the carousel item using the CourtItem widget
                      return Stack(
                        children: [
                          CourtItem(
                            isHome: true,
                            court: court,
                            isSaveUser: true,
                          ),
                          Positioned(
                            left: 15,
                            top: 5,
                            child: IconButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return ConfirmationDialog(
                                        title: S.of(context).confirmDelete,
                                        content: S
                                            .of(context)
                                            .areYouSureYouWantToCancelThisReservation,
                                        confirmText: S.of(context).delete,
                                        cancelText: S.of(context).cancel,
                                        onConfirm: () async {
                                          User? currentUser =
                                              FirebaseAuth.instance.currentUser;
                                          if (currentUser == null) {
                                            showSnackBar(
                                                context,
                                                S
                                                    .of(context)
                                                    .noUserIsCurrentlySignedIn);

                                            return;
                                          }

                                          String currentUserId =
                                              currentUser.uid;
                                          cancelReservation(
                                              court, currentUserId);
                                          await deleteCourtIdFromPlayer(
                                              currentUserId, court.courtId);
                                          GoRouter.of(context).push('/home');
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  size: 30,
                                  color: Colors.black,
                                )),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              )
            : Center(
                child: NoData(
                  text: S.of(context).No_Reversed_Courts,
                  height: screenHeight * .2,
                  width: screenWidth * .8,
                  buttonText: S.of(context).Click_to_Reverse_Court,
                  onPressed: () {
                    GoRouter.of(context).push('/findCourt');
                  },
                ),
              ),

        buildPageIndicator(
            reversedCourtsIds.length), // Add the smooth page indicator
      ],
    );
  }

  Widget buildPageIndicator(int itemCount) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) {
          final bool isSelected = selectedPageIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 11 : 9,
            height: isSelected ? 11 : 9,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.011),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
