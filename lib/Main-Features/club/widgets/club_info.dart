// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/models/club.dart'; // Import the Club class
import 'package:connectivity_plus/connectivity_plus.dart'; // Import the connectivity_plus plugin
import '../../Featured/choose_club/widgets/static_rating_bar.dart';
import '../../home/widgets/divider.dart';

class ClubInfo extends StatefulWidget {
  final Club clubData; // Add a parameter for clubData

  const ClubInfo({Key? key, required this.clubData}) : super(key: key);

  @override
  _ClubInfoState createState() => _ClubInfoState();
}

class _ClubInfoState extends State<ClubInfo> {
  bool hasInternet =
      true; // Add a boolean variable to track internet connectivity
  double userRating = 0.0; // Default user rating value
  double updatedAverageRating = 0.0;
  bool hasRated = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnectivity();
    updatedAverageRating = widget.clubData.rate;
    checkUserRating();
  }

  void checkUserRating() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userRatingSnapshot =
          await FirebaseFirestore.instance
              .collection('user_ratings')
              .doc(widget.clubData.clubId)
              .get();

      Map<String, dynamic> userRatingData = userRatingSnapshot.data() ?? {};
      double userRatedValue = userRatingData['rating'] ?? 0.0;

      setState(() {
        hasRated = userRatedValue > 0.0;
      });

      print('User has rated: $hasRated');
      print('User rating: $userRatedValue');
    } catch (error) {
      print('Error checking user rating: $error');
    }
  }

  void updateClubRatingInFirestore(double newRating) async {
    try {
      GoRouter.of(context).pop();

      // Fetch the existing club data
      DocumentSnapshot<Map<String, dynamic>> clubSnapshot =
          await FirebaseFirestore.instance
              .collection('clubs')
              .doc(widget.clubData.clubId)
              .get();

      Map<String, dynamic> clubData = clubSnapshot.data() ?? {};
      double existingRating = clubData['rate'] ?? 0.0;
      int numberOfRatings = clubData['numberOfRatings'] ?? 0;

      // Calculate the new average rating
      double newAverageRating = (existingRating * numberOfRatings + newRating) /
          (numberOfRatings + 1);

      setState(() {
        updatedAverageRating = newAverageRating;
      });

      // Update the club document in Firestore
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc(widget.clubData.clubId)
          .update({
        'rate': newAverageRating,
        'numberOfRatings': numberOfRatings + 1,
      });

      // Create a new document in user_ratings collection for the user's rating
      await FirebaseFirestore.instance
          .collection('user_ratings')
          .doc(widget.clubData.clubId)
          .set({
        'rating': newRating,
      });

      // Update the hasRated flag
      setState(() {
        hasRated = true;
      });
    } catch (error) {
      showSnackBar(context, 'Error updating club rating: $error');
    }
  }

  void showRating() {
    if (hasRated) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('You have already rated this club'),
          content: const Text('Thank you for your rating!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Rate This Club'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please leave your rate'),
              buildRating(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                updateClubRatingInFirestore(userRating);
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    }
  }

  Future<void> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        hasInternet = false;
      });
    } else {
      setState(() {
        hasInternet = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double itemWidth = screenWidth * 0.9;
    final double imageHeight = screenHeight * 0.13;
    final combine = (screenHeight + screenWidth);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.041),
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 4, // Adjust the shadow elevation as desired
        shadowColor: Colors.grey, // Set the shadow color
        borderRadius: BorderRadius.circular(screenWidth * 0.079),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.051, vertical: screenHeight * 0.015),
          width: itemWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.079),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(imageHeight / 5),
                child: Container(
                  height: imageHeight,
                  width: imageHeight,
                  child: hasInternet // Check if there's internet connection
                      ? (widget.clubData.photoURL != null &&
                              widget.clubData.photoURL!.isNotEmpty
                          ? FadeInImage.assetNetwork(
                              placeholder: 'assets/images/loadin.gif',
                              image: widget.clubData.photoURL!,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                // Show the placeholder image on error
                                return Image.asset(
                                  'assets/images/internet.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'assets/images/profile-event.jpg',
                              fit: BoxFit.cover,
                            ))
                      : Image.asset(
                          'assets/images/internet.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(
                width: screenWidth * .4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.clubData.clubName, // Use clubData's clubName
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: combine * .02,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const MyDivider(),
                    Text(
                      widget.clubData.address, // Use clubData's clubLocation
                      style: TextStyle(
                          color: const Color(0xFF6D6D6D),
                          fontSize: combine * .01,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                    SizedBox(height: screenHeight * .01),
                    GestureDetector(
                      onTap: showRating,
                      child: StaticRatingBar(
                        rating: updatedAverageRating,
                        iconSize: (screenHeight + screenWidth) * .02,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRating() => RatingBar.builder(
        itemBuilder: (context, index) => const Icon(
          Icons.star,
          color: Colors.yellow,
        ),
        minRating: 1,
        itemSize: 48,
        updateOnDrag: true,
        onRatingUpdate: (userRating) {
          setState(() {
            this.userRating = userRating;
          });
        },
      );
}
