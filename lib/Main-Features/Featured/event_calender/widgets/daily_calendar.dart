import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'appointment_data_source.dart';

class DailyCalendar extends StatelessWidget {
  final List<Appointment> appointments;

  DailyCalendar(this.appointments);

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.day,
      showDatePickerButton: true,
      allowDragAndDrop: true,
      dataSource: AppointmentDataSource(appointments),
      scheduleViewSettings: const ScheduleViewSettings(
        appointmentItemHeight: 70,
      ),
      timeSlotViewSettings: TimeSlotViewSettings(
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
