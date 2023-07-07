import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Featured/create_profile/widgets/app_bar_wave.dart';
import 'package:tennis_app/Featured/create_profile/widgets/gender_selection.dart';
import 'package:tennis_app/Featured/create_profile/widgets/profile_image.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          const AppBarWave(),
          const ProfileImage(),
          SizedBox(height: screenHeight * .01),
          const Text(
            'Set Profile Picture',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenHeight * .03),
          const GenderSelection()
        ],
      ),
    );
  }
}
