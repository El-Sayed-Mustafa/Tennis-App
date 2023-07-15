import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/input_date_and_time.dart';

import '../../../../models/event.dart';
import '../../create_event/cubit/create_event_state.dart';
import '../../create_event/view/widgets/event_types.dart';
import '../view/widgets/input_end_date.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit(this.context) : super(CreateEventInitialState());
  final BuildContext context;

  void saveEventData({
    required TextEditingController eventNameController,
    required TextEditingController addressController,
    required TextEditingController courtNameController,
    required TextEditingController instructionsController,
    Uint8List? selectedImageBytes,
    required BuildContext context,
  }) async {
    try {
      emit(CreateEventLoadingState());

      String eventName = eventNameController.text;
      String eventAddress = addressController.text;
      String courtName = courtNameController.text;
      String instructions = instructionsController.text;
      DateTime? selectedStartDateTime = context.read<DateTimeCubit>().state;
      DateTime? selectedEndDateTime = context.read<EndDateTimeCubit>().state;
      EventType selectedEventType = context.read<EventTypeCubit>().state;

      Event event = Event(
        eventId: '', // Assign an event ID here if applicable
        eventName: eventName,
        eventStartAt:
            selectedStartDateTime, // Replace with the actual start time
        eventEndsAt: selectedEndDateTime, // Replace with the actual end time
        eventAddress: eventAddress,
        eventType: selectedEventType
            .toString()
            .split('.')
            .last, // Convert the enum value to string
        courtName: courtName,
        instructions: instructions,
        playerIds: [],
      );

      CollectionReference eventsCollection =
          FirebaseFirestore.instance.collection('events');
      DocumentReference eventDocRef =
          await eventsCollection.add(event.toJson());

      // Upload the selected image to Firebase Storage
      if (selectedImageBytes != null) {
        firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('events')
            .child(eventDocRef.id)
            .child('event-image.jpg');
        firebase_storage.UploadTask uploadTask =
            storageReference.putData(selectedImageBytes);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Update the event document with the image URL
        await eventDocRef.update({'eventImageUrl': imageUrl});
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
}
