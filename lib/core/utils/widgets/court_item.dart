import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/Featured/court_details/court_details_screen.dart';

import '../../../Main-Features/home/widgets/divider.dart';
import '../../../generated/l10n.dart';
import '../../../models/court.dart';
import 'package:intl/intl.dart';

class CourtItem extends StatefulWidget {
  const CourtItem(
      {Key? key,
      required this.court,
      this.courtNameController,
      required this.isSaveUser})
      : super(key: key);
  final Court court;
  final bool isSaveUser;
  final TextEditingController? courtNameController; // Optional parameter

  @override
  State<CourtItem> createState() => _CourtItemState();
}

class _CourtItemState extends State<CourtItem> {
  bool canTap = true;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double itemWidth = screenWidth * 0.9;
    final double imageHeight = screenHeight * 0.12;
    final double titleFontSize = screenHeight * 0.031;
    final double subtitleFontSize = screenHeight * 0.015;
    final double buttonTextFontSize = screenHeight * 0.015;
    final double buttonWidth = itemWidth * 0.4;
    final double buttonHeight = screenHeight * 0.035;

    final DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateTime startDate =
        dateTimeFormat.parse(widget.court.availableDay.toString());

    final String formattedStartDate =
        DateFormat('MMMM d, yyyy').format(startDate);
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
              child: SizedBox(
                height: imageHeight * 1.1,
                width: imageHeight,
                child: widget.court.photoURL != ''
                    ? FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loadin.gif',
                        image: widget.court.photoURL,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          // Show the placeholder image on error
                          return Image.asset(
                            'assets/images/profile-event.jpg',
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/profile-event.jpg',
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
                      '${S.of(context).at} : $formattedStartDate',
                      style: TextStyle(
                        color: const Color(0xFF6D6D6D),
                        fontSize: subtitleFontSize,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenWidth * .015),
                    Text(
                      widget.court.courtAddress != ''
                          ? '${S.of(context).Address_} ${widget.court.courtAddress}'
                          : ' ${S.of(context).Address_} No address',
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourtDetailsScreen(
                          courtNameController: widget.courtNameController,
                          court: widget.court,
                          isSaveUser: widget.isSaveUser,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: buttonWidth / 1.4,
                    height: buttonHeight,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1B262C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(buttonHeight / 2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        S.of(context).Get_Reserved,
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
                SizedBox(height: screenHeight * .01),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
