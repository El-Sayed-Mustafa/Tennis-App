import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Featured/create_profile/widgets/app_bar_wave.dart';
import 'package:tennis_app/Featured/create_profile/widgets/gender_selection.dart';
import 'package:tennis_app/Featured/create_profile/widgets/profile_image.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [AppBarWave(), ProfileImage(), GenderSelection()],
      ),
    );
  }
}
