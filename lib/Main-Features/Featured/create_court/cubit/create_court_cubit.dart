// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:tennis_app/Main-Features/Featured/create_court/cubit/create_court_states.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/input_date.dart';
import '../../../../models/court.dart';

class CreateCourtCubit extends Cubit<CreateCourtState> {
  CreateCourtCubit(this.context) : super(CreateCourtInitialState());
  final BuildContext context;

  void saveCourtData({
    required TextEditingController courtNameController,
    required TextEditingController phoneController,
    required TextEditingController addressController,
    required String from,
    required String to,
    Uint8List? selectedImageBytes,
  }) async {
    emit(CreateCourtLoadingState());
    try {
      String courtName = courtNameController.text;
      String phoneNumber = phoneController.text;
      String address = addressController.text;
      DateTime? selectedStartDateTime = context.read<DateCubit>().state;

      List<String> availableTimeSlots = [];
      int fromHours = int.parse(from.split(':')[0]);
      int toHours = int.parse(to.split(':')[0]);

      // Loop through hours and add each hour range to availableTimeSlots
      for (int currentHour = fromHours; currentHour < toHours; currentHour++) {
        String currentHourStr = currentHour.toString().padLeft(2, '0');
        String nextHourStr = (currentHour + 1).toString().padLeft(2, '0');
        availableTimeSlots.add('$currentHourStr:00 - $nextHourStr:00');
      }

      Court court = Court(
        courtId: '', // Assign a court ID here if applicable
        courtName: courtName,
        phoneNumber: phoneNumber,
        availableDay: selectedStartDateTime,
        courtAddress: address,
        photoURL: '',
        from: from,
        to: to,
        availableTimeSlots: availableTimeSlots, // Assign the list of hours
        reversedTimeSlots: {},
      );

      CollectionReference courtsCollection =
          FirebaseFirestore.instance.collection('courts');
      DocumentReference courtDocRef =
          await courtsCollection.add(court.toJson());

      // Get the ID of the newly created court document
      String newCourtId = courtDocRef.id;

      // Update the court document with the retrieved ID
      await courtDocRef.update({'courtId': newCourtId});

      // Upload the selected image to Firebase Storage
      if (selectedImageBytes != null) {
        firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('courts')
            .child(newCourtId)
            .child('court-image.jpg');
        firebase_storage.UploadTask uploadTask =
            storageReference.putData(selectedImageBytes);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Update the court document with the image URL
        await courtDocRef.update({'photoURL': imageUrl});
      }
      Method method = Method();
      final player = await method.getCurrentUser();

      final clubRef = FirebaseFirestore.instance
          .collection('clubs')
          .doc(player.participatedClubId);
      await clubRef.update({
        'courtIds': FieldValue.arrayUnion([newCourtId])
      }); // You can emit a success state if needed
      emit(CreateCourtSuccessState());

      // Redirect to the next screen using GoRouter
      GoRouter.of(context).pop();
    } catch (error) {
      // Handle the error if needed
      emit(CreateCourtErrorState(error: error.toString()));
      showSnackBar(context, 'Error: $error');
    }
  }
}
