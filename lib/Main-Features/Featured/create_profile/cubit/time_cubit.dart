import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class TimeCubit extends Cubit<TimeOfDay?> {
  TimeCubit() : super(null);

  void selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      emit(pickedTime);
    }
  }
}
