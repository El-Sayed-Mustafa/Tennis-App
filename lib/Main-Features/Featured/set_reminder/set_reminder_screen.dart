import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../core/utils/widgets/app_bar_wave.dart';
import '../../../core/utils/widgets/input_date_and_time.dart';
import '../../../core/utils/widgets/text_field.dart';
import '../../../models/event.dart';
import '../../club/widgets/club_event_item.dart';
import '../../club/widgets/header_text.dart';
import '../create_event/view/widgets/event_types.dart';
import '../create_event/view/widgets/input_end_date.dart';

class SetReminder extends StatelessWidget {
  SetReminder({super.key, required this.event});
  final Event event;
  final TextEditingController eventNameController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final double spacing = screenHeight * 0.01;
    return MultiBlocProvider(
        providers: [
          BlocProvider<EventTypeCubit>(
            create: (context) => EventTypeCubit(),
          ),
          BlocProvider<EndDateTimeCubit>(
            create: (context) => EndDateTimeCubit(),
          ),
        ],
        child: Scaffold(
          body: Column(
            children: [
              AppBarWaveHome(
                prefixIcon: IconButton(
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                text: '   Set Reminder',
                suffixIconPath: '',
              ),
              ClubEventItem(
                event: event,
                showSetReminder: false,
              ),
              SizedBox(
                height: spacing * 3,
              ),
              Padding(
                padding: EdgeInsets.only(left: screenWidth * .13, bottom: 4),
                child: const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'Set Reminder',
                    style: TextStyle(
                      color: Color(0xB2313131),
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                width: screenWidth * .8,
                padding: EdgeInsets.all(20),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.50, color: Color(0x440D5FC3)),
                    borderRadius: BorderRadius.circular(31),
                  ),
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight * .01),
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
                      SizedBox(height: screenHeight * .03),
                      InputEndDateAndTime(
                        text: 'Event End',
                        hint: 'Select end date and time',
                        onDateTimeSelected: (DateTime dateTime) {},
                      ),
                      SizedBox(height: screenHeight * .01),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              BottomSheetContainer(
                  buttonText: 'Set Reminder',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {}
                  },
                  color: Colors.transparent)
            ],
          ),
        ));
  }
}
