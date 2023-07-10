import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../create_profile/widgets/profile_image.dart';

class CreateClub extends StatelessWidget {
  const CreateClub({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          const ProfileImage(),
        ],
      ),
    );
  }
}
