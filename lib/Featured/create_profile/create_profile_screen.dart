import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_app/Featured/create_profile/widgets/app_bar_wave.dart';
import 'package:tennis_app/Featured/create_profile/widgets/gender_selection.dart';
import 'package:tennis_app/Featured/create_profile/widgets/input_date.dart';
import 'package:tennis_app/Featured/create_profile/widgets/input_time.dart';
import 'package:tennis_app/Featured/create_profile/widgets/profile_image.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../core/utils/widgets/text_field.dart';
import 'cubit/Gender_Cubit.dart';
import 'cubit/time_cubit.dart';
import 'widgets/player_type.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFF8F8F8),
          child: Column(
            children: [
              const AppBarWave(),
              const ProfileImage(),
              SizedBox(height: screenHeight * .01),
              const Text(
                'Set Profile Picture',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: screenHeight * .03),
              BlocProvider(
                create: (context) => GenderCubit(),
                child: const GenderSelection(),
              ),
              SizedBox(height: screenHeight * .03),
              const InputTextWithHint(
                hint: 'Type your name here',
                text: 'Player Name',
              ),
              SizedBox(height: screenHeight * .025),
              const InputTextWithHint(
                hint: 'Type your phone number here',
                text: 'Phone Number',
              ),
              SizedBox(height: screenHeight * .025),
              const InputDateField(
                hint: 'Type your age here',
                text: 'Age',
              ),
              SizedBox(height: screenHeight * .025),
              BlocProvider(
                create: (context) => TimeCubit(),
                child: const InputTimeField(
                  hint: 'Type your Preferred Playing time here',
                  text: 'Preferred Playing time  ',
                ),
              ),
              SizedBox(height: screenHeight * .025),
              const PlayerType(),
              SizedBox(height: screenHeight * .01),
              BottomSheetContainer(
                buttonText: "Create",
                onPressed: () {},
                color: const Color(0xFFF8F8F8),
              )
            ],
          ),
        ),
      ),
    );
  }
}
