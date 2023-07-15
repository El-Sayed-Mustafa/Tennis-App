import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tennis_app/Main-Features/Featured/create_event/cubit/create_event_cubit.dart';
import 'package:tennis_app/Main-Features/Featured/create_event/view/widgets/club_names.dart';
import 'package:tennis_app/Main-Features/Featured/create_event/view/widgets/input_end_date.dart';
import 'package:tennis_app/Main-Features/Featured/create_event/view/widgets/player_level.dart';
import 'package:tennis_app/core/utils/widgets/rules_text_field.dart';
import 'package:tennis_app/Main-Features/Featured/create_event/view/widgets/event_types.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../core/utils/widgets/input_date_and_time.dart';
import '../../../../core/utils/widgets/text_field.dart';
import '../../create_profile/widgets/profile_image.dart';
import '../cubit/create_event_state.dart';

// ignore: must_be_immutable
class CreateEvent extends StatelessWidget {
  CreateEvent({Key? key}) : super(key: key);

  // Declare controllers for input fields
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventAddressController = TextEditingController();
  final TextEditingController courtNameController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  final TextEditingController clubNameController = TextEditingController();

  Uint8List? _selectedImageBytes;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return MultiProvider(
      providers: [
        BlocProvider<EventTypeCubit>(
          create: (context) => EventTypeCubit(),
        ),
        BlocProvider<EndDateTimeCubit>(
          create: (context) => EndDateTimeCubit(),
        ),
        BlocProvider(
          create: (context) => SliderCubit(),
        ),
        BlocProvider(
          create: (context) => ClubNamesCubit(),
        )
      ],
      child: BlocProvider(
        create: (context) => CreateEventCubit(context),
        child: BlocBuilder<CreateEventCubit, CreateEventState>(
          builder: (context, state) {
            if (state is CreateEventLoadingState) {
              return const Dialog.fullscreen(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is CreateEventErrorState) {
              return Scaffold(
                body: Center(
                  child: Text(state.error),
                ),
              );
            }

            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  color: const Color(0xFFF8F8F8),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        AppBarWaveHome(
                          prefixIcon: IconButton(
                            onPressed: () {
                              GoRouter.of(context).replace('/home');
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          text: 'Create Event',
                          suffixIconPath: '',
                        ),
                        ProfileImage(
                          onImageSelected: (File imageFile) {
                            _selectedImageBytes = imageFile.readAsBytesSync();
                          },
                        ),
                        SizedBox(height: screenHeight * .01),
                        const Text(
                          'Set Event Picture',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenHeight * .03),
                        ClubComboBox(
                          controller: clubNameController,
                        ),
                        SizedBox(height: screenHeight * .03),
                        InputTextWithHint(
                          hint: 'Type event name here',
                          text: 'Event Name',
                          controller: eventNameController,
                        ),
                        SizedBox(height: screenHeight * .03),
                        InputDateAndTime(
                          text: 'Event Start',
                          hint: 'Select start date and time',
                          onDateTimeSelected: (DateTime dateTime) {},
                        ),
                        InputEndDateAndTime(
                          text: 'Event End',
                          hint: 'Select end date and time',
                          onDateTimeSelected: (DateTime dateTime) {},
                        ),
                        SizedBox(height: screenHeight * .03),
                        InputTextWithHint(
                          hint: 'Type Event address here',
                          text: 'Event Address',
                          controller: eventAddressController,
                        ),
                        SizedBox(height: screenHeight * .03),
                        EventTypeInput(),
                        SizedBox(height: screenHeight * .03),
                        InputTextWithHint(
                          hint: 'Type Court name here',
                          text: 'Court Name',
                          controller: courtNameController,
                        ),
                        SizedBox(height: screenHeight * .03),
                        RulesInputText(
                          header: 'Instructions',
                          body:
                              'Briefly describe your club’s Instructions here...',
                          controller: rulesController,
                        ),
                        SizedBox(height: screenHeight * .03),
                        const RangeSliderWithTooltip(),
                        SizedBox(height: screenHeight * .015),
                        BottomSheetContainer(
                          buttonText: 'Create',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<CreateEventCubit>().saveEventData(
                                    context: context,
                                    selectedImageBytes: _selectedImageBytes,
                                    addressController: eventAddressController,
                                    courtNameController: courtNameController,
                                    eventNameController: eventNameController,
                                    instructionsController: rulesController,
                                    clubNameController: clubNameController,
                                  );
                            }
                          },
                          color: const Color(0xFFF8F8F8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
