import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/core/utils/widgets/app_bar_wave.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBarWaveHome(
        prefixIcon: SvgPicture.asset(
          'assets/images/profile-icon.svg',
          fit: BoxFit.contain,
        ),
        text: 'Home',
        suffixIconPath: 'assets/images/app-bar-icon.svg',
      ),
    );
  }
}
