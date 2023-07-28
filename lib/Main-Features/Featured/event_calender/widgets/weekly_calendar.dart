import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'appointment_data_source.dart';

class WeeklyCalendar extends StatelessWidget {
  final List<Appointment> appointments;

  WeeklyCalendar(this.appointments);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.schedule,
      scheduleViewSettings: const ScheduleViewSettings(
        weekHeaderSettings: WeekHeaderSettings(
          startDateFormat: 'dd MMM ',
          endDateFormat: 'dd MMM, yy',
          height: 50,
          textAlign: TextAlign.center,
          backgroundColor: Colors.red,
          weekTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
        ),
        dayHeaderSettings: DayHeaderSettings(
          dayFormat: 'EEEE',
          width: 70,
          dayTextStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w300,
            color: Colors.red,
          ),
          dateTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Colors.red,
          ),
        ),
        monthHeaderSettings: MonthHeaderSettings(
          monthFormat: 'MMMM, yyyy',
          height: 100,
          textAlign: TextAlign.left,
          backgroundColor: Colors.green,
          monthTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      dataSource: AppointmentDataSource(appointments),
    );
  }
}
