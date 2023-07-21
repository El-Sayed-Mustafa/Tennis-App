import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/club_managment/view/widgets/member_item.dart';
import 'package:tennis_app/Main-Features/Featured/club_managment/view/widgets/members_list.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../core/utils/widgets/rules_text_field.dart';
import '../../../../models/player.dart';
import '../../../club/widgets/club_info.dart';
import '../../../club/widgets/num_members.dart';
import '../../create_club/view/widgets/Age_restriction.dart';

class ManagementScreen extends StatefulWidget {
  ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final TextEditingController rulesController = TextEditingController();
  String? createdClubId;
  List<Player> members = []; // Correctly initialize the members list

  @override
  void initState() {
    super.initState();
    getCurrentUserClubId();
  }

  Future<void> getCurrentUserClubId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String? currentUserId = user.uid;
      final userSnapshot = await FirebaseFirestore.instance
          .collection('players')
          .doc(currentUserId)
          .get();
      print(currentUserId);
      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        if (userData != null && userData.containsKey('createdClubId')) {
          createdClubId = userData['createdClubId'] as String?;
          setState(() {
            // Update the UI with the fetched club data
            fetchClubData();
          });
        }
      }
    }
  }

  Future<void> fetchClubData() async {
    if (createdClubId != null && createdClubId!.isNotEmpty) {
      final clubSnapshot = await FirebaseFirestore.instance
          .collection('clubs')
          .doc(createdClubId)
          .get();

      if (clubSnapshot.exists) {
        final clubData = clubSnapshot.data();
        if (clubData != null) {
          final List<String> memberIds =
              List<String>.from(clubData['memberIds'] ?? []);
          // Now you have the list of memberIds, fetch the memer data for each member
          print(memberIds.length);
          await fetchMembersData(memberIds);
        }
      }
    }
  }

  Future<void> fetchMembersData(List<String> memberIds) async {
    for (String memberId in memberIds) {
      final memberSnapshot = await FirebaseFirestore.instance
          .collection('players')
          .doc(memberId)
          .get();

      if (memberSnapshot.exists) {
        final memberData = memberSnapshot.data();
        print(memberData);

        Player member = Player.fromSnapshot(memberSnapshot);
        print("sayed" + member.playerName);
        print(member.gender);
        members.add(member);
      }
    }

    // Once all member objects are fetched, update the widget's state
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppBarWaveHome(
                prefixIcon: IconButton(
                  onPressed: () {
                    GoRouter.of(context).replace('/menu');
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                text: '    Management',
                suffixIconPath: '',
              ),
              Container(
                  margin: EdgeInsets.only(
                      right: screenWidth * .05,
                      top: screenWidth * .02,
                      left: screenWidth * .05,
                      bottom: screenWidth * .05),
                  child: const ClubInfo()),
              const NumMembers(),
              const SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * .13,
                    vertical: screenWidth * .035),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Manage Members',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFF0D5FC3),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              HorizontalListView(memberNames: members),
              SizedBox(height: screenHeight * .03),
              const Text(
                'Rules and regulations',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              RulesInputText(
                header: 'Set the rules for members',
                body: 'Briefly describe your club’s rule and regulations',
                controller: rulesController,
              ),
              SizedBox(height: screenHeight * .03),
              const Text(
                'Age restriction',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const AgeRestrictionWidget(),
              SizedBox(height: screenHeight * .015),
              BottomSheetContainer(
                  buttonText: 'Set',
                  onPressed: () {},
                  color: const Color(0xFFF8F8F8))
            ],
          ),
        ),
      ),
    );
  }
}
