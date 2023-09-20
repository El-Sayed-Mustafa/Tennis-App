import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/Event/create_event/cubit/create_event_cubit.dart';
import 'package:tennis_app/Main-Features/Featured/Event/create_event/cubit/create_event_state.dart';
import 'package:tennis_app/Main-Features/Featured/Event/create_event/view/widgets/convert_string_to_EventType.dart';
import 'package:tennis_app/Main-Features/Featured/Event/create_event/view/widgets/input_end_date.dart';
import 'package:tennis_app/Main-Features/Featured/Event/create_event/view/widgets/invited_members.dart';
import 'package:tennis_app/Main-Features/Featured/Event/create_event/view/widgets/player_level.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/profile_image.dart';
import 'package:tennis_app/Main-Features/club/widgets/available_courts_widget.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/chosen_court.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import 'package:tennis_app/core/utils/widgets/rules_text_field.dart';
import 'package:tennis_app/Main-Features/Featured/Event/create_event/view/widgets/event_types.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/models/event.dart';
import '../../../../../core/utils/widgets/input_date_and_time.dart';
import '../../../../../core/utils/widgets/text_field.dart';
import '../../../../../generated/l10n.dart';

// ignore: must_be_immutable
class EditEvent extends StatefulWidget {
  const EditEvent({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  // Declare controllers for input fields
  final TextEditingController eventNameController = TextEditingController();

  final TextEditingController eventAddressController = TextEditingController();

  final TextEditingController courtNameController = TextEditingController();

  final TextEditingController rulesController = TextEditingController();

  Uint8List? _selectedImageBytes;

  var formKey = GlobalKey<FormState>();
  List<String> playerIds = [];
  int? _radioValue = 0;
  @override
  void initState() {
    eventNameController.text = widget.event.eventName;
    eventAddressController.text = widget.event.eventAddress;
    courtNameController.text = widget.event.courtName;
    rulesController.text = widget.event.instructions;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventTypeCubit>(
          create: (context) => EventTypeCubit(),
        ),
        BlocProvider(
          create: (context) => SliderCubit(),
        ),
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
            EventType savedEventType =
                eventTypeFromString(widget.event.eventType);

            final cubit = context.read<EventTypeCubit>();
            cubit.setClubType(savedEventType);
            context
                .read<DateTimeCubit>()
                .selectDateTime(widget.event.eventStartAt);
            context
                .read<EndDateTimeCubit>()
                .selectDateTime(widget.event.eventEndsAt);
            context
                .read<SliderCubit>()
                .setSliderValue(widget.event.playerLevel);

            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  color: const Color(0xFFF8F8F8),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        PoPAppBarWave(
                          prefixIcon: IconButton(
                            onPressed: () {
                              GoRouter.of(context).push('/club');
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          text: S.of(context).Create_Event,
                          suffixIconPath: '',
                        ),
                        ProfileImage(
                          onImageSelected: (File imageFile) {
                            _selectedImageBytes = imageFile.readAsBytesSync();
                          },
                        ),
                        SizedBox(height: screenHeight * .01),
                        Text(
                          S.of(context).Set_Event_Picture,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenHeight * .03),
                        InputTextWithHint(
                          hint: S.of(context).Type_event_name_here,
                          text: S.of(context).Event_Name,
                          controller: eventNameController,
                        ),
                        SizedBox(height: screenHeight * .03),
                        InputDateAndTime(
                          text: S.of(context).Event_Start,
                          hint: S.of(context).Select_start_date_and_time,
                          onDateTimeSelected: (DateTime dateTime) {},
                        ),
                        SizedBox(height: screenHeight * .03),
                        InputEndDateAndTime(
                          text: S.of(context).Event_End,
                          hint: S.of(context).Select_end_date_and_time,
                          onDateTimeSelected: (DateTime dateTime) {},
                        ),
                        SizedBox(height: screenHeight * .03),
                        InputTextWithHint(
                          hint: S.of(context).Type_Event_address_here,
                          text: S.of(context).Event_Address,
                          controller: eventAddressController,
                        ),
                        SizedBox(height: screenHeight * .03),
                        EventTypeInput(),
                        SizedBox(height: screenHeight * .03),

                        //Create Radio Buttons here have two items Public and custom
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Radio<int>(
                                    value: 0,
                                    groupValue: _radioValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        _radioValue = value;
                                      });
                                    },
                                  ),
                                  Text(
                                    S.of(context).Public,
                                    style: const TextStyle(
                                      color: Color(0xFF525252),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Radio<int>(
                                    value: 1,
                                    groupValue: _radioValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        _radioValue = value;
                                      });
                                    },
                                  ),
                                  Text(
                                    S.of(context).Custom,
                                    style: const TextStyle(
                                      color: Color(0xFF525252),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (_radioValue == 1)
                          MemberInvites(
                            playerIds: playerIds,
                          )
                        else
                          const SizedBox.shrink(),
                        SizedBox(height: screenHeight * .015),
                        RulesInputText(
                          header: S.of(context).Instructions,
                          body: S
                              .of(context)
                              .Briefly_describe_your_clubs_rule_and_regulations,
                          controller: rulesController,
                        ),
                        SizedBox(height: screenHeight * .015),
                        ChosenCourt(
                          courtId: widget.event.courtName,
                          isUser: false,
                          courtNameController: courtNameController,
                          isSaveUser: false,
                        ),
                        AvailableCourtsWidget(
                          courtNameController: courtNameController,
                          isSaveUser: false,
                        ),
                        SizedBox(height: screenHeight * .03),

                        RangeSliderWithTooltip(
                          text1: S
                              .of(context)
                              .Player_level, // Replace with your desired text for text1
                          text2: S
                              .of(context)
                              .You_can_set_a_skill_level_requirement_for_players_allowing_only_those_whose_skill_level_matches_the_requirement_you_have_set_to_participate, // Replace with your desired text for text2
                        ),

                        SizedBox(height: screenHeight * .015),
                        BottomSheetContainer(
                          buttonText: "Update",
                          onPressed: () {
                            if (courtNameController.text.isEmpty) {
                              // Display a message or alert to inform the user that both players need to be selected
                              return showSnackBar(
                                  context, S.of(context).YouMustChoosecourt);
                            }
                            if (formKey.currentState!.validate()) {
                              context.read<CreateEventCubit>().saveEventData(
                                    eventId: widget.event.eventId,
                                    context: context,
                                    selectedImageBytes: _selectedImageBytes,
                                    addressController: eventAddressController,
                                    courtNameController: courtNameController,
                                    eventNameController: eventNameController,
                                    instructionsController: rulesController,
                                    selected: playerIds,
                                  );
                            }
                          },
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
