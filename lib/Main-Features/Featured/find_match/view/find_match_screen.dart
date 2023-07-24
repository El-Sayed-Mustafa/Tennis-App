import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/app_bar_wave.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../../core/utils/widgets/input_date.dart';
import '../../../../core/utils/widgets/text_field.dart';
import '../../../../generated/l10n.dart';
import '../../create_event/view/widgets/club_names.dart';
import '../../create_profile/cubits/player_type_cubit.dart';
import '../../create_profile/widgets/input_time.dart';
import '../../create_profile/widgets/player_type.dart';
import '../../create_profile/widgets/profile_image.dart';

// ignore: must_be_immutable
class FindMatch extends StatelessWidget {
  FindMatch({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController clubNameController = TextEditingController();
  TimeOfDay? _selectedTime;
  var formKey = GlobalKey<FormState>();
  Uint8List? _selectedImageBytes;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => ClubNamesCubit(),
      child: Scaffold(
        body: Container(
          color: const Color(0xFFF8F8F8),
          child: SingleChildScrollView(
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
                  text: '    Find Match',
                  suffixIconPath: '',
                ),
                const Text(
                  'Set Requirements',
                  style: TextStyle(
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
                          SizedBox(height: screenHeight * .025),
                          ProfileImage(
                            onImageSelected: (File imageFile) {
                              _selectedImageBytes = imageFile.readAsBytesSync();
                            },
                          ),
                          SizedBox(height: screenHeight * .025),
                          InputTextWithHint(
                            hint: S.of(context).typeYourName,
                            text: S.of(context).playerName,
                            controller: nameController,
                          ),
                          SizedBox(height: screenHeight * .025),
                          InputTextWithHint(
                            hint: 'Type Club Address here',
                            text: 'Club Address',
                            controller: addressController,
                          ),
                          SizedBox(height: screenHeight * .025),
                          InputDate(
                            hint: 'Select Date of Birth',
                            text: 'Your Age',
                            onDateTimeSelected: (DateTime dateTime) {
                              // Handle date selection
                            },
                          ),
                          SizedBox(height: screenHeight * .025),
                          InputTimeField(
                            hint: S.of(context).typeYourPreferredPlayingTime,
                            text: S.of(context).preferredPlayingTime,
                            onTimeSelected: (TimeOfDay? time) {
                              _selectedTime = time;
                            },
                          ),
                          SizedBox(height: screenHeight * .025),
                          const PlayerType(),
                          SizedBox(height: screenHeight * .015),
                          SizedBox(height: screenHeight * .03),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: ClubComboBox(
                              controller: clubNameController,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BottomSheetContainer(
                              buttonText: 'Find',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  // Save the data to Firebase Firestore
                                  try {
                                    final CollectionReference
                                        matchesCollection = FirebaseFirestore
                                            .instance
                                            .collection('matches');
                                    DateTime? selectedDateTime =
                                        context.read<DateCubit>().state;
                                    String? selectedPlayerType =
                                        context.read<PlayerTypeCubit>().state;

                                    // Upload the selected image to Firebase Storage
                                    if (_selectedImageBytes != null) {
                                      firebase_storage.Reference
                                          storageReference = firebase_storage
                                              .FirebaseStorage.instance
                                              .ref()
                                              .child('matches')
                                              .child(DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString() +
                                                  '.jpg');
                                      firebase_storage.UploadTask uploadTask =
                                          storageReference
                                              .putData(_selectedImageBytes!);
                                      firebase_storage.TaskSnapshot
                                          taskSnapshot = await uploadTask;
                                      String imageUrl = await taskSnapshot.ref
                                          .getDownloadURL();

                                      // Update the player document with the image URL
                                      await matchesCollection.add({
                                        'name': nameController.text,
                                        'address': addressController.text,
                                        'dob':
                                            selectedDateTime, // Replace 'selectedDate' with the selected date value
                                        'preferredPlayingTime':
                                            _selectedTime?.format(
                                                context), // Replace '_selectedTime' with the selected time value
                                        'playerType':
                                            selectedPlayerType, // Replace 'selectedPlayerType' with the selected player type value
                                        'clubName': clubNameController.text,
                                        'photoURL': imageUrl,
                                      });
                                    } else {
                                      // If no image is selected, save data without the image URL
                                      await matchesCollection.add({
                                        'name': nameController.text,
                                        'address': addressController.text,
                                        'dob':
                                            selectedDateTime, // Replace 'selectedDate' with the selected date value
                                        'preferredPlayingTime':
                                            _selectedTime?.format(
                                                context), // Replace '_selectedTime' with the selected time value
                                        'playerType':
                                            selectedPlayerType, // Replace 'selectedPlayerType' with the selected player type value
                                        'clubName': clubNameController.text,
                                      });
                                    }

                                    print('Data saved successfully.');
                                  } catch (e) {
                                    // Handle any errors that occurred during data saving
                                    print('Error saving data: $e');
                                  }
                                }
                              },
                              color: Colors.white,
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
      ),
    );
  }
}
