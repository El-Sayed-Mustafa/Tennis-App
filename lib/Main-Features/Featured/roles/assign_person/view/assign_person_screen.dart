import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/roles/assign_person/view/widgets/member_name.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';

class AssignPerson extends StatelessWidget {
  AssignPerson({super.key});
  final TextEditingController memberNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF8F8F8),
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
              text: '   Assign Person',
              suffixIconPath: '',
            ),
            const Text(
              'Select Person',
              style: TextStyle(
                color: Color(0xFF616161),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            ClubComboBox(
              controller: memberNameController,
            ),
          ],
        ),
      ),
    );
  }
}
