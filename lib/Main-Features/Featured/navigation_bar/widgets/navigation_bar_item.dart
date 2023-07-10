import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/navigation_cubit.dart';

class NavigationBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;

  const NavigationBarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        context.select<NavigationCubit, int>((cubit) => cubit.state);
    final isSelected = currentIndex == index;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 22,
          color: isSelected ? const Color(0xFF00344E) : Colors.grey,
        ),
        if (!isSelected)
          Text(label,
              style: TextStyle(
                color: Color.fromARGB(255, 112, 112, 112),
                fontSize: 10,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              )),
      ],
    );
  }
}
