import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/create_event/widgets/player_info_widget.dart';
import '../../Main-Features/Featured/create_event/view/widgets/input_end_date.dart';
import '../../core/utils/widgets/input_date_and_time.dart';
import '../../core/utils/widgets/pop_app_bar.dart';
import '../../core/utils/widgets/text_field.dart';
import '../../generated/l10n.dart';
import '../../models/player.dart';
import '../../models/single_match.dart';

class PlayerMatchItem extends StatefulWidget {
  const PlayerMatchItem({super.key});

  @override
  State<PlayerMatchItem> createState() => _PlayerMatchItemState();
}

class _PlayerMatchItemState extends State<PlayerMatchItem> {
  Player? _selectedPlayer;
  Player? _selectedPlayer2;
  final TextEditingController courtNameController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  void _onPlayerSelected(Player player) {
    setState(() {
      _selectedPlayer = player;
    });
  }

  void _onPlayerSelected2(Player player) {
    setState(() {
      _selectedPlayer2 = player;
    });
  }

  void _saveSingleMatchToFirestore() async {
    // Check if all required data is available
    if (_selectedPlayer == null || _selectedPlayer2 == null) {
      // Display a message or alert to inform the user that both players need to be selected
      return;
    }
    DateTime? selectedStartDateTime = context.read<DateTimeCubit>().state;
    DateTime? selectedEndDateTime = context.read<EndDateTimeCubit>().state;
    // Get the selected date and time from InputDateAndTime widget and convert it to DateTime object
    DateTime startTime = selectedStartDateTime;

    // Get the selected end date and time from InputEndDateAndTime widget and convert it to DateTime object
    DateTime endTime = selectedEndDateTime;

    // Get the court name from the text controller
    String courtName = courtNameController.text.trim();

    // Create a SingleMatch object
    SingleMatch singleMatch = SingleMatch(
      matchId:
          '', // You can generate a unique match ID or leave it empty for Firestore to generate one
      player1Id: _selectedPlayer!.playerId,
      player2Id: _selectedPlayer2!.playerId,
      startTime: startTime,
      endTime: endTime,
      winner: '',
      courtName:
          '', // You can leave this empty initially or set it when the match is completed
    );

    // Save the SingleMatch object to Firestore
    try {
      await FirebaseFirestore.instance
          .collection('single_matches')
          .add(singleMatch.toFirestore());

      // Display a success message or navigate to a new screen after saving successfully
    } catch (e) {
      // Handle any errors that occur during the save process
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        PoPAppBarWave(
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
          text: 'Single Match',
          suffixIconPath: '',
        ),
        SizedBox(height: screenHeight * .02),
        const Text(
          'Click to choose a player',
          style: TextStyle(
            color: Color(0xFF313131),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              PlayerInfoWidget(
                selectedPlayer: _selectedPlayer,
                onPlayerSelected: _onPlayerSelected,
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: Image.asset('assets/images/versus.png'),
              ),
              PlayerInfoWidget(
                selectedPlayer: _selectedPlayer2,
                onPlayerSelected: _onPlayerSelected2,
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * .02),
        const Text(
          'Schedule',
          style: TextStyle(
            color: Color(0xFF313131),
            fontSize: 20,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: screenHeight * .02),
        InputDateAndTime(
          text: S.of(context).Event_Start,
          hint: S.of(context).Select_start_date_and_time,
          onDateTimeSelected: (DateTime dateTime) {},
        ),
        SizedBox(height: screenHeight * .03),
        InputEndDateAndTime(
          text: S.of(context).Event_End,
          hint: S.of(context).Select_end_date_and_time,
          onDateTimeSelected: (DateTime dateTime) {},
        ),
        SizedBox(height: screenHeight * .03),
        InputTextWithHint(
          hint: S.of(context).Type_Court_Address_here,
          text: S.of(context).Court_Name,
          controller: courtNameController,
        ),
        SizedBox(height: screenHeight * .015),
        Spacer(),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomSheetContainer(
            buttonText: 'Create',
            onPressed: () {
              _saveSingleMatchToFirestore();
            },
          ),
        )
      ],
    );
  }
}
