import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/widgets/input_date_and_time.dart';
import '../../../../models/event.dart';
import '../../create_event/cubit/create_event_state.dart';
import '../../create_event/view/widgets/event_types.dart';
import '../services/firebase_methods.dart';
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

      final CollectionReference eventsCollection =
          FirebaseFirestore.instance.collection('events');
      final DocumentReference eventDocRef = eventsCollection.doc();

      final String eventId = eventDocRef.id;

      final Event event = Event(
        eventId: eventId,
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

      await saveEventDocument(eventDocRef, event);
      await uploadEventImage(eventDocRef, selectedImageBytes);
      await updateClubWithEvent(clubId, eventDocRef.id);
      await updatePlayerWithEvent(eventDocRef.id);

      emit(CreateEventSuccessState());

      scheduleEventDeletion(eventDocRef.id, selectedEndDateTime);

      GoRouter.of(context).push('/home');
    } catch (error) {
      emit(CreateEventErrorState(error: error.toString()));
    }
  }
}
