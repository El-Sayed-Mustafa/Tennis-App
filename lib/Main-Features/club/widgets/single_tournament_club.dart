import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class NestedCarouselSlider extends StatelessWidget {
  final List<List<String>> nestedItems = [
    ['Item 1', 'Item 2', 'Item 3'],
    ['Item A', 'Item B', 'Item C', 'Item D'],
    ['Item X', 'Item Y']
  ];

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: nestedItems.length,
      options: CarouselOptions(
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) {
          // Handle page change if needed
        },
      ),
      itemBuilder: (context, index, realIndex) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Horizontal Item $index',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            CarouselSlider.builder(
              itemCount: nestedItems[index].length,
              options: CarouselOptions(
                aspectRatio: 1,
                viewportFraction: 0.6,
                enableInfiniteScroll: false,
                scrollDirection: Axis.vertical,
              ),
              itemBuilder: (context, innerIndex, realInnerIndex) {
                return Container(
                  height: 100,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: Text(
                    nestedItems[index][innerIndex],
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Nested Carousel Slider')),
      body: Center(child: NestedCarouselSlider()),
    ),
  ));
}
