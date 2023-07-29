import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/chats/widgets/community_message.dart';

import '../widgets/message_input.dart';
import '../widgets/my_reply.dart';

class Community extends StatelessWidget {
  const Community({Key? key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
            child: Container(
              width: double.infinity,
              decoration: const ShapeDecoration(
                color: Color(0xFFF8F8F8),
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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    // CommunityMessage(),
                    // CommunityMessage(),
                    // MyReply(),
                    // CommunityMessage(),
                    SizedBox(
                      height: 64,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // MessageInput(
        //   onPressed: () {},
        // )
      ],
    );
  }
}
