import 'package:flutter/material.dart';

class GenderSelection extends StatefulWidget {
  const GenderSelection({super.key});

  @override
  _GenderSelectionState createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  String selectedGender = 'Male'; // Initially no gender selected

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.6,
      height: screenHeight * 0.07,
      decoration: ShapeDecoration(
        color: Color(0x1EFFA372),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: screenHeight * .05, child: _buildGenderButton('Male')),
          SizedBox(width: screenWidth * 0.04),
          SizedBox(
            height: screenHeight * .05,
            child: _buildGenderButton('Female'),
          )
        ],
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
        duration: Duration(milliseconds: 300),
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.035,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : null,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            gender,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: isSelected ? 18 : 15,
              fontWeight: FontWeight.w500,
              color: isSelected ? Color(0xFF00344E) : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }
}
