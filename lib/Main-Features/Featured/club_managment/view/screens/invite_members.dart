import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/widgets/app_bar_wave.dart';
import '../../../../../models/club.dart';
import '../widgets/item_invite.dart';

class InviteMember extends StatelessWidget {
  const InviteMember({super.key, required this.club});
  final Club club;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            text: '   Send Invitations',
            suffixIconPath: '',
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                    padding: EdgeInsets.all(8.0), child: MemberItem());
              },
            ),
          ),
        ],
      ),
    );
  }
}
