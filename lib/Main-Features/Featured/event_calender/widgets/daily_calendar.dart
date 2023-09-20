import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tennis_app/Main-Features/Featured/Event/event_details/event_details_screen.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import '../../set_reminder/model/evenet_data.dart';
import 'appointment_data_source.dart';

class DailyCalendar extends StatelessWidget {
  final List<EventModel> events;

  const DailyCalendar(this.events, {super.key});
  Future<void> _handleEventTap(
      BuildContext context, CalendarTapDetails details) async {
    final EventModel event = details.appointments![0];
    Method method = Method();
    final eventData = await method.fetchEventById(event.eventId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(
          event: eventData!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataSource = AppointmentDataSource(events);
    return SfCalendar(
      onTap: (CalendarTapDetails details) {
        _handleEventTap(context, details);
      },
      dataSource: dataSource,
      view: CalendarView.day,
      showDatePickerButton: true,
      allowDragAndDrop: true,
      scheduleViewSettings: const ScheduleViewSettings(
        appointmentItemHeight: 70,
      ),
      timeSlotViewSettings: const TimeSlotViewSettings(
        numberOfDaysInView: 1,
        timeTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 15,
          color: Colors.black,
        ),
      ),
    );
  }
}
