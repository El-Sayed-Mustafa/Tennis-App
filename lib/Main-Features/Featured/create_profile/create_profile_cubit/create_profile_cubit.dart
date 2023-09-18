// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/generated/l10n.dart';

import '../../../../core/utils/widgets/input_date.dart';
import '../../../../models/player.dart';
import '../cubits/Gender_Cubit.dart';
import '../cubits/player_type_cubit.dart';
import 'create_profile_states.dart';

class CreateProfileCubit extends Cubit<CreateProfileState> {
  final BuildContext context;

  CreateProfileCubit(this.context) : super(CreateProfileInitialState());

  void saveUserData({
    required TextEditingController nameController,
    required TextEditingController phoneNumberController,
    Uint8List? selectedImageBytes,
    TimeOfDay? selectedTime,
    required BuildContext context,
  }) async {
    emit(CreateProfileLoadingState());
    try {
      String selectedGender = context.read<GenderCubit>().state;
      String playerName = nameController.text;
      String phoneNumber = phoneNumberController.text;
      DateTime? selectedDateTime = context.read<DateCubit>().state;
      String? selectedPlayerType = context.read<PlayerTypeCubit>().state;

      // Get the currently authenticated user ID
      String playerId = FirebaseAuth.instance.currentUser?.uid ?? '';

      Player player = Player(
        playerId: playerId, // Use the UID as the player ID
        playerName: playerName,
        phoneNumber: phoneNumber,
        photoURL: '',
        playerLevel: '',
        matchPlayed: 0,
        totalWins: 0,
        skillLevel: '',
        gender: selectedGender,
        birthDate: selectedDateTime,
        preferredPlayingTime: selectedTime != null
            ? '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}'
            : '',
        playerType: selectedPlayerType,
        eventIds: [], clubRoles: {}, clubInvitationsIds: [],
        participatedClubId: '',
        matches: [],
        reversedCourtsIds: [],
        chatIds: [],
        doubleMatchesIds: [],
        doubleTournamentsIds: [],
        singleMatchesIds: [],
        singleTournamentsIds: [], isRated: false,
      );

      CollectionReference playersCollection =
          FirebaseFirestore.instance.collection('players');
      DocumentReference playerDocRef = playersCollection.doc(playerId);

      await playerDocRef.set(player.toJson());

      // Upload the selected image to Firebase Storage
      if (selectedImageBytes != null) {
        firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('players')
            .child(playerId)
            .child('profile-image.jpg');
        firebase_storage.UploadTask uploadTask =
            storageReference.putData(selectedImageBytes);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Update the player document with the image URL
        await playerDocRef.update({'photoURL': imageUrl});
      }

      // Data saved successfully
      showSnackBar(context, S.of(context).userDataSavedSuccessfully);

      emit(CreateProfileSuccessState());
      while (GoRouter.of(context).canPop() == true) {
        GoRouter.of(context).pop();
      }
      GoRouter.of(context).push('/home');
    } catch (error) {
      emit(CreateProfileErrorState(error: error.toString()));
    }
  }
}
