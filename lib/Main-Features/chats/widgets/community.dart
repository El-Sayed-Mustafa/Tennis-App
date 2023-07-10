import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/chats/widgets/community_message.dart';

import 'my_reply.dart';

class Community extends StatelessWidget {
  const Community({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8.0, right: 8.0),
      child: Container(
        width: double.infinity,
        decoration: const ShapeDecoration(
          color: const Color(0xFFF8F8F8),
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
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              CommunityMessage(),
              SizedBox(height: 10),
              CommunityMessage(),
              SizedBox(height: 10),
              MyReply()
            ],
          ),
        ),
      ),
    );
  }
}
