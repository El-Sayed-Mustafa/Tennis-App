import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/create_court/cubit/create_court_states.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/core/utils/widgets/hours_of_day.dart';
import 'package:tennis_app/core/utils/widgets/input_date.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import '../../../../core/utils/widgets/text_field.dart';
import '../../../../generated/l10n.dart';
import '../../create_profile/widgets/profile_image.dart';
import '../cubit/create_court_cubit.dart';

// ignore: must_be_immutable
class CreateCourt extends StatelessWidget {
  CreateCourt({Key? key}) : super(key: key);

  // Declare controllers for input fields
  final TextEditingController courtNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Uint8List? _selectedImageBytes;
  var formKey = GlobalKey<FormState>();
  final ValueNotifier<String> from =
      ValueNotifier<String>('00:00'); // Initialize with a default value
  final ValueNotifier<String> to =
      ValueNotifier<String>('00:00'); // Initialize with a default value
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => CreateCourtCubit(context),
      child: BlocBuilder<CreateCourtCubit, CreateCourtState>(
        builder: (context, state) {
          if (state is CreateCourtLoadingState) {
            return const Dialog.fullscreen(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is CreateCourtErrorState) {
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
                      text: S.of(context).Create_Court,
                      suffixIconPath: '',
                    ),
                    SizedBox(height: screenHeight * .01),
                    ProfileImage(
                      onImageSelected: (File imageFile) {
                        _selectedImageBytes = imageFile.readAsBytesSync();
                      },
                    ),
                    SizedBox(height: screenHeight * .015),
                    Text(
                      S.of(context).Set_Court_Picture,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenHeight * .03),
                    InputTextWithHint(
                      hint: S.of(context).Type_Court_Name_here,
                      text: S.of(context).Court_Name,
                      controller: courtNameController,
                    ),
                    SizedBox(height: screenHeight * .03),
                    InputTextWithHint(
                      hint: S.of(context).Type_Court_Address_here,
                      text: S.of(context).Court_Address,
                      controller: addressController,
                      validator: (value) {
                        // You can add additional validation logic here if needed.
                        if (value.isEmpty) {
                          return null; // Allow empty or blank values
                        }

                        return null; // Return null for valid input
                      },
                    ),
                    SizedBox(height: screenHeight * .03),
                    InputDate(
                      hint: S.of(context).selectADay,
                      text: S.of(context).selectADay,
                      onDateTimeSelected: (DateTime dateTime) {
                        // Handle date selection
                      },
                    ),
                    SizedBox(height: screenHeight * .04),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * .06),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          HoursOfDayDropdown(
                              labelText: S.of(context).From_,
                              selectedHourNotifier: from),
                          HoursOfDayDropdown(
                              labelText: S.of(context).To_,
                              selectedHourNotifier: to),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * .03),
                    BottomSheetContainer(
                      buttonText: S.of(context).Create,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Get the selected hours and minutes from the ValueNotifiers
                          final fromHours = int.parse(from.value.split(":")[0]);
                          final fromMinutes =
                              int.parse(from.value.split(":")[1]);
                          final toHours = int.parse(to.value.split(":")[0]);
                          final toMinutes = int.parse(to.value.split(":")[1]);

                          // Compare the "From" and "To" values
                          if (fromHours < toHours ||
                              (fromHours == toHours &&
                                  fromMinutes < toMinutes)) {
                            // "From" is smaller than "To"
                            context.read<CreateCourtCubit>().saveCourtData(
                                selectedImageBytes: _selectedImageBytes,
                                addressController: addressController,
                                courtNameController: courtNameController,
                                phoneController: phoneController,
                                from: from.value,
                                to: to.value);
                          } else {
                            showSnackBar(context,
                                S.of(context).fromTimeMustBeSmallerThanToTime);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
