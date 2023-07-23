import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/chats/widgets/my_reply.dart';

import '../../../core/utils/widgets/app_bar_wave.dart';
import '../widgets/community_message.dart';
import '../widgets/message_input.dart';

class PrivateChat extends StatelessWidget {
  const PrivateChat({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xF8F8F8F8),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                AppBarWaveHome(
                  prefixIcon: IconButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  text: '    Chat',
                  suffixIconPath: '',
                ),
                SizedBox(
                  height: screenHeight * 0.13,
                  child: Image.asset('assets/images/profileimage.png',
                      fit: BoxFit.cover),
                ),
                SizedBox(height: screenHeight * .025),
                Text(
                  'De Martin',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenHeight * .025),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: const ShapeDecoration(
                    color: Color(0xF8F8F8F8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        offset: Offset(0, -4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      CommunityMessage(),
                      MyReply(),
                      CommunityMessage(),
                      MyReply(),
                      CommunityMessage(),
                      MyReply(),
                      CommunityMessage(),
                      MyReply(),
                      CommunityMessage(),
                      MyReply(),
                      SizedBox(height: screenHeight * .06),
                    ],
                  ),
                )
              ],
            ),
          ),
          MessageInput(
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
