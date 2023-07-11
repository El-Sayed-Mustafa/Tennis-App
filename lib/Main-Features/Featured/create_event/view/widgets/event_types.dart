import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ClubType {
  Tournament,
  OneDay,
  Challenge,
  Competition,
  FriendlyMatch,
  DailyTraining,
  PartyEvent,
  TrainingPlan,
}

class EventTypeCubit extends Cubit<ClubType> {
  EventTypeCubit() : super(ClubType.Tournament);

  void setClubType(ClubType clubType) {
    emit(clubType);
  }
}

class EventTypeInput extends StatelessWidget {
  EventTypeInput({Key? key}) : super(key: key);

  final Map<ClubType, String> displayTexts = {
    ClubType.Tournament: 'Tournament',
    ClubType.OneDay: 'One Day',
    ClubType.Challenge: 'Challenge',
    ClubType.Competition: 'Competition',
    ClubType.FriendlyMatch: 'Friendly Match',
    ClubType.DailyTraining: 'Daily Training',
    ClubType.PartyEvent: 'Party Event',
    ClubType.TrainingPlan: 'Training Plan',
  };

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 2.0, left: screenWidth * .055),
            child: const Text(
              'Club Type',
              style: TextStyle(
                color: Color(0xFF525252),
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          BlocBuilder<EventTypeCubit, ClubType>(
            builder: (context, state) {
              return Container(
                width: screenWidth * .8,
                height: screenHeight * .05,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0x300A557F)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(
                              width: 25.0), // Adjust the width as needed
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextFormField(
                                readOnly: true,
                                onTap: () {
                                  _showOptionsPopupMenu(context);
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: screenHeight * .015),
                                  border: InputBorder.none,
                                  hintText: displayTexts[state],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showOptionsPopupMenu(context);
                      },
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showOptionsPopupMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    final Map<ClubType, String> displayTexts = {
      ClubType.Tournament: 'Tournament',
      ClubType.OneDay: 'One Day',
      ClubType.Challenge: 'Challenge',
      ClubType.Competition: 'Competition',
      ClubType.FriendlyMatch: 'Friendly Match',
      ClubType.DailyTraining: 'Daily Training',
      ClubType.PartyEvent: 'Party Event',
      ClubType.TrainingPlan: 'Training Plan',
    };

    final List<ClubType> options = [
      ClubType.Tournament,
      ClubType.OneDay,
      ClubType.Challenge,
      ClubType.Competition,
      ClubType.FriendlyMatch,
      ClubType.DailyTraining,
      ClubType.PartyEvent,
      ClubType.TrainingPlan,
    ];

    showMenu<ClubType>(
      context: context,
      position: position,
      items: options.map((ClubType option) {
        return PopupMenuItem<ClubType>(
          value: option,
          child: Text(
            displayTexts[option]!,
            style: const TextStyle(
              color: Color.fromARGB(255, 82, 82, 82),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        final cubit = context.read<EventTypeCubit>();
        cubit.setClubType(value);
      }
    });
  }
}
