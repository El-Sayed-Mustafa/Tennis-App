import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/roles/roles_list/view/widgets/list_roles.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';

class RolesScreen extends StatelessWidget {
  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
        height: screenHeight,
        child: Column(children: [
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
          const Text(
            'Roles list',
            style: TextStyle(
              color: Color(0xFF616161),
              fontSize: 22,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          ListRoles(),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Container(
              width: screenWidth * 0.4,
              height: 50,
              decoration: ShapeDecoration(
                color: const Color(0x30FFA372),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.50, color: Color(0xFF00344E)),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Center(
                child: Text(
                  'Assign Roles to a Person',
                  style: TextStyle(
                    color: Color(0xFF00344E),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          BottomSheetContainer(
              buttonText: 'Create Role',
              onPressed: () {
                GoRouter.of(context).push('/createRole');
              },
              color: const Color(0xFFF8F8F8))
        ]),
      ),
    );
  }
}
