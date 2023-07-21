import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tennis_app/Main-Features/Featured/roles/assign_person/view/widgets/member_name.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../create_role/view/widgets/rights_selector.dart';
import '../cubit/assign_person_cubit.dart';
import '../cubit/assign_person_state.dart';
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
  late final AssignPersonCubit cubit;

  @override
  void initState() {
    super.initState();
    selectedRole = [];
    roleNames = [];
    clubRolesService = ClubRolesService();
    cubit = AssignPersonCubit();
    cubit.loadClubRoles();
    cubit.fetchRoleNames();
  }

  @override
  void dispose() {
    cubit.close(); // Close the cubit when disposing of the widget
    super.dispose();
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
                    cubit.updateRoleWithSelectedRole(words);
                  },
                  words: roleNames,
                ),
              ),
            ),
            // Use BlocBuilder to handle UI changes based on state
            BlocBuilder<AssignPersonCubit, AssignPersonState>(
              bloc: cubit,
              builder: (context, state) {
                if (state is AssignPersonLoading) {
                  return CircularProgressIndicator();
                } else if (state is AssignPersonError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.message),
                  );
                } else if (state is AssignPersonSuccess) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(state.message),
                  );
                } else if (state is AssignPersonFetchedRoleNames) {
                  // Assign the fetched role names to the local variable
                  roleNames = state.roleNames;
                  return BottomSheetContainer(
                    buttonText: 'Assign Role',
                    onPressed: () {
                      cubit.assignRole(
                        memberNameController.text.trim(),
                        selectedRole,
                      );
                    },
                    color: Color(0xFFF8F8F8),
                  );
                } else if (state is AssignPersonSelectedRoles) {
                  selectedRole = state.selectedRoles;
                  return BottomSheetContainer(
                    buttonText: 'Assign Role',
                    onPressed: () {
                      cubit.assignRole(
                        memberNameController.text.trim(),
                        selectedRole,
                      );
                    },
                    color: Color(0xFFF8F8F8),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
