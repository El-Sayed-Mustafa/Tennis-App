import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/app_bar_wave.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/gender_selection.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/input_date.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/input_time.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/profile_image.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../core/utils/widgets/input_date.dart';
import '../../../core/utils/widgets/text_field.dart';
import '../../../generated/l10n.dart';
import 'cubit/Gender_Cubit.dart';
import 'cubit/player_type_cubit.dart';
import 'cubit/date_cubit.dart';
import 'cubit/time_cubit.dart';
import 'widgets/player_type.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  Uint8List? _selectedImageBytes;
  DateTime? _selectedDateTime;
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void saveUserData() async {
    String selectedGender = context.read<GenderCubit>().state;
    String playerName = nameController.text;
    String phoneNumber = phoneNumberController.text;
    DateTime? selectedDateTime = context.read<DateCubit>().state;
    String? selectedPlayerType = context.read<PlayerTypeCubit>().state;
    TimeOfDay? preferredPlayingTime = _selectedTime;

    CollectionReference playersCollection =
        FirebaseFirestore.instance.collection('players');
    DocumentReference playerDocRef = await playersCollection.add({
      'playerName': playerName,
      'phoneNumber': phoneNumber,
      'gender': selectedGender,
      'selectedDateTime': selectedDateTime?.toUtc(),
      'preferredPlayingTime': preferredPlayingTime != null
          ? '${preferredPlayingTime.hour}:${preferredPlayingTime.minute.toString().padLeft(2, '0')}'
          : null,
    });

    // Upload the selected image to Firebase Storage
    if (_selectedImageBytes != null) {
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('players')
          .child(playerDocRef.id)
          .child('profile-image.jpg');
      firebase_storage.UploadTask uploadTask =
          storageReference.putData(_selectedImageBytes!);
      firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Update the player document with the image URL
      await playerDocRef.update({'profileImageUrl': imageUrl});
    }

    // Data saved successfully
    print('User data saved successfully.');

    // Navigate to the next screen
    GoRouter.of(context).push('/chooseClub');
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF8F8F8),
          child: Column(
            children: [
              const AppBarWave(),
              ProfileImage(
                onImageSelected: (File imageFile) {
                  setState(() {
                    _selectedImageBytes = imageFile.readAsBytesSync();
                  });
                },
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                S.of(context).setProfilePicture,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenHeight * .03),
              const GenderSelection(),
              SizedBox(height: screenHeight * .03),
              InputTextWithHint(
                hint: S.of(context).typeYourName,
                text: S.of(context).playerName,
                controller: nameController,
              ),
              SizedBox(height: screenHeight * .025),
              InputTextWithHint(
                hint: S.of(context).typeYourPhoneNumber,
                text: S.of(context).phoneNumber,
                controller: phoneNumberController,
              ),
              SizedBox(height: screenHeight * .025),
              InputDate(
                hint: 'Select Date of Birth',
                format: 'dd/MM/yyyy',
                text: 'Your Age',
                onDateTimeSelected: (DateTime dateTime) {
                  setState(() {
                    _selectedDateTime = dateTime;
                  });
                },
              ),
              SizedBox(height: screenHeight * .025),
              InputTimeField(
                hint: S.of(context).typeYourPreferredPlayingTime,
                text: S.of(context).preferredPlayingTime,
                onTimeSelected: (TimeOfDay? time) {
                  setState(() {
                    _selectedTime = time;
                  });
                },
              ),
              SizedBox(height: screenHeight * .025),
              BlocProvider(
                create: (context) => PlayerTypeCubit(),
                child: const PlayerType(),
              ),
              SizedBox(height: screenHeight * .01),
              BottomSheetContainer(
                buttonText: S.of(context).create,
                onPressed: () {
                  saveUserData();
                },
                color: const Color(0xFFF8F8F8),
              )
            ],
          ),
        ),
      ),
    );
  }
}
