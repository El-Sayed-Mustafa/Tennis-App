import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'appointment_data_source.dart';

class MonthlyCalendar extends StatelessWidget {
  final List<Appointment> appointments;

  MonthlyCalendar(this.appointments);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      dataSource: AppointmentDataSource(appointments),
      monthViewSettings: MonthViewSettings(
        appointmentDisplayCount: 2,
        showAgenda: true,
        agendaItemHeight: 70,
      ),
    );
  }
}
