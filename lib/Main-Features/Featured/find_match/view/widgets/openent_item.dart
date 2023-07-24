import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../../models/Match.dart';
import '../../../../club/widgets/text_rich.dart';
import '../../../../home/widgets/divider.dart';
import 'package:intl/intl.dart';

class OpponentItem extends StatefulWidget {
  const OpponentItem({super.key, required this.match});
  final Matches match;

  @override
  State<OpponentItem> createState() => _OpponentItemState();
}

class _OpponentItemState extends State<OpponentItem> {
  bool hasInternet =
      true; // Add a boolean variable to track internet connectivity

  @override
  void initState() {
    super.initState();
    checkInternetConnectivity();
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = (screenHeight + screenWidth) * 0.08;

    return SizedBox(
      height: screenHeight * .3,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: screenWidth * .1),
              width: screenWidth,
              height: screenHeight * .25,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(31),
                boxShadow: const [
                  BoxShadow(
                    color: Color(
                        0x440D5FC3), // Shadow color with opacity (adjust the alpha value)
                    blurRadius:
                        5.0, // Adjust the blur radius as per your preference
                    spreadRadius:
                        1.0, // Adjust the spread radius as per your preference
                    offset: Offset(0,
                        3), // Adjust the offset to control the position of the shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.match
                        .playerName, // Access the member's name from the Player object
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const MyDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(imageHeight / 3),
                            child: Container(
                              height: imageHeight * 1.3,
                              width: imageHeight,
                              child:
                                  hasInternet // Check if there's internet connection
                                      ? (widget.match.photoURL != null
                                          ? FadeInImage.assetNetwork(
                                              placeholder:
                                                  'assets/images/loadin.gif',
                                              image: widget.match.photoURL!,
                                              fit: BoxFit.cover,
                                              imageErrorBuilder:
                                                  (context, error, stackTrace) {
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
                                            ))
                                      : Image.asset(
                                          'assets/images/loadin.gif',
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * .005,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextRich(
                            text1: 'Player Type ',
                            text2: widget.match.playerType,
                          ),
                          SizedBox(height: screenHeight * .01),
                          MyTextRich(
                              text1: 'Address ', text2: widget.match.address),
                          SizedBox(height: screenHeight * .01),
                          MyTextRich(
                            text1: 'Date ',
                            text2: DateFormat('MMM d, yyyy')
                                .format(widget.match.dob),
                          ),
                          SizedBox(height: screenHeight * .01),
                          MyTextRich(
                            text1: 'Preferred time  ',
                            text2: widget.match.preferredPlayingTime,
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Column(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: BottomSheetContainer(
                    buttonText: 'Play',
                    onPressed: () {},
                    color: Colors.transparent),
              )
            ],
          )
        ],
      ),
    );
    ;
  }
}
