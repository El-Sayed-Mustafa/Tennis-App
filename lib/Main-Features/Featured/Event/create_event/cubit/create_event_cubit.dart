// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/input_date_and_time.dart';

import '../../../../../models/club.dart';
import '../../../../../models/event.dart';
import '../../create_event/cubit/create_event_state.dart';
import '../../create_event/view/widgets/event_types.dart';
import '../view/widgets/input_end_date.dart';
import '../view/widgets/player_level.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit(this.context) : super(CreateEventInitialState());
  final BuildContext context;

  void saveEventData({
    String? eventId, // Optional eventId parameter
    required TextEditingController eventNameController,
    required TextEditingController addressController,
    required TextEditingController courtNameController,
    required TextEditingController instructionsController,
    Uint8List? selectedImageBytes,
    required BuildContext context,
    required List<String>? selected,
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

      final CollectionReference eventsCollection =
          FirebaseFirestore.instance.collection('events');

      if (eventId != null) {
        // Update an existing event
        final DocumentReference eventDocRef = eventsCollection.doc(eventId);
        final Event? existingEvent = await fetchEvent(eventDocRef);

        if (existingEvent != null) {
          final Event updatedEvent = Event(
            eventId: existingEvent.eventId,
            eventName: eventName,
            eventStartAt: selectedStartDateTime,
            eventEndsAt: selectedEndDateTime,
            eventAddress: eventAddress,
            eventType: selectedEventType.toString().split('.').last,
            courtName: courtName,
            instructions: instructions,
            playerIds: existingEvent.playerIds,
            playerLevel: level,
            clubId: existingEvent.clubId,
            photoURL: existingEvent.photoURL,
          );

          await saveEventDocument(eventDocRef, updatedEvent);
          await uploadEventImage(eventDocRef, selectedImageBytes);
          // You can update players or club here if needed
        } else {
          emit(
              CreateEventErrorState(error: 'Event not found for ID: $eventId'));
          return;
        }
      } else {
        // Create a new event
        final DocumentReference eventDocRef = eventsCollection.doc();
        final String newEventId = eventDocRef.id;

        final Event newEvent = Event(
          eventId: newEventId,
          eventName: eventName,
          eventStartAt: selectedStartDateTime,
          eventEndsAt: selectedEndDateTime,
          eventAddress: eventAddress,
          eventType: selectedEventType.toString().split('.').last,
          courtName: courtName,
          instructions: instructions,
          playerIds: [],
          playerLevel: level,
          clubId: '',
        );

        await saveEventDocument(eventDocRef, newEvent);
        await uploadEventImage(eventDocRef, selectedImageBytes);
        if (selected != null && selected.isNotEmpty) {
          await updatePlayersWithEvent(newEventId, selected);
        } else {
          await updateClubWithEvent(newEventId);
        }
      }

      emit(CreateEventSuccessState());

      GoRouter.of(context).push('/club');
    } catch (error) {
      emit(CreateEventErrorState(error: error.toString()));
      showSnackBar(context, 'Error: $error');
    }
  }

  Future<void> saveEventDocument(
      DocumentReference eventDocRef, Event event) async {
    await eventDocRef.set(event.toJson());
  }

  Future<void> uploadEventImage(
      DocumentReference eventDocRef, Uint8List? selectedImageBytes) async {
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

      await eventDocRef.update({'photoURL': imageUrl});
    }
  }

  Future<void> updateClubWithEvent(String eventId) async {
    final String playerId = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot playerSnapshot = await FirebaseFirestore.instance
        .collection('players')
        .doc(playerId)
        .get();

    final String participatedClubId = playerSnapshot['participatedClubId'];

    if (participatedClubId.isNotEmpty) {
      // Fetch the club data using the participatedClubId
      final clubSnapshot = await FirebaseFirestore.instance
          .collection('clubs')
          .doc(participatedClubId)
          .get();

      if (clubSnapshot.exists) {
        final Club club = Club.fromSnapshot(clubSnapshot);

        // Now you have the club data with the participated event and can perform further updates.
        // For example, you can update the eventIds list in the club document.
        final updatedEventIds = [...club.eventIds, eventId];

        await FirebaseFirestore.instance
            .collection('clubs')
            .doc(participatedClubId)
            .update({'eventIds': updatedEventIds});
      }
    }
  }

  Future<Event?> fetchEvent(DocumentReference eventDocRef) async {
    try {
      final eventSnapshot = await eventDocRef.get();
      if (eventSnapshot.exists) {
        final event = Event.fromSnapshot(
            eventSnapshot as DocumentSnapshot<Map<String, dynamic>>);
        return event;
      } else {
        return null;
      }
    } catch (error) {
      // Handle any errors that occur during fetching
      return null;
    }
  }

  Future<void> updatePlayersWithEvent(
      String eventId, List<String> playersId) async {
    final String playerId = FirebaseAuth.instance.currentUser!.uid;
    playersId.add(playerId);
    for (String playerId in playersId) {
      final DocumentSnapshot playerSnapshot = await FirebaseFirestore.instance
          .collection('players')
          .doc(playerId)
          .get();

      if (playerSnapshot.exists) {
        final DocumentReference playerDocRef = playerSnapshot.reference;
        await playerDocRef.update({
          'eventIds': FieldValue.arrayUnion([eventId]),
        });
      } else {}
    }
  }
}
