import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/personal_info.dart';
import 'package:tennis_app/Main-Features/Featured/profile/view/widgets/playing_info.dart';

import '../../../../../generated/l10n.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .1),
      child: const Column(
        children: [PersonalInfo(), SizedBox(height: 20), PlayingInfo()],
      ),
    );
  }
}
