import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/time_cubit.dart';

class InputTimeField extends StatefulWidget {
  final String text;
  final String hint;
  final ValueChanged<TimeOfDay?> onTimeSelected;

  const InputTimeField({
    Key? key,
    required this.text,
    required this.hint,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  _InputTimeFieldState createState() => _InputTimeFieldState();
}

class _InputTimeFieldState extends State<InputTimeField> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = context.read<TimeCubit>().state?.format(context) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<TimeCubit, TimeOfDay?>(
      builder: (context, selectedTime) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * .1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 2.0, left: screenWidth * .055),
                child: Text(
                  widget.text,
                  style: const TextStyle(
                    color: Color(0xFF525252),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
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
                      const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                  child: InkWell(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        widget.onTimeSelected(pickedTime);
                        setState(() {
                          _controller.text = pickedTime.format(context);
                        });
                      }
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: widget.hint,
                          hintStyle: const TextStyle(
                            color: Color(0xFFA8A8A8),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        controller: _controller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid time';
                          }
                          return null;
                        },
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
