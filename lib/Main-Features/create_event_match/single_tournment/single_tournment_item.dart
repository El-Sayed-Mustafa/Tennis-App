import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/club/widgets/available_courts_widget.dart';

import '../../Featured/Event/create_event/view/widgets/input_end_date.dart';
import '../../../core/utils/snackbar.dart';
import '../../../core/utils/widgets/input_date_and_time.dart';
import '../../../generated/l10n.dart';
import '../../../models/player.dart';
import '../../../models/single_match.dart';
import '../widgets/button_tournament.dart';
import '../widgets/player_info_widget.dart';

class MatchInputForm extends StatefulWidget {
  final void Function(SingleMatch newMatch) onSave;

  const MatchInputForm({super.key, required this.onSave});

  @override
  _MatchInputFormState createState() => _MatchInputFormState();
}

class _MatchInputFormState extends State<MatchInputForm> {
  String winner = '';
  var formKey = GlobalKey<FormState>();
  Player? _selectedPlayer;
  Player? _selectedPlayer2;
  final TextEditingController courtNameController = TextEditingController();
  bool isSaving = false; // Track the saving state

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

  @override
  void initState() {
    super.initState();
    courtNameController.text = 'Your Court';
  }

  int? _radioValue = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Radio<int>(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: (int? value) {
                            setState(() {
                              _radioValue = value;
                            });
                          },
                        ),
                        const Text(
                          'Your Court',
                          style: TextStyle(
                            color: Color(0xFF525252),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Radio<int>(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: (int? value) {
                            setState(() {
                              _radioValue = value;
                            });
                          },
                        ),
                        Text(
                          S.of(context).reverseCourt,
                          style: const TextStyle(
                            color: Color(0xFF525252),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_radioValue == 1)
                AvailableCourtsWidget(
                  courtNameController: courtNameController,
                  isSaveUser: false,
                )
              else
                const SizedBox.shrink(),
              SizedBox(height: screenHeight * .015),
              ButtonTournament(
                finish: () {
                  GoRouter.of(context).go('/home');
                },
                addMatch: () {
                  if (_selectedPlayer == null ||
                      _selectedPlayer2 == null ||
                      courtNameController.text.isEmpty) {
                    // Display a message or alert to inform the user that both players need to be selected
                    return showSnackBar(
                        context, 'You Must Choose Two Players and court ');
                  }
                  if (formKey.currentState!.validate()) {
                    _saveMatch(
                        courtNameController: courtNameController,
                        selectedPlayer: _selectedPlayer!,
                        selectedPlayer2: _selectedPlayer2!);
                  }
                  _selectedPlayer = null;
                  _selectedPlayer2 = null;
                  courtNameController.text = '';
                },
              ),
            ],
          ),
        ),
        if (isSaving)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }

  void _saveMatch({
    required Player selectedPlayer,
    required Player selectedPlayer2,
    required TextEditingController courtNameController,
  }) async {
    setState(() {
      isSaving = true;
    });

    DateTime? selectedStartDateTime = context.read<DateTimeCubit>().state;
    DateTime? selectedEndDateTime = context.read<EndDateTimeCubit>().state;
    // Get the selected date and time from InputDateAndTime widget and convert it to DateTime object
    DateTime startTime = selectedStartDateTime;

    // Get the selected end date and time from InputEndDateAndTime widget and convert it to DateTime object
    DateTime endTime = selectedEndDateTime;

    final newMatch = SingleMatch(
      // Don't set the match ID here since it will be auto-generated by Firestore
      player1Id: selectedPlayer.playerId,
      player2Id: selectedPlayer2.playerId,
      startTime: startTime,
      endTime: endTime,
      winner: winner,
      courtName: courtNameController.text, matchId: '', result: '',
    );

    // Call the onSave method with the newMatch object
    widget.onSave(newMatch);
    setState(() {
      isSaving = false;
    }); // Call the addMatchIdToPlayer method for both selected players
  }
}
