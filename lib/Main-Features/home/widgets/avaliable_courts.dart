import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'divider.dart';

class AvailableCourts extends StatefulWidget {
  const AvailableCourts({Key? key}) : super(key: key);

  @override
  State<AvailableCourts> createState() => _AvailableCourtsState();
}

class _AvailableCourtsState extends State<AvailableCourts> {
  int selectedPageIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double carouselHeight = screenHeight * 0.17;

    return Column(
      children: [
        // CarouselSlider(
        //   options: CarouselOptions(
        //     height: carouselHeight,
        //     enableInfiniteScroll: false,
        //     viewportFraction: 1,
        //     onPageChanged: (index, _) {
        //       setState(() {
        //         selectedPageIndex = index;
        //       });
        //     },
        //   ),
        //   carouselController: _carouselController, // Use CarouselController
        //   items: carouselItems,
        // ),
        // SizedBox(
        //     height:
        //         screenWidth * 0.026), // Spacer for the smooth page indicator
        // buildPageIndicator(
        //     carouselItems.length), // Add the smooth page indicator
      ],
    );
  }

  Widget buildPageIndicator(int itemCount) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) {
          final bool isSelected = selectedPageIndex == index;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isSelected ? 11 : 9,
            height: isSelected ? 11 : 9,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.011),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.black : Colors.grey,
            ),
          );
        },
      ),
    );
  }
}
