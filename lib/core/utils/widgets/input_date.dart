import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Define the cubit state
class DateCubit extends Cubit<DateTime> {
  DateCubit() : super(DateTime.now());

  void selectDateTime(DateTime dateTime) {
    emit(dateTime);
  }
}

class InputDate extends StatelessWidget {
  final String text;
  final String hint;

  const InputDate({
    Key? key,
    required this.text,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<DateCubit, DateTime>(
      builder: (context, selectedDateTime) {
        final DateFormat dateFormat = DateFormat('MMM d, yyyy, h:mm a');

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * .1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 2.0, left: screenWidth * .055),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF525252),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: screenWidth * .8,
                height: screenHeight * .05,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0x300A557F)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: screenHeight * .005, left: 24),
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDateTime,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (picked != null) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                        );

                        if (pickedTime != null) {
                          final newDateTime = DateTime(
                            picked.year,
                            picked.month,
                            picked.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          // Use the cubit to update the selected date and time
                          context.read<DateCubit>().selectDateTime(newDateTime);
                        }
                      }
                    },
                    child: IgnorePointer(
                      child: Expanded(
                        child: TextField(
                          readOnly: true,
                          style: const TextStyle(
                            color: Color(0xFF6E6E6E),
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: hint,
                            hintStyle: const TextStyle(
                              color: Color(0xFFA8A8A8),
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_month_outlined,
                                  size: 22),
                              onPressed: () {},
                            ),
                          ),
                          controller: TextEditingController(
                            text: dateFormat.format(selectedDateTime),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
