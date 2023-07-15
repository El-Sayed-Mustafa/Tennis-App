import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/input_date_and_time.dart';

import '../../../../models/event.dart';
import '../../create_event/cubit/create_event_state.dart';
import '../../create_event/view/widgets/event_types.dart';
import '../view/widgets/club_names.dart';
import '../view/widgets/input_end_date.dart';
import '../view/widgets/player_level.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit(this.context) : super(CreateEventInitialState());
  final BuildContext context;

  void saveEventData({
    required TextEditingController eventNameController,
    required TextEditingController addressController,
    required TextEditingController courtNameController,
    required TextEditingController instructionsController,
    required TextEditingController clubNameController,
    Uint8List? selectedImageBytes,
    required BuildContext context,
  }) async {
    try {
      emit(CreateEventLoadingState());

      final String eventName = eventNameController.text;
      final String eventAddress = addressController.text;
      final String courtName = courtNameController.text;
      final String instructions = instructionsController.text;
      DateTime? selectedStartDateTime = context.read<DateTimeCubit>().state;
      DateTime? selectedEndDateTime = context.read<EndDateTimeCubit>().state;
      final EventType selectedEventType = context.read<EventTypeCubit>().state;
      final double level = context.read<SliderCubit>().state;

      final String clubName = clubNameController.text;
      final String clubId = await getClubIdFromName(clubName);
      print(clubName + " " + clubId);
      final Event event = Event(
        eventId: '', // The event ID will be assigned by Firestore
        eventName: eventName,
        eventStartAt: selectedStartDateTime,
        eventEndsAt: selectedEndDateTime,
        eventAddress: eventAddress,
        eventType: selectedEventType.toString().split('.').last,
        courtName: courtName,
        instructions: instructions,
        playerIds: [],
        playerLevel: level,
        clubId: clubId,
      );

      final CollectionReference eventsCollection =
          FirebaseFirestore.instance.collection('events');
      final DocumentReference eventDocRef =
          await eventsCollection.doc(); // Generate a new unique ID

      await eventDocRef
          .set(event.toJson()); // Set the event document with the generated ID

      // Upload the selected image to Firebase Storage
      if (selectedImageBytes != null) {
        final firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('events')
            .child(eventDocRef.id)
            .child('event-image.jpg');
        final firebase_storage.UploadTask uploadTask =
            storageReference.putData(selectedImageBytes);
        final firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        final String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Update the event document with the image URL
        await eventDocRef.update({'eventImageUrl': imageUrl});
      }
      final DocumentSnapshot clubSnapshot = await FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubId)
          .get();

      if (clubSnapshot.exists) {
        final DocumentReference clubDocRef = clubSnapshot.reference;
        await clubDocRef.update({
          'eventIds': FieldValue.arrayUnion([eventDocRef.id]),
        });
      } else {
        throw Exception('Club not found with the given ID.');
      }

      final String playerId = FirebaseAuth.instance.currentUser!.uid;
      print('player Id:' + playerId);
      final DocumentSnapshot playerSnapshot = await FirebaseFirestore.instance
          .collection('players')
          .doc(playerId)
          .get();

      if (playerSnapshot.exists) {
        final DocumentReference playerDocRef = playerSnapshot.reference;
        await playerDocRef.update({
          'eventIds': FieldValue.arrayUnion([eventDocRef.id]),
        });
      } else {
        throw Exception('Player not found with the given ID.');
      }

      // Data saved successfully
      print('Event data saved successfully.');

      emit(CreateEventSuccessState());

      // Redirect to the next screen using GoRouter
      GoRouter.of(context).push('/home');
    } catch (error) {
      // Handle the error if needed
      emit(CreateEventErrorState(error: error.toString()));
      print('Error: $error');
    }
  }

  Future<String> getClubIdFromName(String clubName) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('clubs')
              .where('clubName', isEqualTo: clubName)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final clubDoc = snapshot.docs.first;
        return clubDoc.id;
      } else {
        throw Exception('Club not found with the given name.');
      }
    } catch (error) {
      throw Exception('Failed to get club ID from name: $error');
    }
  }
}
