// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_app/Main-Features/menu/widgets/button_menu.dart';
import 'package:tennis_app/core/methodes/roles_manager.dart';
import 'package:tennis_app/core/utils/widgets/confirmation_dialog.dart';
import 'package:tennis_app/core/utils/widgets/custom_dialouge.dart';

import '../../Auth/services/auth_methods.dart';
import '../../core/methodes/firebase_methodes.dart';
import '../../core/utils/widgets/app_bar_wave.dart';
import '../../generated/l10n.dart';
import '../../models/player.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final Method method = Method();

    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<Player>(
          future: method.getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('${S.of(context).error}: ${snapshot.error}'));
            } else {
              final player = snapshot.data!;

              return Container(
                color: const Color(0xFFF8F8F8),
                child: Column(
                  children: [
                    PoPBarWaveHome(
                      text: S.of(context).Menu,
                      suffixIconPath: 'assets/images/app-bar-icon.svg',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: screenHeight * 0.13,
                      width: screenHeight * 0.13,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey, // Customize the border color here
                          width: 2.0, // Customize the border width here
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: (player.photoURL != ''
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/images/loadin.gif',
                                image: player.photoURL!,
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  // Show the placeholder image on error
                                  return Image.asset(
                                    'assets/images/profileimage.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/images/profile-event.jpg',
                                fit: BoxFit.cover,
                              )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonMenu(
                      imagePath: 'assets/images/setting1.svg',
                      buttonText: S.of(context).Your_Profile,
                      onPressed: () {
                        GoRouter.of(context).push('/profileScreen');
                      },
                    ),
                    ButtonMenu(
                      imagePath: 'assets/images/Event-Calnder.svg',
                      buttonText: S.of(context).Event_Calendar,
                      onPressed: () {
                        GoRouter.of(context).push('/calendar');
                      },
                    ),
                    ButtonMenu(
                      imagePath: 'assets/images/Member-administration.svg',
                      buttonText: S.of(context).Member_administration,
                      onPressed: () async {
                        bool hasRight = await RolesManager.instance
                            .doesPlayerHaveRight('Edit Club');
                        if (hasRight) {
                          GoRouter.of(context).push('/management');
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
                    ButtonMenu(
                      imagePath: 'assets/images/Create-role.svg',
                      buttonText: S.of(context).Create_Role,
                      onPressed: () async {
                        bool hasRight = await RolesManager.instance
                            .doesPlayerHaveRight('Create Roles');

                        // bool hasRight =
                        //     await RolesManager.instance.doesPlayerHaveRight('Create Roles');
                        if (hasRight) {
                          GoRouter.of(context).push('/createRole');
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
                    ButtonMenu(
                      imagePath: 'assets/images/Create-role.svg',
                      buttonText: S.of(context).Assign_Person,
                      onPressed: () async {
                        bool hasRight = await RolesManager.instance
                            .doesPlayerHaveRight('Create Roles');
                        if (hasRight) {
                          GoRouter.of(context).push('/assignPerson');
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
                    ButtonMenu(
                      imagePath: 'assets/images/Create-role.svg',
                      buttonText: S.of(context).Roles_list,
                      onPressed: () async {
                        bool hasRight = await RolesManager.instance
                            .doesPlayerHaveRight('Create Roles');
                        if (hasRight) {
                          GoRouter.of(context).push('/rolesList');
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
                    ButtonMenu(
                      imagePath: 'assets/images/languages.svg',
                      buttonText: S.of(context).language,
                      onPressed: () {
                        GoRouter.of(context).push('/languages');
                      },
                    ),
                    ButtonMenu(
                      imagePath: 'assets/images/members.svg',
                      buttonText: S.of(context).clubInvitations,
                      onPressed: () {
                        GoRouter.of(context).push('/chooseClub');
                      },
                    ),
                    ButtonMenu(
                      imagePath: 'assets/images/logout.svg',
                      buttonText: S.of(context).logout,
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return ConfirmationDialog(
                              title:
                                  '${S.of(context).confirm} ${S.of(context).logout}',
                              content: '',
                              confirmText: S.of(context).logout,
                              cancelText: S.of(context).cancel,
                              onConfirm: () async {
                                final FirebaseAuthMethods authService =
                                    FirebaseAuthMethods();

                                await authService.signOut();
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('showHome', false);
                                while (GoRouter.of(context).canPop() == true) {
                                  GoRouter.of(context).pop();
                                }
                                GoRouter.of(context).pushReplacement('/auth');
                              },
                            );
                          },
                        );
                      },
                    ),
                    ButtonMenu(
                      imagePath: 'assets/images/delete.svg',
                      buttonText: 'Delete Account',
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return ConfirmationDialog(
                              title:
                                  '${S.of(context).confirm} ${S.of(context).delete}',
                              content: '',
                              confirmText: S.of(context).delete,
                              cancelText: S.of(context).cancel,
                              onConfirm: () async {
                                final Method authService = Method();

                                await authService.deleteUser();
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setBool('showHome', false);
                                while (GoRouter.of(context).canPop() == true) {
                                  GoRouter.of(context).pop();
                                }
                                GoRouter.of(context).pushReplacement('/auth');
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
