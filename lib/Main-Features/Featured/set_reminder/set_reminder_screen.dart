import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/set_reminder/service/notification_service.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../core/utils/widgets/app_bar_wave.dart';
import '../../../core/utils/widgets/input_date_and_time.dart';
import '../../../core/utils/widgets/text_field.dart';
import '../../../models/event.dart';
import '../../club/widgets/club_event_item.dart';
import '../../club/widgets/header_text.dart';
import '../create_event/view/widgets/event_types.dart';
import '../create_event/view/widgets/input_end_date.dart';
import 'model/database_helper.dart';
import 'model/evenet_data.dart';

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
            AppBarWaveHome(
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
              text: '   Set Reminder',
              suffixIconPath: '',
            ),
            ClubEventItem(
              event: event,
              showSetReminder: false,
            ),
            SizedBox(height: spacing * 3),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * .13, bottom: 4),
              child: const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Set Reminder',
                  style: TextStyle(
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
              padding: EdgeInsets.all(20),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Color(0x440D5FC3)),
                  borderRadius: BorderRadius.circular(31),
                ),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * .01),
                    InputTextWithHint(
                      hint: 'Type event name here',
                      text: 'Event Name',
                      controller: eventNameController,
                    ),
                    SizedBox(height: screenHeight * .03),
                    InputDateAndTime(
                      text: 'Event Start',
                      hint: 'Select start date and time',
                      onDateTimeSelected: (DateTime dateTime) {},
                    ),
                    SizedBox(height: screenHeight * .03),
                    InputEndDateAndTime(
                      text: 'Event End',
                      hint: 'Select end date and time',
                      onDateTimeSelected: (DateTime dateTime) {},
                    ),
                    SizedBox(height: screenHeight * .01),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomSheetContainer(
        buttonText: 'Set Reminder',
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            try {
              DateTime? endDate = context.read<EndDateTimeCubit>().state;
              DateTime? startDate = context.read<DateTimeCubit>().state;
              String name = eventNameController.text;
              Color color = Colors.blue; // Replace this with your desired color

              // Save the event to the database
              await saveEvent(startDate!, endDate!, name, color);

              NotificationApi.showSchaduleNotification(
                  title: name,
                  body: "Your Event will start now",
                  scheduleDate: startDate);
              GoRouter.of(context).push('/calendar');
            } catch (e) {
              // Handle any exceptions that occurred during event saving
              print('Error saving event: $e');
              // You can show a snackbar, dialog, or any other error message to the user.
            }
          }
        },
        color: Colors.transparent,
      ),
    );
  }
}
