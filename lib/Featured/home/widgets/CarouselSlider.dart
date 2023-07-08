import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselSliderWidget extends StatefulWidget {
  const CarouselSliderWidget({Key? key}) : super(key: key);

  @override
  _CarouselSliderWidgetState createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int selectedPageIndex = 0;

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
      CarouselItem(
        selected: selectedPageIndex == 4,
      ),
      CarouselItem(
        selected: selectedPageIndex == 5,
      ),
    ];
    return Scaffold(
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: screenHeight * 0.254,
              autoPlay: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              viewportFraction: 0.5,
              onPageChanged: (index, _) {
                setState(() {
                  selectedPageIndex = index;
                });
              },
            ),
            items: carouselItems,
          ),
        ],
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
    final double itemWidth = screenWidth * 0.6;
    final double itemHeight = itemWidth * 1.2;

    final double scaleFactor = selected ? 1.0 : 0.72;

    final Color backgroundColor =
        selected ? const Color(0xFFFCCBB1) : const Color(0xFFF3ADAB);

    return Container(
      width: itemWidth * scaleFactor,
      height: itemHeight * scaleFactor,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(31),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: itemWidth * .035),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: itemWidth * .03),
            CircleAvatar(
              backgroundImage:
                  const AssetImage('assets/images/profile-image.jpg'),
              radius: (itemWidth * 0.15) * scaleFactor,
            ),
            SizedBox(height: itemWidth * .03),
            Text(
              'FC Tournament',
              style: TextStyle(
                color: Color(0xFF2A2A2A),
                fontSize: 14 * scaleFactor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: itemWidth * .03),
            Text(
              '12:00 PM\n12/04/2023',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF00344E),
                fontSize: 12 * scaleFactor,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: itemWidth * .03),
            Container(
              width: itemWidth * 0.55 * scaleFactor,
              height: itemHeight * 0.125 * scaleFactor,
              decoration: ShapeDecoration(
                color: const Color(0xFF1B262C),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14 * scaleFactor,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
