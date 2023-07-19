import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgeRestrictionCubit extends Cubit<int> {
  AgeRestrictionCubit() : super(0);

  void setSelectedValue(int value) {
    emit(value);
  }

  int getSelectedValue() {
    return state;
  }
}

class AgeRestrictionWidget extends StatelessWidget {
  const AgeRestrictionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * .8,
      height: screenHeight * .2,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(31),
        boxShadow: const [
          BoxShadow(
            color: Color(
                0x440D5FC3), // Shadow color with opacity (adjust the alpha value)
            blurRadius: 3.0, // Adjust the blur radius as per your preference
            spreadRadius: .5, // Adjust the spread radius as per your preference
            offset: Offset(0,
                3), // Adjust the offset to control the position of the shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: screenWidth * .07, top: 16, bottom: 8),
            child: const Text(
              'Age restriction',
              style: TextStyle(
                color: Color(0xFF525252),
                fontSize: 17,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          BlocBuilder<AgeRestrictionCubit, int>(
            builder: (context, selectedValue) {
              return Column(
                children: [
                  AgeOptionRow(
                    value: 1,
                    label: 'Above 20',
                    selectedValue: selectedValue,
                    onChanged: (value) {
                      final cubit = context.read<AgeRestrictionCubit>();
                      cubit.setSelectedValue(value);
                    },
                  ),
                  AgeOptionRow(
                    value: 2,
                    label: 'Above 18',
                    selectedValue: selectedValue,
                    onChanged: (value) {
                      final cubit = context.read<AgeRestrictionCubit>();
                      cubit.setSelectedValue(value);
                    },
                  ),
                  AgeOptionRow(
                    value: 3,
                    label: 'Everyone',
                    selectedValue: selectedValue,
                    onChanged: (value) {
                      final cubit = context.read<AgeRestrictionCubit>();
                      cubit.setSelectedValue(value);
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class AgeOptionRow extends StatelessWidget {
  final int value;
  final String label;
  final int selectedValue;
  final ValueChanged<int> onChanged;

  const AgeOptionRow({
    Key? key,
    required this.value,
    required this.label,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

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
              onChanged: (value) => onChanged(value!),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
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
