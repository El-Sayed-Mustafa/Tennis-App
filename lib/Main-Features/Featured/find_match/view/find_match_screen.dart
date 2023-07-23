import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/app_bar_wave.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../core/utils/widgets/input_date.dart';
import '../../../../core/utils/widgets/text_field.dart';
import '../../../../generated/l10n.dart';
import '../../create_event/view/widgets/club_names.dart';
import '../../create_profile/widgets/input_time.dart';
import '../../create_profile/widgets/player_type.dart';

class FindMatch extends StatelessWidget {
  FindMatch({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController clubNameController = TextEditingController();
  TimeOfDay? _selectedTime;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: SingleChildScrollView(
          child: Column(
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
                text: '    Find Match',
                suffixIconPath: '',
              ),
              const Text(
                'Set Requirements',
                style: TextStyle(
                  color: Color(0xFF313131),
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    shadows: [
                      BoxShadow(
                        color: Color(0x440D5FC3),
                        blurRadius: 5,
                        offset: Offset(0, 1),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * .025),
                        SizedBox(
                          height: screenHeight * 0.13,
                          child: Image.asset('assets/images/profileimage.png',
                              fit: BoxFit.cover),
                        ),
                        SizedBox(height: screenHeight * .025),
                        InputTextWithHint(
                          hint: S.of(context).typeYourName,
                          text: S.of(context).playerName,
                          controller: nameController,
                        ),
                        SizedBox(height: screenHeight * .025),
                        InputTextWithHint(
                          hint: 'Type Club Address here',
                          text: 'Club Address',
                          controller: addressController,
                        ),
                        SizedBox(height: screenHeight * .025),
                        InputDate(
                          hint: 'Select Date of Birth',
                          text: 'Your Age',
                          onDateTimeSelected: (DateTime dateTime) {
                            // Handle date selection
                          },
                        ),
                        SizedBox(height: screenHeight * .025),
                        InputTimeField(
                          hint: S.of(context).typeYourPreferredPlayingTime,
                          text: S.of(context).preferredPlayingTime,
                          onTimeSelected: (TimeOfDay? time) {
                            _selectedTime = time;
                          },
                        ),
                        SizedBox(height: screenHeight * .025),
                        const PlayerType(),
                        SizedBox(height: screenHeight * .015),
                        SizedBox(height: screenHeight * .03),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ClubComboBox(
                            controller: clubNameController,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BottomSheetContainer(
                              buttonText: 'Find',
                              onPressed: () {
                                if (formKey.currentState!.validate()) {}
                              },
                              color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
