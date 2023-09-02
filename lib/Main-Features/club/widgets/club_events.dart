import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/core/utils/widgets/no_data_text.dart';
import 'package:tennis_app/generated/l10n.dart';

import '../../../models/event.dart';
import 'club_event_item.dart';

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

      // Check if the event exists in Firestore before adding it
      if (eventSnapshot.exists) {
        final event = Event.fromSnapshot(eventSnapshot);
        fetchedEvents.add(event);
      } else {
        // Handle the case where the event doesn't exist
        print('Event with ID $eventId does not exist in Firestore.');
      }
    }

    setState(() {
      clubEvents = fetchedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double carouselHeight = screenHeight * 0.26;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        if (clubEvents.isNotEmpty)
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
            carouselController: _carouselController,
            items: clubEvents.map((event) {
              return ClubEventItem(
                event: event,
                showSetReminder: true,
              );
            }).toList(),
          )
        else
          NoData(
            text: S.of(context).You_Dont_have_Events,
            height: screenHeight * .2,
            width: screenWidth * .8,
          ),
        SizedBox(height: 8),
        buildPageIndicator(clubEvents.isNotEmpty ? clubEvents.length : 1),
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
