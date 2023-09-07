import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/core/utils/widgets/court_item.dart';
import 'package:tennis_app/core/utils/widgets/user_court_item.dart';
import 'package:tennis_app/generated/l10n.dart';
import 'package:tennis_app/models/court.dart';

class ChosenCourt extends StatelessWidget {
  final String courtId;
  final bool isUser;
  final bool isSaveUser;
  final TextEditingController? courtNameController; // Optional parameter

  const ChosenCourt(
      {Key? key,
      required this.courtId,
      required this.isUser,
      this.courtNameController,
      required this.isSaveUser})
      : super(key: key);

  Future<Court> fetchCourt() async {
    try {
      // Fetch court using courtId
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('courts')
              .doc(courtId)
              .get();

      // Parse the data and return a Court object
      return Court.fromSnapshot(querySnapshot);
    } catch (error) {
      // Handle the error if needed
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Court>(
        future: fetchCourt(),
        builder: (context, courtSnapshot) {
          if (courtSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (courtSnapshot.hasError) {
            return Text(S.of(context).error);
          } else if (!courtSnapshot.hasData) {
            return Text(
              S.of(context).No_Reversed_Courts,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            );
          } else {
            final courtData = courtSnapshot.data!;

            return isUser
                ? UserCourtItem(court: courtData)
                : CourtItem(
                    court: courtData,
                    courtNameController: courtNameController,
                    isSaveUser: isSaveUser,
                  );
          }
        },
      ),
    );
  }
}
