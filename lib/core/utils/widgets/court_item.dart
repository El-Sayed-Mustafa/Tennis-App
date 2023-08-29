import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../Main-Features/home/widgets/divider.dart';
import '../../../generated/l10n.dart';
import '../../../models/court.dart';
import 'package:intl/intl.dart';

import '../../../models/player.dart';

class CourtItem extends StatefulWidget {
  CourtItem({Key? key, required this.court, this.courtNameController})
      : super(key: key);
  final Court court;
  final TextEditingController? courtNameController; // Optional parameter

  @override
  State<CourtItem> createState() => _CourtItemState();
}

class _CourtItemState extends State<CourtItem> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _courtStream;
  bool canTap = true;

  @override
  void initState() {
    super.initState();
    canTap = !widget.court.reversed;

    _courtStream = FirebaseFirestore.instance
        .collection('courts')
        .doc(widget.court.courtId)
        .snapshots();
  }

  void _cancelReservation(String courtId) async {
    try {
      // Step 1: Get the current user ID from Firebase Authentication
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        // Handle the case when no user is signed in
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
        // Handle the case when player document does not exist
        return;
      }

      // Step 3: Update the player's reversedCourtsIds to remove the courtId
      Player currentPlayer = Player.fromSnapshot(playerSnapshot);
      List<String> updatedReversedCourtsIds = currentPlayer.reversedCourtsIds;
      updatedReversedCourtsIds.remove(courtId);

      // Step 4: Save the updated player document back to Firestore
      await FirebaseFirestore.instance
          .collection('players')
          .doc(currentUserId)
          .update({
        'reversedCourtsIds': updatedReversedCourtsIds,
      });

      // Step 5: Update the 'reversed' property of the court document
      await FirebaseFirestore.instance
          .collection('courts')
          .doc(courtId)
          .update({
        'reversed': false, // Set 'reversed' back to false
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation canceled successfully')),
      );
    } catch (error) {
      // Handle any errors that occur during the process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error canceling reservation: $error')),
      );
    }
  }

  void _currentPlayerCourts(String courtId) async {
    // Update the 'reversed' property to true for the corresponding court document in Firestore
    FirebaseFirestore.instance.collection('courts').doc(courtId).update({
      'reversed': true,
    }).then((_) {
      // Successfully updated the 'reversed' property in Firestore
      const SnackBar(
          content: Text('Court reversed status updated successfully'));
    }).catchError((error) {
      // Handle the error if updating fails
      SnackBar(content: Text('Error updating court reversed status: $error'));
    });
  }

  void _updateCourtReservedStatus(String courtId) async {
    try {
      // Step 1: Get the current user ID from Firebase Authentication
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        const SnackBar(content: Text('No user is currently signed in.'));
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
        const SnackBar(
            content: Text('Player document does not exist for current user.'));
        return;
      }

      // Step 3: Update the 'reversedCourtsIds' property with the new courtId
      Player currentPlayer = Player.fromSnapshot(playerSnapshot);
      List<String> updatedReversedCourtsIds = currentPlayer.reversedCourtsIds;
      updatedReversedCourtsIds.add(courtId);

      // Step 4: Save the updated player document back to Firestore
      await FirebaseFirestore.instance
          .collection('players')
          .doc(currentUserId)
          .update({
        'reversedCourtsIds': updatedReversedCourtsIds,
      });

      const SnackBar(
          content: Text(
              'Court reversed status updated successfully for the current user.'));
    } catch (error) {
      // Handle any errors that occur during the process
      SnackBar(content: Text('Error updating court reversed status: $error'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double itemWidth = screenWidth * 0.9;
    final double imageHeight = screenHeight * 0.13;
    final double titleFontSize = screenHeight * 0.031;
    final double subtitleFontSize = screenHeight * 0.015;
    final double buttonTextFontSize = screenHeight * 0.015;
    final double buttonWidth = itemWidth * 0.4;
    final double buttonHeight = screenHeight * 0.035;

    final DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateTime startDate =
        dateTimeFormat.parse(widget.court.startDate.toString());
    final DateTime endDate =
        dateTimeFormat.parse(widget.court.endDate.toString());

    final String formattedStartDate =
        DateFormat('MMMM d, yyyy - h:mm a').format(startDate);
    final String formattedEndDate =
        DateFormat('MMMM d, yyyy - h:mm a').format(endDate);

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.041, vertical: screenHeight * 0.01),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
        width: itemWidth,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0x440D5FC3)),
            borderRadius: BorderRadius.circular(screenWidth * 0.079),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(imageHeight / 3),
              child: Container(
                height: imageHeight * 1.2,
                width: imageHeight,
                child: widget.court.photoURL != ''
                    ? FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loadin.gif',
                        image: widget.court.photoURL,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          // Show the placeholder image on error
                          return Image.asset(
                            'assets/images/profileimage.png',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/profileimage.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenWidth * .005),
                Text(
                  widget.court.courtName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: titleFontSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MyDivider(),
                    Text(
                      '${S.of(context).From_} $formattedStartDate',
                      style: TextStyle(
                        color: const Color(0xFF6D6D6D),
                        fontSize: subtitleFontSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenWidth * .015),
                    Text(
                      '${S.of(context).To_} $formattedEndDate',
                      style: TextStyle(
                        color: const Color(0xFF6D6D6D),
                        fontSize: subtitleFontSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenWidth * .015),
                    Text(
                      '${S.of(context).Address_} ${widget.court.courtAddress}',
                      style: TextStyle(
                        color: const Color(0xFF6D6D6D),
                        fontSize: subtitleFontSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenWidth * .03),
                  ],
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: _courtStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(S.of(context).Error_fetching_data);
                    }

                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final courtData = snapshot.data?.data();
                    if (courtData == null) {
                      return Text(S.of(context).No_data_available);
                    }

                    final bool isReversed = courtData['reversed'] ?? false;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: buttonWidth / 1.4,
                          height: buttonHeight,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF1B262C),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(buttonHeight / 2),
                            ),
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (canTap) {
                                  _currentPlayerCourts(widget.court.courtId);
                                  _updateCourtReservedStatus(
                                      widget.court.courtId);
                                  canTap = false;
                                  widget.courtNameController!.text =
                                      widget.court.courtName;
                                  setState(() {});
                                }
                              },
                              child: Text(
                                isReversed
                                    ? S.of(context).Occupied
                                    : S.of(context).Get_Reserved,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: buttonTextFontSize,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Adjust the spacing as needed
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // New "Cancel Reservation" Button
                            Container(
                              width: buttonWidth / 2,
                              height: buttonHeight,
                              decoration: ShapeDecoration(
                                color:
                                    Colors.red, // You can customize the color
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(buttonHeight / 2),
                                ),
                              ),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (!canTap) {
                                      _cancelReservation(widget.court.courtId);
                                      canTap = true; // Reset the tap status
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'This Court didn\'t reverse yet.')),
                                      );
                                    }
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: buttonTextFontSize,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            // Rest of the Row content
                          ],
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: screenHeight * .01),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
