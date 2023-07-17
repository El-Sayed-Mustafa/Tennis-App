import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  int selectedPageIndex = 0;
  final CarouselController _carouselController = CarouselController();
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('players')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final playerData = snapshot.data!.data();
          final List<String> eventIds =
              (playerData?['eventIds'] as List<dynamic>?)
                      ?.map((id) => id.toString())
                      .toList() ??
                  [];
          if (eventIds.isEmpty) {
            return const Card(
              margin: EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 48.0,
                      color: Color(0xFF00344E),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Register for the events\n to view them here',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.265,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.5,
                  onPageChanged: (index, _) {
                    setState(() {
                      selectedPageIndex = index;
                    });
                  },
                ),
                carouselController: _carouselController,
                items: eventIds.map((eventId) {
                  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: eventsCollection.doc(eventId).get()
                        as Future<DocumentSnapshot<Map<String, dynamic>>>,
                    builder: (context, eventSnapshot) {
                      if (eventSnapshot.hasData) {
                        final eventData = eventSnapshot.data!.data()!;
                        final String eventName = eventData['eventName'];
                        final DateTime eventStartAt =
                            eventData['eventStartAt'].toDate();
                        final DateTime eventEndsAt =
                            eventData['eventEndsAt'].toDate();
                        final String eventAddress = eventData['eventAddress'];
                        final String eventType = eventData['eventType'];
                        final String courtName = eventData['courtName'];
                        final String instructions = eventData['instructions'];
                        final List<String> playerIds =
                            List<String>.from(eventData['playerIds'] ?? []);
                        final double playerLevel = eventData['playerLevel'];
                        final String clubId = eventData['clubId'];
                        final String? photoURL = eventData['photoURL'];

                        return CarouselItem(
                          selected:
                              selectedPageIndex == eventIds.indexOf(eventId),
                          screenWidth: MediaQuery.of(context).size.width,
                          eventName: eventName,
                          eventStartAt: eventStartAt,
                          eventEndsAt: eventEndsAt,
                          eventAddress: eventAddress,
                          eventType: eventType,
                          courtName: courtName,
                          instructions: instructions,
                          playerIds: playerIds,
                          playerLevel: playerLevel,
                          clubId: clubId,
                          photoURL: photoURL,
                        );
                      } else if (eventSnapshot.hasError) {
                        return const Center(
                          child: Text('Error fetching event data'),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              buildPageIndicator(eventIds.length),
            ],
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Error fetching player data'),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildPageIndicator(int itemCount) {
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
            margin: const EdgeInsets.symmetric(horizontal: 4),
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
  final double screenWidth;
  final String eventName;
  final DateTime eventStartAt;
  final DateTime eventEndsAt;
  final String eventAddress;
  final String eventType;
  final String courtName;
  final String instructions;
  final List<String> playerIds;
  final double playerLevel;
  final String clubId;
  final String? photoURL;

  const CarouselItem({
    Key? key,
    required this.selected,
    required this.screenWidth,
    required this.eventName,
    required this.eventStartAt,
    required this.eventEndsAt,
    required this.eventAddress,
    required this.eventType,
    required this.courtName,
    required this.instructions,
    required this.playerIds,
    required this.playerLevel,
    required this.clubId,
    this.photoURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemWidth = screenWidth * 0.6;
    final double itemHeight = screenHeight * .3;

    final double scaleFactor = selected ? 1.0 : 0.72;

    final Color backgroundColor =
        selected ? const Color(0xFFFCCBB1) : const Color(0xFFF3ADAB);
    print(photoURL);
    return Container(
      width: 500,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.079),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: photoURL != null
                  ? NetworkImage(photoURL!)
                  : Image.asset('assets/images/profile-event.jpg').image,
              radius: (itemHeight * 0.15) * scaleFactor,
            ),
          ),
          SizedBox(height: itemHeight * 0.03),
          Text(
            eventName,
            style: TextStyle(
              color: const Color(0xFF2A2A2A),
              fontSize: itemHeight * 0.06 * scaleFactor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: itemHeight * 0.03),
          Text(
            '${eventStartAt.hour}:${eventStartAt.minute} \n${eventStartAt.day}/${eventStartAt.month}/${eventStartAt.year}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF00344E),
              fontSize: itemHeight * 0.051 * scaleFactor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: itemHeight * 0.03),
          Container(
            width: itemWidth * 0.55 * scaleFactor,
            height: itemHeight * 0.125 * scaleFactor,
            decoration: ShapeDecoration(
              color: const Color(0xFF1B262C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.089),
              ),
            ),
            child: Center(
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: itemHeight * 0.056 * scaleFactor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
