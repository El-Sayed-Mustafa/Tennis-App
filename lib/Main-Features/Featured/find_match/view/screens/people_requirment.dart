import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/club_managment/view/widgets/member_item.dart';

import '../../../../../core/utils/widgets/app_bar_wave.dart';

class PeopleRequirement extends StatelessWidget {
  const PeopleRequirement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xF8F8F8F8),
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
              text: '    Find Match',
              suffixIconPath: '',
            ),
            Text(
              'Your Requirements',
              style: TextStyle(
                color: Color(0xFF313131),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            //TODO: add member
            // MemberItem(member: member),
            Text(
              'People’ Requirements',
              style: TextStyle(
                color: Color(0xFF313131),
                fontSize: 20,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
