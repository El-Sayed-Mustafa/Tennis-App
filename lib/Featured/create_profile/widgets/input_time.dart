import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/time_cubit.dart';

class InputTimeField extends StatelessWidget {
  final String text;
  final String hint;

  const InputTimeField({
    Key? key,
    required this.text,
    required this.hint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final timeCubit = context.watch<TimeCubit>();

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
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: screenWidth * .8,
            height: 44,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0x300A557F)),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
              child: TextFormField(
                readOnly: true,
                onTap: () {
                  timeCubit.selectTime(context);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Color(0xFFA8A8A8),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                controller: TextEditingController(
                  text: timeCubit.state != null
                      ? timeCubit.state!.format(context)
                      : '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid time';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
