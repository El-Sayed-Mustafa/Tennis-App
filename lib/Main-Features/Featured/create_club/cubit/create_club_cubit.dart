import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../../models/club.dart';
import '../view/widgets/Age_restriction.dart';
import '../view/widgets/club_type.dart';
import 'create_club_state.dart';

class CreateClubCubit extends Cubit<CreateClubInitialState> {
  CreateClubCubit(this.context) : super(CreateClubInitialState());
  final BuildContext context;

  void saveClubData({
    required TextEditingController clubNameController,
    required TextEditingController adminNameController,
    required TextEditingController nationalIDController,
    required TextEditingController phoneController,
    required TextEditingController emailController,
    required TextEditingController rulesController,
    Uint8List? selectedImageBytes,
  }) async {
    ClubType selectedClubType = context.read<ClubTypeCubit>().state;
    int selectedChoice = context.read<AgeRestrictionCubit>().getSelectedValue();

    try {
      String clubName = clubNameController.text;
      String clubAdmin = adminNameController.text;
      String nationalID = nationalIDController.text;
      String phoneNumber = phoneController.text;
      String email = emailController.text;
      String rulesAndRegulations = rulesController.text;
      String ageRestriction = getAgeRestrictionLabel(
          selectedChoice); // Convert selectedChoice to the corresponding label

      List<String> eventIds = []; // Add the event IDs if needed
      List<String> memberIds = []; // Add the member IDs if needed

      Club club = Club(
        clubId: '', // Assign a club ID here if applicable
        clubName: clubName,
        clubType: selectedClubType
            .toString()
            .split('.')
            .last, // Convert the enum value to string
        clubAdmin: clubAdmin,
        nationalIdNumber: nationalID,
        phoneNumber: phoneNumber,
        email: email,
        rulesAndRegulations: rulesAndRegulations,
        ageRestriction: ageRestriction,
        eventIds: eventIds,
        memberIds: memberIds,
      );

      CollectionReference clubsCollection =
          FirebaseFirestore.instance.collection('clubs');
      DocumentReference clubDocRef = await clubsCollection.add(club.toJson());

      // Upload the selected image to Firebase Storage
      if (selectedImageBytes != null) {
        firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('clubs')
            .child(clubDocRef.id)
            .child('club-image.jpg');
        firebase_storage.UploadTask uploadTask =
            storageReference.putData(selectedImageBytes);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Update the club document with the image URL
        await clubDocRef.update({'clubImageURL': imageUrl});
      }

      // Data saved successfully
      print('Club data saved successfully.');

      // You can emit a success state if needed
      // emit(CreateClubSuccessState());

      // Redirect to the next screen using GoRouter
      GoRouter.of(context).push('/home');
    } catch (error) {
      // Handle the error if needed
      print('Error: $error');
    }
  }

  String getAgeRestrictionLabel(int selectedChoice) {
    switch (selectedChoice) {
      case 1:
        return 'Above 20';
      case 2:
        return 'Above 18';
      case 3:
        return 'Everyone';
      default:
        return '';
    }
  }
}