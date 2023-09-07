import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/roles/create_role/view/widgets/name_role.dart';
import 'package:tennis_app/Main-Features/Featured/roles/create_role/view/widgets/rights_selector.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/core/utils/widgets/pop_app_bar.dart';
import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../generated/l10n.dart';
import '../cubit/role_cubit.dart';

class CreateRole extends StatefulWidget {
  const CreateRole({Key? key}) : super(key: key);

  @override
  State<CreateRole> createState() => _CreateRoleState();
}

class _CreateRoleState extends State<CreateRole> {
  final TextEditingController roleController = TextEditingController();
  List<String> selectedWords = [];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    List<String> words = [
      "Create Match",
      "Create Event",
      "Edit Club",
      "Delete Club",
      "Edit Member",
      "Create Training",
      "Edit Event",
      "Delete Event",
      "Edit Match",
      "Enter Results",
      "Create Roles",
      "Create Offers",
      "Create Court",
      "Delete Match",
      "Create tennis courts"
    ];
    return BlocProvider(
      create: (context) => RoleCubit(),
      child: BlocConsumer<RoleCubit, RoleCreationStatus>(
        listener: (context, state) {
          if (state == RoleCreationStatus.success) {
            // Role created successfully, show the success dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(S.of(context).roleCreated),
                content: Text(S.of(context).roleHasBeenCreatedSuccessfully),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      // Close the dialog
                      Navigator.of(context).pop();

                      // Navigate to the Roles list page
                      Navigator.of(context).pop();
                    },
                    child: Text(S.of(context).ok),
                  ),
                ],
              ),
            );
          } else if (state == RoleCreationStatus.error) {
            // Show an error toast if role creation fails
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(S.of(context).Error_creating_role),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state == RoleCreationStatus.loading) {
            // Show the circular progress indicator while creating the role
            return Scaffold(
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            // Show the rest of your UI when not loading
            return Scaffold(
              body: SingleChildScrollView(
                child: Container(
                  height: screenHeight,
                  color: const Color(0xFFF8F8F8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                        text: '   Roles',
                        suffixIconPath: '',
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Create Role',
                                style: TextStyle(
                                  color: Color(0xFF616161),
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: screenHeight * .03),
                              CustomTextFormField(controller: roleController),
                              SizedBox(height: screenHeight * .05),
                              const Text(
                                'Describe Rights',
                                style: TextStyle(
                                  color: Color(0xFF616161),
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const Text(
                                'You can add more \nrights to a role',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF989898),
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: screenHeight * .03),
                              RightSelector(
                                selectedWords: selectedWords,
                                onSelectedWordsChanged: (words) {
                                  setState(() {
                                    selectedWords = words;
                                  });
                                },
                                words: words,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          color: const Color(0xFFF8F8F8),
                          child: BottomSheetContainer(
                            buttonText: 'Create Role',
                            onPressed: () {
                              // Call the Cubit method to create the role
                              context.read<RoleCubit>().createRole(
                                    roleController: roleController,
                                    selectedWords: selectedWords,
                                    context: context,
                                  );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
