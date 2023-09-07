import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/find_match/view/screens/people_requirment.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import 'package:tennis_app/models/club.dart';
import 'package:tennis_app/models/player.dart';
import '../../../../core/utils/widgets/input_date.dart';
import '../../../../generated/l10n.dart';
import '../../create_profile/cubits/player_type_cubit.dart';
import '../../create_profile/widgets/input_time.dart';
import '../../create_profile/widgets/player_type.dart';
import '../../create_profile/widgets/profile_image.dart';
import '../cubit/find_match_cubit.dart';
import '../cubit/find_match_states.dart';

// ignore: must_be_immutable
class FindMatch extends StatelessWidget {
  FindMatch({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  TimeOfDay? _selectedTime;
  var formKey = GlobalKey<FormState>();
  Uint8List? _selectedImageBytes;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => FindMatchCubit(),
      child: BlocConsumer<FindMatchCubit, FindMatchState>(
        listener: (context, state) {
          if (state is FindMatchSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PeopleRequirement(match: state.match),
              ),
            );
          } else if (state is FindMatchError) {
            // Handle errors that occurred during data saving
            showSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is FindMatchLoading) {
            // Show a loading indicator here if needed
            return Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            Method method = Method();
            return FutureBuilder<Player>(
                future: method.getCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Dialog.fullscreen(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child:
                            Text('${S.of(context).error}:${snapshot.error}'));
                  }

                  final player = snapshot.data;

                  // Set player's data in controllers
                  nameController.text = player?.playerName ?? '';

                  return FutureBuilder<Club>(
                      future: method.fetchClubData(player!.participatedClubId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Dialog.fullscreen(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  '${S.of(context).error}: ${snapshot.error}'));
                        }

                        final club = snapshot.data;
                        addressController.text = club!.address;
                        return Scaffold(
                          body: Container(
                            color: const Color(0xFFF8F8F8),
                            child: SingleChildScrollView(
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
                                    text: S.of(context).Find_Match,
                                    suffixIconPath: '',
                                  ),
                                  Text(
                                    S.of(context).set_requirements,
                                    style: const TextStyle(
                                      color: Color(0xFF313131),
                                      fontSize: 20,
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: const ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                        shadows: [
                                          BoxShadow(
                                            color: Color(0x440D5FC3),
                                            blurRadius: 5,
                                            offset: Offset(0, 1),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: screenHeight * .025),
                                            ProfileImage(
                                              onImageSelected:
                                                  (File imageFile) {
                                                _selectedImageBytes =
                                                    imageFile.readAsBytesSync();
                                              },
                                            ),
                                            SizedBox(
                                                height: screenHeight * .025),
                                            InputDate(
                                              hint: S
                                                  .of(context)
                                                  .Select_Date_of_Birth,
                                              text: S.of(context).Your_Age,
                                              onDateTimeSelected:
                                                  (DateTime dateTime) {
                                                // Handle date selection
                                              },
                                            ),
                                            SizedBox(
                                                height: screenHeight * .025),
                                            InputTimeField(
                                              hint: S
                                                  .of(context)
                                                  .typeYourPreferredPlayingTime,
                                              text: S
                                                  .of(context)
                                                  .preferredPlayingTime,
                                              onTimeSelected:
                                                  (TimeOfDay? time) {
                                                _selectedTime = time;
                                              },
                                            ),
                                            SizedBox(
                                                height: screenHeight * .025),
                                            const PlayerType(),
                                            SizedBox(
                                                height: screenHeight * .015),
                                            SizedBox(
                                                height: screenHeight * .03),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: BottomSheetContainer(
                                                buttonText: S.of(context).Find,
                                                onPressed: () async {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    // Retrieve the necessary data from the form and other widgets
                                                    DateTime? selectedDateTime =
                                                        context
                                                            .read<DateCubit>()
                                                            .state;

                                                    String? selectedPlayerType =
                                                        context
                                                            .read<
                                                                PlayerTypeCubit>()
                                                            .state;
                                                    Uint8List?
                                                        selectedImageBytes =
                                                        _selectedImageBytes;
                                                    User? user = FirebaseAuth
                                                        .instance.currentUser;

                                                    context
                                                        .read<FindMatchCubit>()
                                                        .saveData(
                                                          user!.uid.toString(),
                                                          nameController,
                                                          addressController,
                                                          selectedDateTime,
                                                          _selectedTime,
                                                          selectedPlayerType,
                                                          selectedImageBytes,
                                                          context,
                                                        );
                                                  }
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                });
          }
        },
      ),
    );
  }
}
