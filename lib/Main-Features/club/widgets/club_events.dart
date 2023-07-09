import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Main-Featured/club/widgets/text_rich.dart';

import '../../home/widgets/divider.dart';

class ClubEvents extends StatefulWidget {
  const ClubEvents({Key? key}) : super(key: key);

  @override
  State<ClubEvents> createState() => _ClubEventsState();
}

class _ClubEventsState extends State<ClubEvents> {
  int selectedPageIndex = 0;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double carouselHeight = screenHeight * 0.26;

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
          height: 8,
        ),
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
    final double imageHeight = (screenHeight + screenWidth) * 0.09;
    final double titleFontSize = (screenHeight + screenWidth) * 0.02;
    final double buttonTextFontSize = (screenHeight + screenWidth) * 0.01;
    final double buttonWidth = itemWidth * 0.4;
    final double buttonHeight = screenHeight * 0.035;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * .007),
      child: PhysicalModel(
        color: Colors.transparent,
        elevation: 4, // Adjust the shadow elevation as desired
        shadowColor: Colors.grey, // Set the shadow color
        borderRadius: BorderRadius.circular(screenWidth * 0.079),
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.051, vertical: screenHeight * 0.015),
          width: itemWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.079),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                  SizedBox(height: screenHeight * .015),
                  SizedBox(
                    height: imageHeight / 3.5,
                    width: imageHeight / 3.5,
                    child: SvgPicture.asset(
                      'assets/images/sun.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: screenHeight * .003),
                  const Text(
                    'Sunny',
                    style: TextStyle(
                      color: Color(0xFF00344E),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Friendly Match',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: titleFontSize,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const MyDivider(),
                  const MyTextRich(
                    text1: 'Time',
                    text2: '4:00 PM to 8:00 PM',
                  ),
                  SizedBox(height: screenHeight * .012),
                  const MyTextRich(
                    text2: '4:00 PM to 8:00 PM',
                    text1: 'Date',
                  ),
                  SizedBox(height: screenHeight * .012),
                  const MyTextRich(
                    text1: 'At',
                    text2: 'Tenni court',
                  ),
                  SizedBox(height: screenHeight * .012),
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
                        'Set Reminder',
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
      ),
    );
  }
}
