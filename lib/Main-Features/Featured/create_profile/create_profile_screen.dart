import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/app_bar_wave.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/gender_selection.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/input_date.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/input_time.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/profile_image.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../core/utils/widgets/input_date.dart';
import '../../../core/utils/widgets/text_field.dart';
import '../../../generated/l10n.dart';
import 'cubit/Gender_Cubit.dart';
import 'cubit/player_type_cubit.dart';
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
              Text(
                S.of(context).setProfilePicture,
                style: const TextStyle(
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
              InputTextWithHint(
                hint: S.of(context).typeYourName,
                text: S.of(context).playerName,
              ),
              SizedBox(height: screenHeight * .025),
              InputTextWithHint(
                hint: S.of(context).typeYourPhoneNumber,
                text: S.of(context).phoneNumber,
              ),
              SizedBox(height: screenHeight * .025),
              BlocProvider(
                create: (context) => DateCubit(),
                child: const InputDate(
                    hint: 'Select Date of Birth',
                    format: 'dd/MM/yyyy',
                    text: 'Your Age'),
              ),
              SizedBox(height: screenHeight * .025),
              BlocProvider(
                create: (context) => TimeCubit(),
                child: InputTimeField(
                  hint: S.of(context).typeYourPreferredPlayingTime,
                  text: S.of(context).preferredPlayingTime,
                ),
              ),
              SizedBox(height: screenHeight * .025),
              BlocProvider(
                create: (context) => PlayerTypeCubit(),
                child: const PlayerType(),
              ),
              SizedBox(height: screenHeight * .01),
              BottomSheetContainer(
                buttonText: S.of(context).create,
                onPressed: () {
                  GoRouter.of(context).push('/chooseClub');
                },
                color: const Color(0xFFF8F8F8),
              )
            ],
          ),
        ),
      ),
    );
  }
}
