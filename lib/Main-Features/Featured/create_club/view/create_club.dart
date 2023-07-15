import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/cubit/create_club_cubit.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/cubit/create_club_state.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/view/widgets/Age_restriction.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/view/widgets/club_type.dart';
import 'package:tennis_app/core/utils/widgets/rules_text_field.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../core/utils/widgets/text_field.dart';
import '../../../../generated/l10n.dart';
import '../../create_profile/widgets/profile_image.dart';

class CreateClub extends StatelessWidget {
  CreateClub({Key? key}) : super(key: key);
  Uint8List? _selectedImageBytes;
  final TextEditingController clubNameController = TextEditingController();
  final TextEditingController adminNameController = TextEditingController();
  final TextEditingController nationalIDController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => CreateClubCubit(context),
      child: BlocBuilder<CreateClubCubit, CreateClubState>(
        builder: (context, state) {
          if (state is CreateClubLoadingState) {
            return const Dialog.fullscreen(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is CreateClubErrorState) {
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
                        text: 'Create Club',
                        suffixIconPath: '',
                      ),
                      ProfileImage(
                        onImageSelected: (File imageFile) {
                          _selectedImageBytes = imageFile.readAsBytesSync();
                        },
                      ),
                      SizedBox(height: screenHeight * .01),
                      const Text(
                        'Set Club Picture',
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
                        text: 'Club Name',
                        controller: clubNameController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputTextWithHint(
                        hint: 'Type your name here',
                        text: 'Club admin',
                        controller: adminNameController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputTextWithHint(
                        hint: 'Type id here',
                        text: 'National Id number',
                        controller: nationalIDController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputTextWithHint(
                        hint: 'Type your Phone number here',
                        text: 'Phone number',
                        controller: phoneController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputTextWithHint(
                        hint: 'Type Your Email here',
                        text: 'Your Email',
                        controller: emailController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      ClubTypeInput(),
                      SizedBox(height: screenHeight * .03),
                      RulesInputText(
                        header: 'Rules and regulatoins',
                        body:
                            'Briefly describe your club’s rule and regulations',
                        controller: rulesController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      AgeRestrictionWidget(),
                      SizedBox(height: screenHeight * .015),
                      BottomSheetContainer(
                          buttonText: 'Create',
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<CreateClubCubit>().saveClubData(
                                    selectedImageBytes: _selectedImageBytes,
                                    adminNameController: adminNameController,
                                    clubNameController: clubNameController,
                                    emailController: emailController,
                                    nationalIDController: nationalIDController,
                                    phoneController: phoneController,
                                    rulesController: rulesController,
                                  );
                            }
                          },
                          color: const Color(0xFFF8F8F8))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
