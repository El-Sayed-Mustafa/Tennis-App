import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Featured/home/widgets/avaliable_courts.dart';
import 'package:tennis_app/Featured/home/widgets/button_home.dart';
import 'package:tennis_app/Featured/home/widgets/my_events.dart';
import 'package:tennis_app/core/utils/widgets/app_bar_wave.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Text(
              'Your Upcoming Events',
              style: TextStyle(
                color: Color(0xFF313131),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const MyEvents(),
            const SizedBox(height: 20),
            Text(
              'Available Courts',
              style: TextStyle(
                color: Color(0xFF313131),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const AvailableCourts(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
          ],
        ),
      ),
    );
  }
}
