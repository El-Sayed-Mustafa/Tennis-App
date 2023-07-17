import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/roles/create_role/view/widgets/name_role.dart';
import 'package:tennis_app/Main-Features/Featured/roles/create_role/view/widgets/rights_selector.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/core/utils/widgets/text_field.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';

class CreateRole extends StatelessWidget {
  const CreateRole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController roleController = TextEditingController();

    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AppBarWaveHome(
              prefixIcon: IconButton(
                onPressed: () {
                  GoRouter.of(context).replace('/menu');
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
                    const RightSelector(),
                    const Spacer(), // Add Spacer to push the BottomSheetContainer to the bottom
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
                  onPressed: () {},
                  color: const Color(0xFFF8F8F8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: CreateRole()));
}
