import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'divider.dart';

class AvailableCourts extends StatefulWidget {
  const AvailableCourts({super.key});

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
    final List<Widget> carouselItems = [
      CarouselItem(
        selected: selectedPageIndex == 0,
      ),
      CarouselItem(
        selected: selectedPageIndex == 1,
      ),
      CarouselItem(
        selected: selectedPageIndex == 2,
      ),
      CarouselItem(
        selected: selectedPageIndex == 3,
      ),
    ];
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: screenHeight * 0.17,
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
        const SizedBox(height: 10), // Spacer for the smooth page indicator
        buildPageIndicator(
            carouselItems.length), // Add the smooth page indicator
      ],
    );
  }

  Widget buildPageIndicator(int itemCount) {
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
            margin: const EdgeInsets.symmetric(horizontal: 4),
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
    final double itemWidth = screenWidth;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: screenWidth,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.50, color: Color(0x440D5FC3)),
            borderRadius: BorderRadius.circular(31),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  20), // Half of the height or width value
              child: Container(
                height: 110,
                width: 110,
                child: Image.asset(
                  'assets/images/clubimage.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TENNI Court',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const MyDivider(),
                const Text(
                  '12:00 PM  to 8:00 PM',
                  style: TextStyle(
                    color: Color(0xFF6D6D6D),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: itemWidth * .035),
                Container(
                  width: 155,
                  height: 25,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF1B262C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: const Center(
                      child: Text(
                    'Get Reserved',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
