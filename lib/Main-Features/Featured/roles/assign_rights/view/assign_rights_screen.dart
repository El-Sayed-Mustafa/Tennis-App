import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../core/utils/widgets/custom_button.dart';
import '../../../../../models/roles.dart';
import '../../create_role/view/widgets/rights_selector.dart'; // Import the RightSelector widget

class AssignRights extends StatefulWidget {
  const AssignRights({super.key, required this.role});
  final Role role;

  @override
  State<AssignRights> createState() => _AssignRightsState();
}

class _AssignRightsState extends State<AssignRights> {
  final TextEditingController roleController = TextEditingController();
  late List<String> selectedRights;

  @override
  void initState() {
    super.initState();
    selectedRights = List.from(widget.role.rights);
  }

  // Function to update the Role with selected rights
  void updateRoleWithSelectedRights(List<String> rights) {
    setState(() {
      selectedRights = rights;
    });
  }

  // Function to update Role data on Firestore
  Future<void> updateRoleOnFirestore() async {
    try {
      final updatedRole = Role(
        id: widget.role.id,
        name: widget.role.name,
        rights: selectedRights,
      );

      // Update the role document in Firestore
      await FirebaseFirestore.instance
          .collection('roles')
          .doc(updatedRole.id)
          .update(updatedRole.toJson());

      // Show a success message or navigate to a success screen
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Role Updated'),
          content: const Text('Role rights have been updated successfully.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the previous screen or any other desired screen
                GoRouter.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An error occurred while updating the role.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight,
          color: const Color(0xFFF8F8F8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                text: '   Roles',
                suffixIconPath: '',
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Role Details', // Update the header text
                        style: TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: screenHeight * .03),
                      // Display the role details
                      Text(
                        'Role ID: ${widget.role.id}',
                        style: const TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Role Name: ${widget.role.name}',
                        style: const TextStyle(
                          color: Color(0xFF616161),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      RightSelector(
                        selectedWords: selectedRights,
                        onSelectedWordsChanged: (words) {
                          // Call the function to update the Role with selected rights
                          updateRoleWithSelectedRights(words);
                        },
                      ),
                      SizedBox(height: screenHeight * .03),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: const Color(0xFFF8F8F8),
                  child: BottomSheetContainer(
                    buttonText: 'Update Role', // Update the button text
                    onPressed: () async {
                      // Call the function to update the Role with selected rights
                      updateRoleOnFirestore();
                    },
                    color: const Color(0xFFF8F8F8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
