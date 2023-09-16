// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/no_data_text.dart';
import 'package:tennis_app/generated/l10n.dart';
import 'package:tennis_app/models/club.dart';
import '../../../../core/utils/widgets/court_item.dart';
import '../../../../models/court.dart';

class AvailableCourts extends StatefulWidget {
  final Club clubData;
  final TextEditingController? courtNameController; // Optional parameter
  final bool isSaveUser;
  const AvailableCourts(
      {super.key,
      required this.clubData,
      this.courtNameController,
      required this.isSaveUser});

  @override
  _AvailableCourtsState createState() => _AvailableCourtsState();
}

class _AvailableCourtsState extends State<AvailableCourts> {
  TextEditingController searchController = TextEditingController();
  List<Court> allCourts = [];
  List<Court> filteredCourts = [];

  @override
  void initState() {
    super.initState();
    fetchCourts();
  }

  void fetchCourts() async {
    try {
      List<String> courtIds =
          widget.clubData.courtIds; // Fetch courtIds from clubData

      // Fetch courts using courtIds
      if (courtIds.isNotEmpty) {
        QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await FirebaseFirestore.instance
                .collection('courts')
                .where('courtId', whereIn: courtIds)
                .get();

        List<Court> courts = querySnapshot.docs
            .map((doc) => Court.fromSnapshot(doc))
            .where((court) => court.availableTimeSlots
                .isNotEmpty) // Filter courts with available time slots
            .toList();

        setState(() {
          allCourts = courts;
          filteredCourts = List.from(
              allCourts); // Copy allCourts to filteredCourts initially
        });
      }
    } catch (error) {
      // Handle the error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final screenHeight = MediaQuery.of(context).size.height;
    return filteredCourts.isNotEmpty
        ? SizedBox(
            height: screenHeight * .24, // Set a fixed height for the container
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: filteredCourts.length,
              itemBuilder: (context, index) {
                Court court = filteredCourts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CourtItem(
                    court: court,
                    courtNameController: widget.courtNameController,
                    isSaveUser: widget.isSaveUser,
                  ),
                );
              },
            ),
          )
        : NoData(
            text: S.of(context).noCourtsAvailable,
            buttonText: S.of(context).Create_Court,
            onPressed: () {
              GoRouter.of(context).push('/createCourt');
            },
            height: screenHeight * .2,
            width: screenWidth * .8,
          );
  }
}
