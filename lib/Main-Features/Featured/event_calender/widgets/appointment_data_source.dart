import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentDataSource extends CalendarDataSource {
  final List<Appointment> appointments;

  AppointmentDataSource(this.appointments);
}
