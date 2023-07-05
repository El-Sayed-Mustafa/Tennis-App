import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/utils/widgets/clipper.dart';

class WaveClipperScreen extends StatelessWidget {
  const WaveClipperScreen({Key? key, this.widgetHeight}) : super(key: key);
  final widgetHeight;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: widgetHeight,
      width: screenWidth,
      child: ClipPath(
        clipper: WaveClipper(),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(),
              child: Container(
                color: const Color(0xFF1B262C),
                height: screenHeight * 0.58,
                width: screenWidth,
              ),
            ),
            Row(
              children: [
                const Spacer(),
                Container(
                  alignment: Alignment.bottomRight,
                  decoration: const BoxDecoration(),
                  child: SizedBox(
                    height: screenHeight * 0.37,
                    width: 200,
                    child: SvgPicture.asset('assets/images/auth1.svg'),
                  ),
                ),
              ],
            ),
            Positioned(
              left: screenWidth * 0.05,
              top: screenHeight * 0.25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'WELCOME',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * .005,
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
