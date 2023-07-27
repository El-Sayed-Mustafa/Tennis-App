import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Main-Features/club/widgets/text_rich.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';

import '../../../core/methodes/global_method.dart';
import '../../home/widgets/divider.dart';
import '../../../models/event.dart'; // Import the Event model

class ClubEvents extends StatefulWidget {
  const ClubEvents({Key? key, required this.eventsId}) : super(key: key);
  final List<String> eventsId;
  @override
  State<ClubEvents> createState() => _ClubEventsState();
}

class _ClubEventsState extends State<ClubEvents> {
  int selectedPageIndex = 0;
  final CarouselController _carouselController = CarouselController();
  List<Event> clubEvents = []; // List to store fetched club events

  @override
  void initState() {
    super.initState();
    fetchClubEvents(); // Fetch the club events when the widget is initialized
  }

  void fetchClubEvents() async {
    // Fetch events from Firestore using eventIds in the club collection
    final eventsCollection = FirebaseFirestore.instance.collection('events');
    final List<Event> fetchedEvents = [];
    for (String eventId in widget.eventsId) {
      final eventSnapshot = await eventsCollection.doc(eventId).get();
      final event = Event.fromSnapshot(eventSnapshot);
      fetchedEvents.add(event);
      print(event.clubId);
    }
    setState(() {
      clubEvents = fetchedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    final double carouselHeight = screenHeight * 0.26;

    // Use the fetched clubEvents to build the carouselItems
    final List<Widget> carouselItems = clubEvents.map((event) {
      return CarouselItem(
        selected: selectedPageIndex == clubEvents.indexOf(event),
        event: event,
      );
    }).toList();

    return Column(
      children: [
        CarouselSlider(
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
          carouselController: _carouselController, // Use CarouselController
          items: carouselItems,
        ),
        SizedBox(
          height: 8,
        ),
        buildPageIndicator(
            carouselItems.length), // Add the smooth page indicator
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

class CarouselItem extends StatelessWidget {
  final bool selected;
  final Event event;
  const CarouselItem({Key? key, required this.selected, required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double itemWidth = screenWidth * 0.9;
    final double imageHeight = (screenHeight + screenWidth) * 0.09;
    final double titleFontSize = (screenHeight + screenWidth) * 0.02;
    final double buttonTextFontSize = (screenHeight + screenWidth) * 0.01;
    final double buttonWidth = itemWidth * 0.4;
    final double buttonHeight = screenHeight * 0.035;
    GlobalMethod globalMethod = GlobalMethod();

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * .007),
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
              Column(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(imageHeight / 5),
                      child: Container(
                          height: imageHeight,
                          width: imageHeight,
                          child: event.photoURL != null &&
                                  event.photoURL!.isNotEmpty
                              ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/loadin.gif',
                                  image: event.photoURL!,
                                  fit: BoxFit.cover,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
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
                                ))),
                  SizedBox(height: screenHeight * .01),
                  SizedBox(
                    height: screenHeight * .03,
                    child: SvgPicture.asset(
                      'assets/images/sun.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: screenHeight * .003),
                  Text(
                    'Sunny',
                    style: TextStyle(
                      color: Color(0xFF00344E),
                      fontSize: screenHeight * .017,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventType,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: titleFontSize,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const MyDivider(),
                  MyTextRich(
                    text1: 'Start',
                    text2: globalMethod
                        .formatDateTimeString(event.eventStartAt.toString()),
                  ),
                  SizedBox(height: screenHeight * .012),
                  MyTextRich(
                    text2: globalMethod
                        .formatDateTimeString(event.eventEndsAt.toString()),
                    text1: 'End',
                  ),
                  SizedBox(height: screenHeight * .012),
                  MyTextRich(
                    text1: 'At',
                    text2: event.eventAddress,
                  ),
                  SizedBox(height: screenHeight * .012),
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
                        'Set Reminder',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: buttonTextFontSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
