import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/profile_body.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../core/utils/widgets/app_bar_icon.dart';
import '../../../../core/utils/widgets/opacity_wave.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF8F8F8),
          child: Column(
            children: [
              Stack(
                children: [
                  AppBarIcon(
                    widgetHeight: screenHeight * .37,
                    //TODO:Change the svg path
                    svgImage:
                        SvgPicture.asset('assets/images/create-profile.svg'),
                    text: 'Your Profile',
                  ),
                  OpacityWave(height: screenHeight * 0.377),
                  Positioned(
                    top: 40,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: screenWidth * 0.12,
                        height: screenHeight * 0.07,
                        child: IconButton(
                          onPressed: () {
                            print("Press");
                            GoRouter.of(context).push('/menu');
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'Kevin',
                style: TextStyle(
                  color: Color(0xFF1B262C),
                  fontSize: 26,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 30),
              const ProfileBody(),
              BottomSheetContainer(
                buttonText: 'Edit',
                onPressed: () {},
                color: const Color(0xFFF8F8F8),
              )
            ],
          ),
        ),
      ),
    );
  }
}
