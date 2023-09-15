// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/set_reminder/service/notification_service.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';

import '../../../core/utils/snackbar.dart';
import '../../../core/utils/widgets/input_date_and_time.dart';
import '../../../generated/l10n.dart';
import '../../../models/event.dart';
import '../../club/widgets/club_event_item.dart';
import '../Event/create_event/view/widgets/input_end_date.dart';
import 'model/database_helper.dart';
import 'model/evenet_data.dart';

// ignore: must_be_immutable
class SetReminder extends StatelessWidget {
  SetReminder({Key? key, required this.event}) : super(key: key);

  final Event event;
  final TextEditingController eventNameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  // Database helper instance
  final dbHelper = DatabaseHelper();

  // Method to save the event to the database
  Future<void> saveEvent(
      DateTime startTime, DateTime endTime, String subject, Color color) async {
    final event = EventModel(
      startTime: startTime,
      endTime: endTime,
      subject: subject,
      color: color,
    );
    await dbHelper.insertEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double spacing = screenHeight * 0.01;
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
              text: S.of(context).set_reminder,
              suffixIconPath: '',
            ),
            ClubEventItem(
              event: event,
              showSetReminder: false,
            ),
            SizedBox(height: spacing * 3),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * .13, bottom: 4),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  S.of(context).set_reminder,
                  style: const TextStyle(
                    color: Color(0xB2313131),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              width: screenWidth * .8,
              padding: const EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.50, color: Color(0x440D5FC3)),
                  borderRadius: BorderRadius.circular(31),
                ),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * .03),
                    InputDateAndTime(
                      text: S.of(context).set_reminder,
                      hint: 'Select the reminder time ',
                      onDateTimeSelected: (DateTime dateTime) {},
                    ),
                    SizedBox(height: screenHeight * .03),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomSheetContainer(
        buttonText: S.of(context).Set_Reminder,
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            try {
              DateTime? endDate = context.read<EndDateTimeCubit>().state;
              DateTime? startDate = context.read<DateTimeCubit>().state;

              // Get a random color from the Google Calendar-like colors
              Color color = GoogleCalendarColors.getRandomEventColor();

              // Save the event to the database
              await saveEvent(startDate, endDate, event.eventName, color);

              NotificationApi.showSchaduleNotification(
                title: event.eventName,
                body: S.of(context).your_event_will_start_now,
                scheduleDate: startDate,
              );
              GoRouter.of(context).push('/calendar');
            } catch (e) {
              // Handle any exceptions that occurred during event saving
              showSnackBar(context, 'Error saving event: $e');
              // You can show a snackbar, dialog, or any other error message to the user.
            }
          }
        },
      ),
    );
  }
}

class GoogleCalendarColors {
  static final List<Color> eventColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.deepOrange,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
  ];

  static Color getRandomEventColor() {
    // Generate a random index to pick a color from the eventColors list
    int randomIndex = Random().nextInt(eventColors.length);
    return eventColors[randomIndex];
  }
}
