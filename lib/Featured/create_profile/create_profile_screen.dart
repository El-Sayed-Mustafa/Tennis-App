import 'package:flutter/material.dart';

import '../../core/utils/widgets/app_bar_clipper.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarWave();
  }
}

class AppBarWave extends StatelessWidget {
  const AppBarWave({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final appBarWidth = screenWidth * 0.2; // Set the desired width

    return Stack(
      children: [
        SizedBox(
          height: 120,
          width: screenWidth,
          child: ClipPath(
            clipper: AppBarClipper(),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  child: Container(
                    color: const Color(0xFF1B262C),
                    height: screenHeight * 0.58,
                    width: screenWidth,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
