// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tennis_app/core/utils/snackbar.dart';

import '../../../../models/club.dart';
import '../view/widgets/Age_restriction.dart';
import '../view/widgets/club_type.dart';
import 'create_club_state.dart';

class CreateClubCubit extends Cubit<CreateClubState> {
  CreateClubCubit(this.context) : super(CreateClubInitialState());
  final BuildContext context;

  void saveClubData({
    required TextEditingController clubNameController,
    required TextEditingController phoneController,
    required TextEditingController rulesController,
    required TextEditingController addressController,
    Uint8List? selectedImageBytes,
  }) async {
    ClubType selectedClubType = context.read<ClubTypeCubit>().state;
    int selectedChoice = context.read<AgeRestrictionCubit>().getSelectedValue();
    emit(CreateClubLoadingState());
    try {
      String clubName = clubNameController.text;
      String phoneNumber = phoneController.text;
      String rulesAndRegulations = rulesController.text;
      String ageRestriction = getAgeRestrictionLabel(selectedChoice);
      String address = addressController.text;
      String currentUserID = FirebaseAuth.instance.currentUser!.uid;

      List<String> eventIds = []; // Add the event IDs if needed
      List<String> memberIds = [currentUserID]; // Add the member IDs if needed

      Club club = Club(
        clubId: '', // Assign a club ID here if applicable
        clubName: clubName,
        clubType: selectedClubType
            .toString()
            .split('.')
            .last, // Convert the enum value to string
        clubAdmin: currentUserID,
        phoneNumber: phoneNumber,

        rulesAndRegulations: rulesAndRegulations,
        ageRestriction: ageRestriction,
        eventIds: eventIds,
        memberIds: memberIds, roleIds: [], address: address, rate: 0,
        matchPlayed: 0,
        totalWins: 0,
        clubChatId: '',
        doubleMatchesIds: [],
        doubleTournamentsIds: [],
        singleMatchesIds: [],
        singleTournamentsIds: [], numberOfRatings: 0, courtIds: [],
      );

      CollectionReference clubsCollection =
          FirebaseFirestore.instance.collection('clubs');
      DocumentReference clubDocRef = await clubsCollection.add(club.toJson());

      // Create a new chat document in the 'Chat' collection
      CollectionReference chatCollection =
          FirebaseFirestore.instance.collection('Chats');
      DocumentReference chatDocRef = await chatCollection.add({
        'clubId': clubDocRef.id, // Store the reference to the club
        'messages': [], // Initialize with an empty array of messages
      });

      // Update the club document with the chat ID
      await clubDocRef.update({'clubChatId': chatDocRef.id});

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

      // Save the club ID in the current user's data
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('players').doc(currentUserID);
      await userDocRef.update({'participatedClubId': clubDocRef.id});

      // Data saved successfully
      showSnackBar(context, 'Club data saved successfully.');

      // You can emit a success state if needed
      emit(CreateClubSuccessState());

      // Redirect to the next screen using GoRouter
      GoRouter.of(context).pop();
    } catch (error) {
      // Handle the error if needed
      emit(CreateClubErrorState(error: error.toString()));
      showSnackBar(context, 'Error: $error');
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
