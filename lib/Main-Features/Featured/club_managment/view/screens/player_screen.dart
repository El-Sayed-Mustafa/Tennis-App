import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/club_managment/view/managment_screen.dart';
import 'package:tennis_app/Main-Features/Featured/roles/create_role/view/widgets/rights_selector.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../models/player.dart';
import 'package:intl/intl.dart';

import '../../../create_event/view/widgets/player_level.dart';
import '../../../roles/assign_person/service/club_roles_service.dart';

class PlayerScreen extends StatefulWidget {
  final Player player;

  const PlayerScreen({required this.player, Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final TextEditingController memberNameController = TextEditingController();
  late List<String> selectedRole;
  late List<String> roleNames;
  late final ClubRolesService clubRolesService;
  bool _isLoading = false; // Add a variable to track loading state

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

  Future<void> removePlayerFromClub(String playerId) async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final DocumentSnapshot<Map<String, dynamic>> admin =
            await FirebaseFirestore.instance
                .collection('players')
                .doc(currentUser.uid)
                .get();
        final data = admin.data();
        final String clubId = data!['createdClubId'] as String? ?? '';

        final DocumentReference<Map<String, dynamic>> clubReference =
            FirebaseFirestore.instance.collection('clubs').doc(clubId);

        final clubSnapshot = await clubReference.get();
        final clubData = clubSnapshot.data();
        if (clubData != null) {
          final List<String> memberIds =
              List<String>.from(clubData['memberIds'] ?? []);
          if (memberIds.contains(playerId)) {
            memberIds.remove(playerId);
            await clubReference.update({'memberIds': memberIds});
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Player removed from the club')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Player is not a member of the club')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Club data not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
    } catch (e) {
      print('Error removing player from club: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Error removing player from club. Please try again later.'),
        ),
      );
    }
  }

  void _assignRole() async {
    final String memberName = widget.player.playerName;
    final double level = context.read<SliderCubit>().state;
    final String skillLevel = level.round().toString();

    if (memberName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the member name')),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true; // Set loading state to true
      });

      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final ClubRolesService clubRolesService = ClubRolesService();
        final String? playerId =
            await clubRolesService.getPlayerIdByName(memberName);
        if (playerId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Player not found with the given name')),
          );
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
                .doc(currentUser.uid)
                .get();

        final data = admin.data();
        if (data != null) {
          final String createdClubId = data['createdClubId'] as String? ?? '';

          if (selectedRole.isEmpty) {
            // Update only skill level if no roles are selected
            final Map<String, dynamic> updatedPlayerData = {
              'skillLevel': skillLevel,
            };
            await playerSnapshot.reference.update(updatedPlayerData);
          } else {
            // Update both club roles and skill level if roles are selected
            final Map<String, String> clubRoles = {
              createdClubId: selectedRole.join(","),
            };

            final Map<String, dynamic> updatedPlayerData = {
              'clubRoles': clubRoles,
              'skillLevel': skillLevel,
            };
            await playerSnapshot.reference.update(updatedPlayerData);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Roles assigned successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Player data not found')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
      }
    } catch (e) {
      print('Error assigning roles: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error assigning roles. Please try again later.')),
      );
    } finally {
      setState(() {
        _isLoading =
            false; // Set loading state to false after the operation is done
      });
    }
  }

  List<String> getRolesFromClubRoles(Map<String, String> clubRoles) {
    List<String> roles = [];
    for (var roleValue in clubRoles.values) {
      final individualRoles = roleValue.split(',');
      roles.addAll(individualRoles.map((role) => role.trim()));
    }
    return roles;
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
                                Text(
                                  widget.player.skillLevel.isNotEmpty
                                      ? widget.player.skillLevel
                                      : '0',
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
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
                                  widget.player.clubRoles['membership'] ??
                                      'Clear',
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
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
                                Text(
                                  widget.player.playerType,
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
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
                                Text(
                                  DateFormat('MMM d, yyyy')
                                      .format(widget.player.birthDate),
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
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
                                Text(
                                  selectedRole.join(', ').isNotEmpty
                                      ? selectedRole.join(', ')
                                      : widget.player.clubRoles.isNotEmpty
                                          ? getRolesFromClubRoles(
                                                  widget.player.clubRoles)
                                              .join(', ')
                                          : 'No Role Assigned',
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
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
                  updateRoleWithSelectedRole(words);
                },
                words: roleNames, // Use the fetched role names here
              ),
            ),
            SizedBox(
              height: screenHeight * .025,
            ),
            const Text(
              'Assign Player Skill Level',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),

            const RangeSliderWithTooltip(
              text1: '',
              text2: '',
            ),
            GestureDetector(
              onTap: () async {
                await removePlayerFromClub(widget.player.playerId);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManagementScreen(),
                  ),
                );
              },
              child: const Text(
                'Remove Member?',
                style: TextStyle(
                  color: Color(0xFF0D5FC3),
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future:
                    Future.delayed(Duration.zero), // Create a delayed Future
                builder: (context, snapshot) {
                  // Show the circular progress indicator if _isLoading is true
                  if (_isLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    // Show the "Assign Role" button otherwise
                    return BottomSheetContainer(
                      buttonText: 'Assign Role',
                      onPressed: _assignRole,
                      color: const Color(0xFFF8F8F8),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
