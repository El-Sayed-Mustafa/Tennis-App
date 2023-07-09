import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  int selectedPageIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final List<Widget> carouselItems = [
      CarouselItem(
        selected: selectedPageIndex == 0,
        screenWidth: screenWidth,
      ),
      CarouselItem(
        selected: selectedPageIndex == 1,
        screenWidth: screenWidth,
      ),
      CarouselItem(
        selected: selectedPageIndex == 2,
        screenWidth: screenWidth,
      ),
      CarouselItem(
        selected: selectedPageIndex == 3,
        screenWidth: screenWidth,
      ),
    ];
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: screenHeight * 0.265,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            viewportFraction: 0.5,
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
  final double screenWidth;

  const CarouselItem({
    Key? key,
    required this.selected,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemWidth = screenWidth * 0.6;
    final double itemHeight = screenHeight * .3;

    final double scaleFactor = selected ? 1.0 : 0.72;

    final Color backgroundColor =
        selected ? const Color(0xFFFCCBB1) : const Color(0xFFF3ADAB);

    return Container(
      width: 500,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.079),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage:
                const AssetImage('assets/images/profile-image.jpg'),
            radius: (itemHeight * 0.15) * scaleFactor,
          ),
          SizedBox(height: itemHeight * 0.03),
          Text(
            'FC Tournament',
            style: TextStyle(
              color: const Color(0xFF2A2A2A),
              fontSize: itemHeight * 0.06 * scaleFactor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: itemHeight * 0.03),
          Text(
            '12:00 PM\n12/04/2023',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF00344E),
              fontSize: itemHeight * 0.051 * scaleFactor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: itemHeight * 0.03),
          Container(
            width: itemWidth * 0.55 * scaleFactor,
            height: itemHeight * 0.125 * scaleFactor,
            decoration: ShapeDecoration(
              color: const Color(0xFF1B262C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.089),
              ),
            ),
            child: Center(
              child: Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: itemHeight * 0.056 * scaleFactor,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}