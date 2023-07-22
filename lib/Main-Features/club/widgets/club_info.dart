import 'package:flutter/material.dart';
import 'package:tennis_app/models/club.dart'; // Import the Club class
import '../../Featured/choose_club/widgets/static_rating_bar.dart';
import '../../home/widgets/divider.dart';

class ClubInfo extends StatelessWidget {
  final Club clubData; // Add a parameter for clubData

  const ClubInfo({Key? key, required this.clubData}) : super(key: key);

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
                  height: combine * .075,
                  width: combine * .075,
                  child: Image.asset(
                    'assets/images/clubimage.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clubData.clubName, // Use clubData's clubName
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: combine * .02,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const MyDivider(),
                  SizedBox(
                    width: itemWidth * .4,
                    child: Text(
                      clubData.ageRestriction, // Use clubData's clubLocation
                      style: TextStyle(
                        color: const Color(0xFF6D6D6D),
                        fontSize: combine * .01,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * .01),
                  StaticRatingBar(
                    rating: clubData.rate, // Use clubData's rating
                    iconSize: (screenHeight + screenWidth) * .02,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
