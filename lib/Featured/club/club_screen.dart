import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tennis_app/Featured/club/widgets/club_events.dart';
import 'package:tennis_app/Featured/club/widgets/club_info.dart';
import 'package:tennis_app/Featured/club/widgets/num_members.dart';

import '../../core/utils/widgets/app_bar_wave.dart';

class ClubScreen extends StatelessWidget {
  const ClubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double spacing = screenHeight * 0.01;
    return Container(
      color: const Color(0xFFF8F8F8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBarWaveHome(
              prefixIcon: SvgPicture.asset(
                'assets/images/profile-icon.svg',
                fit: BoxFit.contain,
              ),
              text: 'Your Club',
              suffixIconPath: 'assets/images/app-bar-icon.svg',
            ),
            SizedBox(
              height: spacing,
            ),
            const ClubInfo(),
            SizedBox(
              height: spacing * 1.5,
            ),
            const NumMembers(),
            SizedBox(
              height: spacing * 2.5,
            ),
            Text(
              'Announcements',
              style: TextStyle(
                color: Color(0xFF313131),
                fontSize: 19,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: spacing * 2,
            ),
            Padding(
              padding: EdgeInsets.only(left: screenWidth * .13, bottom: 4),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  'Club’s Upcoming events',
                  style: TextStyle(
                    color: Color(0xB2313131),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ClubEvents(),
          ],
        ),
      ),
    );
  }
}
