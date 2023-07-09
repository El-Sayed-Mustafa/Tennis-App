import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Main-Features/chats/widgets/chats.dart';
import 'package:tennis_app/Main-Features/chats/widgets/community.dart';
import 'package:tennis_app/Main-Features/chats/widgets/group.dart';

import '../../core/utils/widgets/app_bar_wave.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: Column(
          children: [
            AppBarWaveHome(
              prefixIcon: SvgPicture.asset(
                'assets/images/profile-icon.svg',
                fit: BoxFit.contain,
              ),
              text: 'Messages',
              suffixIconPath: 'assets/images/app-bar-icon.svg',
            ),
            SizedBox(
              height: screenHeight * .01,
            ),
            Container(
              width: screenWidth * .93,
              decoration: ShapeDecoration(
                color: const Color.fromARGB(49, 103, 175, 247),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  tabBarTheme: TabBarTheme(
                    labelColor:
                        const Color(0xFF0F4C81), // Customize selected tab color
                    unselectedLabelColor:
                        const Color(0xFF6F6F6F), // Customize default tab color
                    labelStyle: TextStyle(
                      fontSize: screenWidth * .04,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: screenWidth * .036,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9.0, vertical: 5),
                  child: TabBar(
                    physics: const BouncingScrollPhysics(),
                    controller: tabController,
                    tabs: const [
                      Tab(
                        text: 'Community',
                      ),
                      Tab(
                        text: 'Groups',
                      ),
                      Tab(
                        text: 'Chats',
                      ),
                    ],
                    indicator: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ), // Customize the indicator color
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * .008,
            ),
            Expanded(
                child: TabBarView(
              controller: tabController,
              children: const [
                Community(),
                Groups(),
                Chats(),
              ],
            ))
          ],
        ),
      ),
    );
  }
}