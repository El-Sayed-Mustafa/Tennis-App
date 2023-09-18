import 'package:flutter/material.dart';

class HoursOfDayDropdown extends StatefulWidget {
  final String labelText;
  final ValueNotifier<String> selectedHourNotifier;

  const HoursOfDayDropdown(
      {super.key, required this.labelText, required this.selectedHourNotifier});

  @override
  _HoursOfDayDropdownState createState() => _HoursOfDayDropdownState();
}

class _HoursOfDayDropdownState extends State<HoursOfDayDropdown> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final List<String> hours = List.generate(24, (index) {
      String hour = index.toString().padLeft(2, '0');
      return '$hour:00';
    });

    return SizedBox(
      width: screenWidth * 0.4,
      child: DropdownButtonFormField<String>(
        value: widget.selectedHourNotifier.value,
        items: hours.map((String hour) {
          return DropdownMenuItem<String>(
            value: hour,
            child: Text(hour),
          );
        }).toList(),
        onChanged: (String? newValue) {
          widget.selectedHourNotifier.value =
              newValue!; // Update the ValueNotifier value
        },
        isDense: true,
        itemHeight: 50,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          labelText: widget.labelText,
          fillColor: Colors.white,
          filled: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(100.0),
            ),
          ),
        ),
      ),
    );
  }
}
