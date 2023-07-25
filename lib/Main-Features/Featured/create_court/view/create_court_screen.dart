import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
import '../../create_event/cubit/create_event_state.dart';
import '../../create_profile/widgets/profile_image.dart';

// ignore: must_be_immutable
class CreateCourt extends StatelessWidget {
  CreateCourt({Key? key}) : super(key: key);

  // Declare controllers for input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController eventAddressController = TextEditingController();
  final TextEditingController courtNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController clubNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Uint8List? _selectedImageBytes;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return MultiBlocProvider(
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
                        text: '   Create Court',
                        suffixIconPath: '',
                      ),
                      SizedBox(height: screenHeight * .01),
                      ProfileImage(
                        onImageSelected: (File imageFile) {
                          _selectedImageBytes = imageFile.readAsBytesSync();
                        },
                      ),
                      SizedBox(height: screenHeight * .015),
                      const Text(
                        'Set  Court Picture',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputTextWithHint(
                        hint: 'Type Court Name here',
                        text: 'Court Name',
                        controller: nameController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputTextWithHint(
                        hint: 'Type your phone number here',
                        text: 'Your Phone',
                        controller: phoneController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputDateAndTime(
                        text: 'Start Date and Time',
                        hint: 'Select start date and time',
                        onDateTimeSelected: (DateTime dateTime) {},
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputEndDateAndTime(
                        text: 'End Date and time',
                        hint: 'Select end date and time',
                        onDateTimeSelected: (DateTime dateTime) {},
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputTextWithHint(
                        hint: 'Type Club Address here',
                        text: 'Club Address',
                        controller: addressController,
                      ),
                      SizedBox(height: screenHeight * .025),
                      BottomSheetContainer(
                        buttonText: 'Create',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<CreateEventCubit>().saveEventData(
                                  context: context,
                                  selectedImageBytes: _selectedImageBytes,
                                  addressController: eventAddressController,
                                  courtNameController: courtNameController,
                                  eventNameController: nameController,
                                  instructionsController: phoneController,
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
            );
          },
        ),
      ),
    );
  }
}
