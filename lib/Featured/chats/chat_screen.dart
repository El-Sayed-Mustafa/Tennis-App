import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/utils/widgets/app_bar_wave.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBarWaveHome(
        prefixIcon: SvgPicture.asset(
          'assets/images/profile-icon.svg',
          fit: BoxFit.contain,
        ),
        text: 'Messages',
        suffixIconPath: 'assets/images/app-bar-icon.svg',
      ),
    );
  }
}
