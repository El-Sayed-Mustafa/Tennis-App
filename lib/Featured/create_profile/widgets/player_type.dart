import 'package:flutter/material.dart';

class PlayerType extends StatefulWidget {
  const PlayerType({super.key});

  @override
  State<PlayerType> createState() => _PlayerTypeState();
}

class _PlayerTypeState extends State<PlayerType> {
  String selectedGender = 'Singles'; // Initially no gender selected

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.8,
      height: 55,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0x300D5FC3)),
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
                child: _buildGenderButton('Singles')),
            Spacer(),
            SizedBox(
              height: screenHeight * .05,
              width: screenWidth * .35,
              child: _buildGenderButton('Doubles'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
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
                    offset: Offset(0, 2),
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
