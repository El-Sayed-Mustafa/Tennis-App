// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/club/edit_club/edit_club_screen.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/methodes/roles_manager.dart';
import 'package:tennis_app/core/utils/widgets/confirmation_dialog.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/core/utils/widgets/custom_dialouge.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import 'package:tennis_app/generated/l10n.dart';
import 'package:tennis_app/models/club.dart';

class ClubDetailsScreen extends StatelessWidget {
  const ClubDetailsScreen({super.key, required this.club});
  final Club club;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Method method = Method();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PoPAppBarWave(
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
              text: S.of(context).Club,
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
                              club.clubName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).Club_Type,
                                  style: const TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  club.clubType,
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).Club_Address,
                                  style: const TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  club.address,
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).ClubRate,
                                  style: const TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  club.rate.toString(),
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  S.of(context).Age_restriction,
                                  style: const TextStyle(
                                    color: Color(0xFF15324F),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  club.ageRestriction,
                                  style: const TextStyle(
                                    color: Color(0xFF6D6D6D),
                                    fontSize: 18,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 25),
                            Text(
                              S.of(context).Rules_and_regulations,
                              style: const TextStyle(
                                color: Color(0xFF6D6D6D),
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: screenWidth * .8,
                              height: screenHeight * .2,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(31),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(
                                        0x440D5FC3), // Shadow color with opacity (adjust the alpha value)
                                    blurRadius:
                                        3.0, // Adjust the blur radius as per your preference
                                    spreadRadius:
                                        .5, // Adjust the spread radius as per your preference
                                    offset: Offset(0,
                                        0), // Adjust the offset to control the position of the shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 24, bottom: 6, top: 6),
                                  child: Text(
                                    club.rulesAndRegulations.isEmpty
                                        ? 'No Rules and Regulations'
                                        : club.rulesAndRegulations,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 152, 150, 150),
                                      fontSize: 17,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 25),
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
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 0.50, color: Color(0x440D5FC3)),
                            borderRadius: BorderRadius.circular(31),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              (screenHeight + screenWidth) * 0.08 / 3),
                          child: Container(
                            height: (screenHeight + screenWidth) * 0.1,
                            width: (screenHeight + screenWidth) * 0.08,
                            child: club.photoURL != null
                                ? Image.network(
                                    club.photoURL!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/profile-event.jpg',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            BottomSheetContainer(
              buttonText: S.of(context).Edit_club,
              onPressed: () async {
                bool hasRight = await RolesManager.instance
                    .doesPlayerHaveRight('Edit Club');

                if (hasRight) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditClub(
                        club: club,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      text: S.of(context).noRightMessage,
                    ),
                  );
                }
              },
            ),
            BottomSheetContainer(
              buttonText: S.of(context).Delete_club,
              onPressed: () async {
                bool hasRight = await RolesManager.instance
                    .doesPlayerHaveRight('Delete Club');

                // bool hasRight = await RolesManager.instance.doesPlayerHaveRight('Delete Club');
                if (hasRight) {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return ConfirmationDialog(
                        title: S.of(context).Confirm,
                        content: S.of(context).Delete_club,
                        confirmText: S.of(context).Delete,
                        cancelText: S.of(context).cancel,
                        onConfirm: () {
                          method.deleteClub(club.clubId);
                          GoRouter.of(context).push('/home');
                        },
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      text: S.of(context).noRightMessage,
                    ),
                  );
                }
              },
              backgroundColor: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
