import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Featured/home/widgets/avaliable_courts.dart';
import 'package:tennis_app/Featured/home/widgets/button_home.dart';
import 'package:tennis_app/Featured/home/widgets/my_events.dart';
import 'package:tennis_app/core/utils/widgets/app_bar_wave.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double itemWidth = screenWidth * 0.9;
    final double imageHeight = screenHeight * 0.13;
    final double titleFontSize = screenHeight * 0.031;
    final double subtitleFontSize = screenHeight * 0.015;
    final double buttonTextFontSize = screenHeight * 0.015;
    final double buttonWidth = itemWidth * 0.4;
    final double buttonHeight = screenHeight * 0.035;
    final sectionTitleSize = screenWidth * 0.052;

    final spacing = screenHeight * 0.015;

    return Container(
      color: const Color(0xFFF8F8F8),
      alignment: Alignment.topCenter, // Aligns the column to the top
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWaveHome(
              prefixIcon: SvgPicture.asset(
                'assets/images/profile-icon.svg',
                fit: BoxFit.contain,
              ),
              text: 'Home',
              suffixIconPath: 'assets/images/app-bar-icon.svg',
            ),
            SizedBox(
              height: spacing,
            ),
            Text(
              'Your Upcoming Events',
              style: TextStyle(
                color: Color(0xFF313131),
                fontSize: sectionTitleSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: spacing),
            MyEvents(),
            SizedBox(height: spacing * 2),
            Text(
              'Available Courts',
              style: TextStyle(
                color: Color(0xFF313131),
                fontSize: sectionTitleSize,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: spacing),
            AvailableCourts(),
            SizedBox(height: spacing * 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeButton(
                    buttonText: 'Find Court',
                    imagePath: 'assets/images/Find-Court.svg',
                    onPressed: () {},
                  ),
                  HomeButton(
                    buttonText: 'Find Partner',
                    imagePath: 'assets/images/Find-Partner.svg',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HomeButton(
                    buttonText: 'Create Event',
                    imagePath: 'assets/images/Create-Event.svg',
                    onPressed: () {},
                  ),
                  HomeButton(
                    buttonText: 'Make offers',
                    imagePath: 'assets/images/Make-offers.svg',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing * 2),
          ],
        ),
      ),
    );
  }
}
