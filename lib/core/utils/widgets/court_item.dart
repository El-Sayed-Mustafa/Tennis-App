import 'package:flutter/material.dart';

import '../../../Main-Features/home/widgets/divider.dart';
import '../../../models/court.dart';
import 'package:intl/intl.dart';

class CourtItem extends StatelessWidget {
  CourtItem({Key? key, required this.court}) : super(key: key);
  final Court court;
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
    final DateTime startDate = dateTimeFormat.parse(court.startDate.toString());
    final DateTime endDate = dateTimeFormat.parse(court.endDate.toString());

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
            side: BorderSide(width: 0.50, color: Color(0x440D5FC3)),
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
                child: court.photoURL != ''
                    ? FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loadin.gif',
                        image: court.photoURL!,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  court.courtName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: titleFontSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const MyDivider(),
                Text(
                  'From : $formattedStartDate',
                  style: TextStyle(
                    color: Color(0xFF6D6D6D),
                    fontSize: subtitleFontSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenWidth * .015),
                Text(
                  'To : $formattedEndDate',
                  style: TextStyle(
                    color: Color(0xFF6D6D6D),
                    fontSize: subtitleFontSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenWidth * .015),
                Text(
                  'Adress : ${court.courtAddress}',
                  style: TextStyle(
                    color: Color(0xFF6D6D6D),
                    fontSize: subtitleFontSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenWidth * .03),
                Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1B262C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonHeight / 2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Get Reserved',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: buttonTextFontSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
