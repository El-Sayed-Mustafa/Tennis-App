import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/create_profile/widgets/app_bar_wave.dart';

import '../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../club/widgets/club_info.dart';
import '../../../club/widgets/num_members.dart';

class ManagementScreen extends StatelessWidget {
  const ManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF8F8F8),
        child: SingleChildScrollView(
          child: Column(
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
                text: '    Management',
                suffixIconPath: '',
              ),
              Container(
                  margin: EdgeInsets.only(
                      right: screenWidth * .05,
                      left: screenWidth * .05,
                      bottom: screenWidth * .05),
                  child: const ClubInfo()),
              const NumMembers(),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * .08, vertical: screenWidth * .04),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Manage Members',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFF0D5FC3),
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
