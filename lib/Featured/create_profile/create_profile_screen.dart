import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/core/utils/widgets/clipper.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
      children: [
        AppBarWave(),
      ],
    ));
  }
}

class AppBarWave extends StatelessWidget {
  const AppBarWave({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SizedBox(
          height: screenHeight * 0.33,
          width: screenWidth,
          child: ClipPath(
            clipper: WaveClipper(),
            child: Container(
              color: const Color(0xFF1B262C),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.04,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Create\nYour Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.05,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: screenWidth * 0.35,
                    height: screenHeight * 0.25,
                    child: SvgPicture.asset(
                      'assets/images/create-profile.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
