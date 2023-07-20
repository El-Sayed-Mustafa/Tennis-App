import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tennis_app/Main-Features/Featured/roles/assign_person/view/widgets/member_name.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../models/player.dart';
import '../../create_role/view/widgets/rights_selector.dart';
import '../service/club_roles_service.dart';

class AssignPerson extends StatefulWidget {
  AssignPerson({Key? key}) : super(key: key);

  @override
  State<AssignPerson> createState() => _AssignPersonState();
}

class _AssignPersonState extends State<AssignPerson> {
  final TextEditingController memberNameController = TextEditingController();
  late List<String> selectedRole;
  late List<String> roleNames;
  late final ClubRolesService clubRolesService;

  @override
  void initState() {
    super.initState();
    selectedRole = []; // Initialize selectedRole as an empty list
    roleNames = [];
    clubRolesService = ClubRolesService();
    loadClubRoles();
    fetchRoleNames();
  }

  String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  void _assignRole() async {
    final String memberName = memberNameController.text.trim();
    if (memberName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the member name')),
      );
      return;
    }
    if (selectedRole.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one role')),
      );
      return;
    }

    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final ClubRolesService clubRolesService = ClubRolesService();
        final String? playerId =
            await clubRolesService.getPlayerIdByName(memberName);
        if (playerId == null) {
          // Show error message if player not found with the given name
          return;
        }
        final DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
            await FirebaseFirestore.instance
                .collection('players')
                .doc(playerId)
                .get();
        final DocumentSnapshot<Map<String, dynamic>> admin =
            await FirebaseFirestore.instance
                .collection('players')
                .doc(currentUser.uid) //put id for current user
                .get();
        final data = admin.data();
        if (data != null) {
          final String createdClubId = data['createdClubId'] as String? ?? '';
          final Map<String, String> clubRoles = <String, String>{
            createdClubId: selectedRole.join(",")
          };
          // Update the player document with the new roles
          await playerSnapshot.reference.update({'clubRoles': clubRoles});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Roles assigned successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Player data not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
      }
    } catch (e) {
      print('Error assigning roles: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error assigning roles. Please try again later.')),
      );
    }
  }

  Future<void> loadClubRoles() async {
    try {
      final userId = getCurrentUserId();
      final playerSnapshot = await FirebaseFirestore.instance
          .collection('players')
          .doc(userId)
          .get();
      final playerData = playerSnapshot.data();
      if (playerData != null) {
        setState(() {});
      }
    } catch (e) {
      // Handle errors if necessary
      print('Error loading club roles: $e');
    }
  }

  Future<void> fetchRoleNames() async {
    try {
      final roleNamesList = await clubRolesService.fetchRoleNames();
      setState(() {
        roleNames.addAll(roleNamesList);
      });
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching role names: $e');
    }
  }

  void updateRoleWithSelectedRole(List<String> roles) {
    setState(() {
      selectedRole = roles;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Color(0xFFF8F8F8),
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
              text: '   Assign Person',
              suffixIconPath: '',
            ),
            const Text(
              'Select Person',
              style: TextStyle(
                color: Color(0xFF616161),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: screenHeight * .03),
            MembersName(
              controller: memberNameController,
            ),
            SizedBox(height: screenHeight * .05),
            const Text(
              'Assign Roles',
              style: TextStyle(
                color: Color(0xFF616161),
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                child: RightSelector(
                  selectedWords: selectedRole,
                  onSelectedWordsChanged: (words) {
                    updateRoleWithSelectedRole(words);
                  },
                  words: roleNames, // Use the fetched role names here
                ),
              ),
            ),
            BottomSheetContainer(
              buttonText: 'Assign Role',
              onPressed:
                  _assignRole, // Use the _assignRole function for onPressed
              color: Color(0xFFF8F8F8),
            )
          ],
        ),
      ),
    );
  }
}
