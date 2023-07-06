import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Featured/choose_club/widgets/wave_clipper_widget.dart';

import '../../core/utils/widgets/clipper.dart';
import '../../core/utils/widgets/opacity_wave.dart';
import '../../generated/l10n.dart';

class ChooseClub extends StatelessWidget {
  const ChooseClub({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              WaveClipperScreenChooseClub(
                widgetHeight: screenHeight * .4,
                svgImage: SvgPicture.asset('assets/images/choose-club.svg'),
                text: "Join Club",
              ),
              OpacityWave(height: screenHeight * 0.407),
            ],
          ),
        ],
      ),
    );
  }
}
