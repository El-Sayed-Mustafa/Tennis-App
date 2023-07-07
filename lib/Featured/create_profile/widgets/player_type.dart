import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/player_type_cubit.dart';

class PlayerType extends StatelessWidget {
  const PlayerType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final genderCubit = context.watch<PlayerTypeCubit>();

    return Container(
      width: screenWidth * 0.8,
      height: 55,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x300D5FC3)),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * .05,
              width: screenWidth * .35,
              child: _buildGenderButton(context, 'Singles', genderCubit.state),
            ),
            Spacer(),
            SizedBox(
              height: screenHeight * .05,
              width: screenWidth * .35,
              child: _buildGenderButton(context, 'Doubles', genderCubit.state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(
    BuildContext context,
    String gender,
    String? selectedGender,
  ) {
    final isSelected = selectedGender == gender;
    final genderCubit = context.read<PlayerTypeCubit>();

    return GestureDetector(
      onTap: () {
        genderCubit.selectGender(gender);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.035,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : null,
          borderRadius: BorderRadius.circular(50),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isSelected ? 18 : 15,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFF00344E) : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
