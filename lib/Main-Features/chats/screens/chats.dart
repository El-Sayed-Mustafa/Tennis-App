import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/chats/widgets/message_item.dart';

import '../../../core/utils/widgets/input_feild.dart';
import '../widgets/search_input.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
      child: Container(
        width: double.infinity,
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 3,
              offset: Offset(0, -4),
              spreadRadius: 0,
            )
          ],
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
            child: SearchInput(
              hintText: 'Find Player...',
              icon: Icons.search,
              obscureText: false,
              controller: searchController,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: screenHeight * .58,
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 3,
                  offset: Offset(0, -4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MessageItem(
                    screenWidth: screenWidth,
                    imagePath: 'assets/images/profile-image.jpg',
                    name: 'De Martin',
                    message: 'Hello, how are you?',
                    time: '10:30 AM',
                    unreadMessages: '3',
                  ),
                  MessageItem(
                    screenWidth: screenWidth,
                    imagePath: 'assets/images/profile-image.jpg',
                    name: 'De Martin',
                    message: 'Hello, how are you?',
                    time: '10:30 AM',
                    unreadMessages: '3',
                  ),
                  MessageItem(
                    screenWidth: screenWidth,
                    imagePath: 'assets/images/profile-image.jpg',
                    name: 'De Martin',
                    message: 'Hello, how are you?',
                    time: '10:30 AM',
                    unreadMessages: '3',
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
