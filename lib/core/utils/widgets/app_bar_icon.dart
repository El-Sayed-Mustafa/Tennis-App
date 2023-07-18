import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/widgets/clipper.dart';

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    Key? key,
    required this.widgetHeight,
    required this.text,
    required this.svgImage,
  }) : super(key: key);

  final double widgetHeight;
  final String text;
  final SvgPicture svgImage;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        SizedBox(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: screenHeight * 0.04,
                      ),
                      alignment: Alignment.topRight,
                      decoration: const BoxDecoration(),
                      child: SizedBox(
                        height: screenHeight * 0.32,
                        width: screenWidth * 0.45,
                        child: svgImage,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: screenWidth * 0.05,
                  top: screenHeight * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: widgetHeight * 1.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // Align items to the center vertically
            children: [
              const Spacer(),
              Center(
                child: SizedBox(
                  height: screenHeight * 0.14,
                  child: Image.asset('assets/images/clubimage.png',
                      fit: BoxFit.cover),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
