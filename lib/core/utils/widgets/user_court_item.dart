import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tennis_app/Main-Features/home/widgets/divider.dart';
import 'package:tennis_app/generated/l10n.dart';
import 'package:tennis_app/models/court.dart';

class UserCourtItem extends StatelessWidget {
  const UserCourtItem({Key? key, required this.court}) : super(key: key);
  final Court court;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double itemWidth = screenWidth * 0.8;
    final double imageHeight = screenHeight * 0.09;
    final double titleFontSize = screenHeight * 0.02;
    final double subtitleFontSize = screenHeight * 0.0125;

    final DateFormat dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateTime startDate = dateTimeFormat.parse(court.startDate.toString());
    final DateTime endDate = dateTimeFormat.parse(court.endDate.toString());

    final String formattedStartDate =
        DateFormat('MMMM d, yyyy - h:mm a').format(startDate);
    final String formattedEndDate =
        DateFormat('MMMM d, yyyy - h:mm a').format(endDate);

    return Container(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(imageHeight / 3),
              child: SizedBox(
                height: imageHeight * 1.2,
                width: imageHeight,
                child: court.photoURL != ''
                    ? FadeInImage.assetNetwork(
                        placeholder: 'assets/images/loadin.gif',
                        image: court.photoURL,
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                '${S.of(context).Address_} ${court.courtAddress}',
                style: TextStyle(
                  color: const Color(0xFF6D6D6D),
                  fontSize: subtitleFontSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
