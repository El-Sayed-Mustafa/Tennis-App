import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/widgets/app_bar_icon.dart';
import '../../../../core/utils/widgets/opacity_wave.dart';
import '../../../../generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              AppBarIcon(
                widgetHeight: screenHeight * .4,
                svgImage: SvgPicture.asset('assets/images/app-bar-icon.svg'),
                text: 'Settings',
              ),
              OpacityWave(height: screenHeight * 0.407),
            ],
          )
        ],
      ),
    );
  }
}
