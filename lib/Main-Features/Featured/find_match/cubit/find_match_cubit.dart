import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../../models/Match.dart';
import 'find_match_states.dart';

class FindMatchCubit extends Cubit<FindMatchState> {
  FindMatchCubit() : super(FindMatchInitial());
  Future<List<Matches>> getAllMatches() async {
    final CollectionReference matchesCollection =
        FirebaseFirestore.instance.collection('matches');
    final QuerySnapshot<Object?> snapshot = await matchesCollection.get();
    final List<Matches> matchesList = snapshot.docs
        .map((doc) =>
            Matches.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
    return matchesList;
  }

  void saveData(
    String userId,
    TextEditingController nameController,
    TextEditingController addressController,
    DateTime? selectedDateTime,
    TimeOfDay? selectedTime,
    String? selectedPlayerType,
    TextEditingController clubNameController,
    Uint8List? selectedImageBytes,
    BuildContext context,
  ) async {
    try {
      emit(FindMatchLoading());

      // Upload the selected image to Firebase Storage
      String imageUrl = '';
      if (selectedImageBytes != null) {
        firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('matches')
            .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
        firebase_storage.UploadTask uploadTask =
            storageReference.putData(selectedImageBytes);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      // Create a new Match object with the form data
      Matches newMatch = Matches(
        userId: userId,
        playerName: nameController.text,
        photoURL: selectedImageBytes != null ? imageUrl : null,
        address: addressController.text,
        dob: selectedDateTime!,
        preferredPlayingTime: selectedTime?.format(context) ?? '',
        playerType: selectedPlayerType!,
        clubName: clubNameController.text,
      );

      // Save the new match to Firestore
      final CollectionReference matchesCollection =
          FirebaseFirestore.instance.collection('matches');
      await matchesCollection.add(newMatch.toJson());

      // Get the ID of the newly added match from Firestore
      String matchId = matchesCollection.id;

      // Create a new Matches object with the Firestore-generated ID
      Matches newMatchWithId = newMatch.copyWith(userId: matchId);

      emit(FindMatchSuccess(newMatchWithId));
    } catch (e) {
      emit(FindMatchError('Error saving data: $e'));
    }
  }
}
