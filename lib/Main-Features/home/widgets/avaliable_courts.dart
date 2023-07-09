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

    final List<Widget> carouselItems = [
      CarouselItem(selected: selectedPageIndex == 0),
      CarouselItem(selected: selectedPageIndex == 1),
      CarouselItem(selected: selectedPageIndex == 2),
      CarouselItem(selected: selectedPageIndex == 3),
    ];

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: carouselHeight,
            enableInfiniteScroll: false,
            viewportFraction: 1,
            onPageChanged: (index, _) {
              setState(() {
                selectedPageIndex = index;
              });
            },
          ),
          carouselController: _carouselController, // Use CarouselController
          items: carouselItems,
        ),
        SizedBox(
            height:
                screenWidth * 0.026), // Spacer for the smooth page indicator
        buildPageIndicator(
            carouselItems.length), // Add the smooth page indicator
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

class CarouselItem extends StatelessWidget {
  final bool selected;

  const CarouselItem({Key? key, required this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double itemWidth = screenWidth * 0.9;
    final double imageHeight = screenHeight * 0.13;
    final double titleFontSize = screenHeight * 0.031;
    final double subtitleFontSize = screenHeight * 0.015;
    final double buttonTextFontSize = screenHeight * 0.015;
    final double buttonWidth = itemWidth * 0.4;
    final double buttonHeight = screenHeight * 0.035;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.041),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.051),
        width: itemWidth,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.50, color: Color(0x440D5FC3)),
            borderRadius: BorderRadius.circular(screenWidth * 0.079),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(imageHeight / 5),
              child: Container(
                height: imageHeight,
                width: imageHeight,
                child: Image.asset(
                  'assets/images/clubimage.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'TENNI Court',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: titleFontSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const MyDivider(),
                Text(
                  '12:00 PM to 8:00 PM',
                  style: TextStyle(
                    color: Color(0xFF6D6D6D),
                    fontSize: subtitleFontSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenWidth * .035),
                Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1B262C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(buttonHeight / 2),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Get Reserved',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: buttonTextFontSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
