import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/roles/roles_list/view/widgets/list_roles.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';

class RolesScreen extends StatelessWidget {
  const RolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
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
          ListRoles()
        ]),
      ),
    );
  }
}
