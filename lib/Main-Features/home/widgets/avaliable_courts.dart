import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/widgets/button_home.dart';
import '../../../core/utils/widgets/court_item.dart';
import '../../../models/player.dart';
import '../../../models/court.dart'; // Import the Court class

class AvailableCourts extends StatefulWidget {
  const AvailableCourts({Key? key}) : super(key: key);

  @override
  State<AvailableCourts> createState() => _AvailableCourtsState();
}

class _AvailableCourtsState extends State<AvailableCourts> {
  int selectedPageIndex = 0;
  final CarouselController _carouselController = CarouselController();
  List<String> reversedCourtsIds = []; // List to store reversed court IDs

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
        print('No user is currently signed in.');
        return;
      }

      String currentUserId = currentUser.uid;

      DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(currentUserId)
              .get();

      if (!playerSnapshot.exists) {
        print('Player document does not exist for current user.');
        return;
      }

      // Create a Player instance from the snapshot data
      Player currentPlayer = Player.fromSnapshot(playerSnapshot);

      // Get the reversedCourtsIds from the Player instance
      reversedCourtsIds = currentPlayer.reversedCourtsIds;

      // Update the carousel with the fetched data
      setState(() {});
    } catch (error) {
      print('Error fetching reversed courts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    final double carouselHeight = screenHeight * 0.215;

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
                        return Text('Error fetching court data');
                      }

                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      final courtData = snapshot.data?.data();
                      if (courtData == null) {
                        return Text('No court data available');
                      }

                      // Create a Court instance from the snapshot data
                      final Court court = Court.fromSnapshot(snapshot.data!);

                      // Build the carousel item using the CourtItem widget
                      return CourtItem(court: court);
                    },
                  );
                }).toList(),
              )
            : Container(
                color: Colors.white,
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons
                            .sentiment_dissatisfied_sharp, // Replace 'Icons.sports_tennis' with your chosen icon
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                    HomeButton(
                      buttonText: 'Find Court',
                      imagePath: 'assets/images/Find-Court.svg',
                      onPressed: () {
                        GoRouter.of(context).push('/findCourt');
                      },
                    ),
                  ],
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
