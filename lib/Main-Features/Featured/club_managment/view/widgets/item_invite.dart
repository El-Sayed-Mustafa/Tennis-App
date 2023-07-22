import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/Featured/club_managment/view/screens/player_screen.dart';
import 'package:tennis_app/Main-Features/Featured/club_managment/view/widgets/text_rich.dart';
import '../../../../../models/player.dart';
import '../../../../home/widgets/divider.dart';
import 'package:intl/intl.dart';

class MemberItem extends StatelessWidget {
  const MemberItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double imageHeight = (screenHeight + screenWidth) * 0.08;
    List<String> getRolesFromClubRoles(Map<String, String> clubRoles) {
      List<String> roles = [];
      for (var roleValue in clubRoles.values) {
        final individualRoles = roleValue.split(',');
        roles.addAll(individualRoles.map((role) => role.trim()));
      }
      return roles;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: screenWidth * .8,
      height: screenHeight * .27,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(31),
        boxShadow: const [
          BoxShadow(
            color: Color(
                0x440D5FC3), // Shadow color with opacity (adjust the alpha value)
            blurRadius: 5.0, // Adjust the blur radius as per your preference
            spreadRadius:
                1.0, // Adjust the spread radius as per your preference
            offset: Offset(0,
                3), // Adjust the offset to control the position of the shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'member',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const MyDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextRich(text1: 'Skill level ', text2: 'Skill level'),
                  SizedBox(height: screenHeight * .01),
                  MyTextRich(
                    text1: 'Membership  ',
                    text2: 'Members',
                  ),
                  SizedBox(height: screenHeight * .01),
                  MyTextRich(
                    text1: 'Player type ',
                    text2: 'member.',
                  ),
                  SizedBox(height: screenHeight * .01),
                  MyTextRich(
                    text1: 'Date  ',
                    text2: 'Date',
                  ),
                  SizedBox(height: screenHeight * .01),
                  SizedBox(
                    width: screenWidth * .4,
                    child: MyTextRich(
                      text1: 'Role ',
                      text2: 'No Role Assigned',
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(imageHeight / 5),
                    child: Container(
                        height: imageHeight,
                        width: imageHeight,
                        child: Text('photo')),
                  ),
                  SizedBox(
                    height: screenHeight * .005,
                  ),
                  Container(
                    decoration: const ShapeDecoration(
                      color: Color.fromARGB(212, 15, 32, 42),
                      shape: OvalBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.ads_click, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
