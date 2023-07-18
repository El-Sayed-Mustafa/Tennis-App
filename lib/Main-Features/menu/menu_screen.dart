import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Main-Features/menu/widgets/button_menu.dart';

import '../../core/utils/widgets/app_bar_wave.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF8F8F8),
          child: Column(
            children: [
              AppBarWaveHome(
                prefixIcon: SvgPicture.asset(
                  'assets/images/profile-icon.svg',
                  fit: BoxFit.contain,
                ),
                text: 'Menu',
                suffixIconPath: 'assets/images/app-bar-icon.svg',
              ),
              SizedBox(
                height: screenHeight * 0.13,
                child: Image.asset('assets/images/clubimage.png',
                    fit: BoxFit.cover),
              ),
              SizedBox(
                height: 10,
              ),
              ButtonMenu(
                imagePath: 'assets/images/League-Information.svg',
                buttonText: 'League Information',
                onPressed: () {},
              ),
              ButtonMenu(
                imagePath: 'assets/images/Event-Calnder.svg',
                buttonText: 'Event Calnder',
                onPressed: () {},
              ),
              ButtonMenu(
                imagePath: 'assets/images/Member-administration.svg',
                buttonText: 'Member administration',
                onPressed: () {},
              ),
              ButtonMenu(
                imagePath: 'assets/images/Create-role.svg',
                buttonText: 'Create a role',
                onPressed: () {},
              ),
              ButtonMenu(
                imagePath: 'assets/images/Tournament-management.svg',
                buttonText: 'Tournament management',
                onPressed: () {},
              ),
              ButtonMenu(
                imagePath: 'assets/images/Your-Membership.svg',
                buttonText: 'Your Membership',
                onPressed: () {},
              ),
              ButtonMenu(
                imagePath: 'assets/images/Feedbacks.svg',
                buttonText: 'Feedbacks',
                onPressed: () {},
              ),
              ButtonMenu(
                imagePath: 'assets/images/Settings.svg',
                buttonText: 'Settings',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
