import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tennis_app/Main-Features/Featured/create_court/cubit/create_court_states.dart';

import '../../../../models/club.dart';

class CreateCourtCubit extends Cubit<CreateCourtState> {
  CreateCourtCubit(this.context) : super(CreateCourtInitialState());
  final BuildContext context;

  void saveClubData({
    required TextEditingController courtNameController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    Uint8List? selectedImageBytes,
  }) async {
    emit(CreateCourtLoadingState());
    try {
      String courtName = courtNameController.text;
      String phoneNumber = phoneController.text;
      String address = addressController.text;

      Club club = Club(
        clubId: '', // Assign a club ID here if applicable
        clubName: courtName,
        clubAdmin: clubAdmin,
        nationalIdNumber: nationalID,
        phoneNumber: phoneNumber,
        email: email,
        rulesAndRegulations: rulesAndRegulations,
        eventIds: eventIds,
        memberIds: memberIds, roleIds: [], address: address, rate: 0,
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

      // Save the club ID in the current user's data
      String currentUserID = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('players').doc(currentUserID);
      await userDocRef.update({
        'createdClubIds': FieldValue.arrayUnion([clubDocRef.id])
      });

      // Data saved successfully
      print('Club data saved successfully.');

      // You can emit a success state if needed
      emit(CreateCourtSuccessState());

      // Redirect to the next screen using GoRouter
      GoRouter.of(context).push('/home');
    } catch (error) {
      // Handle the error if needed
      emit(CreateCourtErrorState(error: error.toString()));
      print('Error: $error');
    }
  }
}
