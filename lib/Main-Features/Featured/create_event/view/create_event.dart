import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/create_event/view/widgets/player_level.dart';
import 'package:tennis_app/core/utils/widgets/rules_text_field.dart';
import 'package:tennis_app/Main-Features/Featured/create_event/view/widgets/event_types.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../core/utils/widgets/input_date.dart';
import '../../../../core/utils/widgets/input_date_and_time.dart';
import '../../../../core/utils/widgets/text_field.dart';
import '../../create_profile/widgets/profile_image.dart';

class CreateEvent extends StatelessWidget {
  CreateEvent({Key? key}) : super(key: key);

  // Declare controllers for input fields
  final TextEditingController eventNameController = TextEditingController();
  final TextEditingController eventAddressController = TextEditingController();
  final TextEditingController courtNameController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  Uint8List? _selectedImageBytes;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF8F8F8),
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
              InputTextWithHint(
                hint: 'Type event name here',
                text: 'Event Name',
                controller: eventNameController,
              ),
              SizedBox(height: screenHeight * .03),
              InputDateAndTime(
                hint: 'Type the time here',
                text: 'Event Start at',
                onDateTimeSelected: (DateTime dateTime) {},
              ),
              SizedBox(height: screenHeight * .03),
              InputDateAndTime(
                hint: 'Type the time here',
                text: 'Event End at',
                onDateTimeSelected: (DateTime dateTime) {},
              ),
              SizedBox(height: screenHeight * .03),
              InputTextWithHint(
                hint: 'Type Event address here',
                text: 'Event Address',
                controller: eventAddressController,
              ),
              SizedBox(height: screenHeight * .03),
              BlocProvider(
                create: (context) => EventTypeCubit(),
                child: EventTypeInput(),
              ),
              SizedBox(height: screenHeight * .03),
              InputTextWithHint(
                hint: 'Type Court name here',
                text: 'Court Name',
                controller: courtNameController,
              ),
              SizedBox(height: screenHeight * .03),
              RulesInputText(
                header: 'Instructions',
                body: 'Briefly describe your club’s Instructions here...',
                controller: rulesController,
              ),
              SizedBox(height: screenHeight * .03),
              BlocProvider(
                create: (context) => SliderCubit(),
                child: RangeSliderWithTooltip(),
              ),
              SizedBox(height: screenHeight * .015),
              BottomSheetContainer(
                buttonText: 'Create',
                onPressed: () {
                  // Access the input field values using controllers
                  String eventName = eventNameController.text;
                  String eventAddress = eventAddressController.text;
                  String courtName = courtNameController.text;

                  // Use the input values as needed
                  // For example, pass them to a Cubit or process them further
                },
                color: const Color(0xFFF8F8F8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
