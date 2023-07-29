import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/chats/widgets/message_item.dart';
import '../widgets/search_input.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final List<String> messages = [
      'Hello, how are you?',
      'Nice to meet you!',
      'How was your day?',
      'Do you want to play tennis?',
      'Sure, let\'s play!',
    ];

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: SizedBox(
        height: screenHeight,
        child: Padding(
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16),
                  child: SearchInput(
                    hintText: 'Find Player...',
                    icon: Icons.search,
                    obscureText: false,
                    controller: searchController,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
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
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return MessageItem(
                          screenWidth: screenWidth,
                          imagePath: 'assets/images/profile-image.jpg',
                          name: 'De Martin',
                          message: messages[index],
                          time: '10:30 AM',
                          unreadMessages: '3',
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
