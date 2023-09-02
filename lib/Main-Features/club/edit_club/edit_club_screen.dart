import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/cubit/create_club_cubit.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/cubit/create_club_state.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/view/widgets/Age_restriction.dart';
import 'package:tennis_app/Main-Features/Featured/create_club/view/widgets/club_type.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/profile_image.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import 'package:tennis_app/core/utils/widgets/rules_text_field.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/models/club.dart';
import '../../../../core/utils/widgets/text_field.dart';
import '../../../../generated/l10n.dart';

// ignore: must_be_immutable
class EditClub extends StatefulWidget {
  EditClub({Key? key, required this.club}) : super(key: key);
  final Club club;

  @override
  State<EditClub> createState() => _EditClubState();
}

class _EditClubState extends State<EditClub> {
  Uint8List? _selectedImageBytes;

  final TextEditingController clubNameController = TextEditingController();

  final TextEditingController adminNameController = TextEditingController();

  final TextEditingController nationalIDController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController rulesController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController courtsNumController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    clubNameController.text = widget.club.clubName;
    phoneController.text = widget.club.phoneNumber;
    addressController.text = widget.club.address;
    rulesController.text = widget.club.rulesAndRegulations;

    if (widget.club.ageRestriction == 'Everyone') {
      final cubit = context.read<AgeRestrictionCubit>();
      cubit.setSelectedValue(3);
    } else if (widget.club.ageRestriction == 'Above 18') {
      final cubit = context.read<AgeRestrictionCubit>();
      cubit.setSelectedValue(2);
    } else {
      final cubit = context.read<AgeRestrictionCubit>();
      cubit.setSelectedValue(1);
    }
    super.initState();
  }

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
                      PoPAppBarWave(
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
                        text: S.of(context).Create_Club,
                        suffixIconPath: '',
                      ),
                      ProfileImage(
                        onImageSelected: (File imageFile) {
                          _selectedImageBytes = imageFile.readAsBytesSync();
                        },
                        photoURL: widget.club.photoURL,
                      ),
                      SizedBox(height: screenHeight * .01),
                      Text(
                        S.of(context).Set_Club_Picture,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputTextWithHint(
                        hint: S.of(context).Type_club_name_here,
                        text: S.of(context).Club_Name,
                        controller: clubNameController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputTextWithHint(
                        hint: S.of(context).Type_your_Phone_number_here,
                        text: S.of(context).Phone_number,
                        controller: phoneController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      InputTextWithHint(
                        hint: S.of(context).Type_Club_Address_here,
                        text: S.of(context).Club_Address,
                        controller: addressController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      const ClubTypeInput(),
                      SizedBox(height: screenHeight * .03),
                      RulesInputText(
                        header: S.of(context).Rules_and_regulations,
                        body: S
                            .of(context)
                            .Briefly_describe_your_clubs_rule_and_regulations,
                        controller: rulesController,
                      ),
                      SizedBox(height: screenHeight * .03),
                      const AgeRestrictionWidget(),
                      SizedBox(height: screenHeight * .015),
                      BottomSheetContainer(
                        buttonText: S.of(context).Create,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<CreateClubCubit>().saveClubData(
                                  club: widget.club,
                                  selectedImageBytes: _selectedImageBytes,
                                  clubNameController: clubNameController,
                                  phoneController: phoneController,
                                  rulesController: rulesController,
                                  addressController: addressController,
                                );
                          }
                        },
                      )
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
