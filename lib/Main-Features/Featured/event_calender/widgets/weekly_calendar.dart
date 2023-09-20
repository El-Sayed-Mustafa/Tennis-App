import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tennis_app/Main-Features/Featured/Event/event_details/event_details_screen.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import '../../set_reminder/model/evenet_data.dart';
import 'appointment_data_source.dart';

class MonthlyCalendar extends StatelessWidget {
  final List<EventModel> events;

  const MonthlyCalendar(this.events, {super.key});
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
      dataSource:
          dataSource, // dataSource: AppointmentDataSource(appointments),
      allowAppointmentResize: true, view: CalendarView.month,
      monthViewSettings: const MonthViewSettings(showAgenda: true),
    );
  }
}
