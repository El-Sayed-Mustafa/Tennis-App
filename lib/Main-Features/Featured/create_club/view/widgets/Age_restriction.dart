import 'package:flutter/material.dart';

class AgeRestrictionWidget extends StatefulWidget {
  const AgeRestrictionWidget({super.key});

  @override
  _AgeRestrictionWidgetState createState() => _AgeRestrictionWidgetState();
}

class _AgeRestrictionWidgetState extends State<AgeRestrictionWidget> {
  int _selectedValue = 0; // Stores the selected radio button value

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth * .8,
      height: screenHeight * .2,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x300A557F)),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: screenWidth * .07, top: 16, bottom: 8),
            child: Text(
              'Age restriction',
              style: TextStyle(
                color: Color(0xFF525252),
                fontSize: 17,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          AgeOptionRow(
            value: 1,
            label: 'Above 20',
            selectedValue: _selectedValue,
            onChanged: _handleRadioValueChanged,
          ),
          AgeOptionRow(
            value: 2,
            label: 'Above 18',
            selectedValue: _selectedValue,
            onChanged: _handleRadioValueChanged,
          ),
          AgeOptionRow(
            value: 3,
            label: 'Everyone',
            selectedValue: _selectedValue,
            onChanged: _handleRadioValueChanged,
          ),
        ],
      ),
    );
  }

  void _handleRadioValueChanged(int? value) {
    setState(() {
      _selectedValue = value!;
    });
  }
}

class AgeOptionRow extends StatelessWidget {
  final int value;
  final String label;
  final int selectedValue;
  final ValueChanged<int?> onChanged;

  const AgeOptionRow({
    super.key,
    required this.value,
    required this.label,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenWidth * .1, vertical: screenHeight * .005),
      child: Row(
        children: [
          Transform.scale(
            scale: .8,
            child: Radio(
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: value,
              groupValue: selectedValue,
              activeColor: Colors.black,
              onChanged: onChanged,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF00344E),
              fontSize: 15,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
