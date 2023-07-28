import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'appointment_data_source.dart';

class MonthlyCalendar extends StatelessWidget {
  final List<Appointment> appointments;

  MonthlyCalendar(this.appointments);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      dataSource: AppointmentDataSource(appointments),
      view: CalendarView.week,
      timeSlotViewSettings:
          TimeSlotViewSettings(timeInterval: Duration(hours: 2)),
    );
  }
}
