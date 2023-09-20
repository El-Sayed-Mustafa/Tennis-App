// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/generated/l10n.dart';

void navigateToCreateEvent(BuildContext context) async {
  final String playerId = FirebaseAuth.instance.currentUser!.uid;
  final DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
      await FirebaseFirestore.instance
          .collection('players')
          .doc(playerId)
          .get();

  if (playerSnapshot.exists) {
    final playerData = playerSnapshot.data()!;
    final String clubIds = (playerData['participatedClubId'] ?? '').trim();

    if (clubIds.isNotEmpty) {
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(S.of(context).NoClubMembership),
            content:
                Text(S.of(context).YouNeedToBeAMemberOfAClubToCreateAnEvent),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(S.of(context).ok),
              ),
            ],
          );
        },
      );
    }
  } else {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).Player_data_not_found),
          content: Text(S.of(context).PlayerNotFoundWithTheGivenID),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).ok),
            ),
          ],
        );
      },
    );
  }
}
