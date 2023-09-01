import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/chosen_court.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import 'package:tennis_app/generated/l10n.dart';
import 'package:tennis_app/models/event.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key, required this.event});
  final Event event;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PoPAppBarWave(
              prefixIcon: IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              text: "Event Details",
              suffixIconPath: '',
            ),
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: (screenHeight + screenWidth) * 0.025,
                      right: (screenHeight + screenWidth) * 0.025,
                      top: (screenHeight + screenWidth) * 0.05),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: (screenHeight + screenWidth) * 0.06,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 0.50, color: Color(0x440D5FC3)),
                          borderRadius: BorderRadius.circular(31),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Text(
                              event.eventName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).start,
                                  style: const TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM d, yyyy HH:mm')
                                      .format(event.eventEndsAt),
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).end,
                                  style: const TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  DateFormat('MMM d, yyyy HH:mm')
                                      .format(event.eventEndsAt),
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).Event_Type,
                                  style: const TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  event.eventType,
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).Address,
                                  style: const TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  event.eventAddress,
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            const Text(
                              "Court Reversed",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF6D6D6D),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ChosenCourt(
                              courtId: event.courtName,
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center, // Center the photo
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            (screenHeight + screenWidth) * 0.08 / 3),
                        child: Container(
                          height: (screenHeight + screenWidth) * 0.1,
                          width: (screenHeight + screenWidth) * 0.08,
                          child: event.photoURL != null
                              ? Image.network(
                                  event.photoURL!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/profileimage.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
