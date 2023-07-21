import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../models/player.dart';
import 'package:intl/intl.dart';

import '../../../roles/assign_person/cubit/assign_person_cubit.dart';
import '../../../roles/assign_person/cubit/assign_person_state.dart';
import '../../../roles/assign_person/service/club_roles_service.dart';
import '../../../roles/create_role/view/widgets/rights_selector.dart';

class PlayerScreen extends StatefulWidget {
  final Player player;

  PlayerScreen({required this.player, Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
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
  } // Add this line

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
              text: '    Management',
              suffixIconPath: '',
            ),
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: (screenHeight + screenWidth) * 0.025,
                      right: (screenHeight + screenWidth) * 0.025,
                      top: (screenHeight + screenWidth) * 0.05),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: (screenHeight + screenWidth) * 0.06,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 0.50, color: Color(0x440D5FC3)),
                          borderRadius: BorderRadius.circular(31),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            Text(
                              widget.player.playerName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Skill level',
                                  style: TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(widget.player.skillLevel)
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Membership',
                                  style: TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                    widget.player.clubRoles['membership'] ?? '')
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Player type',
                                  style: TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(widget.player.playerType)
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(DateFormat('MMM d, yyyy')
                                    .format(widget.player.birthDate))
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Role',
                                  style: TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(widget.player.clubRoles['role'] ?? '')
                              ],
                            ),
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center, // Center the photo
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            (screenHeight + screenWidth) * 0.08 / 3),
                        child: Container(
                          height: (screenHeight + screenWidth) * 0.1,
                          width: (screenHeight + screenWidth) * 0.08,
                          child: widget.player.photoURL != ''
                              ? Image.network(
                                  widget.player.photoURL!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/profileimage.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * .025,
            ),
            const Text(
              'Assign Role',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ), //call the function here
            Padding(
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
            Spacer(),
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
                        widget.player.playerName,
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
