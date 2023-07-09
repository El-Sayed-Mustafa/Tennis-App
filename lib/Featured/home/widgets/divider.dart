import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  const MyDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: SizedBox(
        width: screenWidth * .4,
        child: Row(
          children: [
            Expanded(
                child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('+', style: TextStyle(color: Colors.grey[400])),
            ),
            Expanded(
                child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            )),
          ],
        ),
      ),
    );
  }
}
