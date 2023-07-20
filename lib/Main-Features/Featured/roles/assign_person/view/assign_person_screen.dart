import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tennis_app/Main-Features/Featured/roles/assign_person/view/widgets/member_name.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../create_role/view/widgets/rights_selector.dart';

class AssignPerson extends StatefulWidget {
  AssignPerson({Key? key}) : super(key: key);

  @override
  State<AssignPerson> createState() => _AssignPersonState();
}

class _AssignPersonState extends State<AssignPerson> {
  final TextEditingController memberNameController = TextEditingController();
  late List<String> selectedRole;
  late List<String> roleNames; // To store the role names

  String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }

  Future<void> fetchClubRolesAndSetState(String clubId) async {
    try {
      final clubDoc = await FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubId)
          .get();
      final clubData = clubDoc.data();
      if (clubData != null) {
        setState(() {});
      }
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchRoleNames() async {
    try {
      final roleNamesList = <String>[];
      final rolesSnapshot =
          await FirebaseFirestore.instance.collection('roles').get();
      final rolesData = rolesSnapshot.docs;
      for (final roleDoc in rolesData) {
        final roleData = roleDoc.data();
        final roleName = roleData['name'] as String;
        roleNamesList.add(roleName);
      }
      setState(() {
        roleNames = roleNamesList;
      });
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    selectedRole = [];
    roleNames = []; // Initialize the roleNames list
    loadClubRoles();
    fetchRoleNames(); // Fetch role names
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
        final clubId = playerData['createdClubId'] as String;
        await fetchClubRolesAndSetState(clubId);
      }
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching data: $e');
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
            RightSelector(
              selectedWords: selectedRole,
              onSelectedWordsChanged: (words) {
                updateRoleWithSelectedRole(words);
              },
              words: roleNames, // Use the fetched role names here
            ),
          ],
        ),
      ),
    );
  }
}
