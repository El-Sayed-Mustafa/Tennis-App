import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/view/widgets/Age_restriction.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/view/widgets/club_type.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/view/widgets/rules_text_field.dart';
import 'package:tennis_app/Main-Features/Featured/create_event/view/widgets/event_types.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../core/utils/widgets/input_date.dart';
import '../../../../core/utils/widgets/text_field.dart';
import '../../../../generated/l10n.dart';
import '../../create_profile/widgets/profile_image.dart';

class CreateEvent extends StatelessWidget {
  const CreateEvent({super.key});

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
              const ProfileImage(),
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
              const InputTextWithHint(
                  hint: 'Type event name here', text: 'Club Name'),
              SizedBox(height: screenHeight * .03),
              BlocProvider(
                create: (context) => DateCubit(),
                child: const InputDate(
                    hint: 'Type the time here', text: 'Event Start at'),
              ),
              SizedBox(height: screenHeight * .03),
              BlocProvider(
                create: (context) => DateCubit(),
                child: const InputDate(
                    hint: 'Type the time here', text: 'Event End at'),
              ),
              SizedBox(height: screenHeight * .03),
              InputTextWithHint(
                hint: 'Type Event address here',
                text: 'Event Address',
                suffixIcon: SvgPicture.asset(
                  'assets/images/location.svg',
                ),
              ),
              SizedBox(height: screenHeight * .015),
              BlocProvider(
                create: (context) => EventTypeCubit(),
                child: EventTypeInput(),
              ),
              SizedBox(height: screenHeight * .015),
              BottomSheetContainer(
                  buttonText: 'Create',
                  onPressed: () {},
                  color: const Color(0xFFF8F8F8))
            ],
          ),
        ),
      ),
    );
  }
}
