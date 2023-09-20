import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/Featured/Event/create_event/view/widgets/input_end_date.dart';
import 'package:tennis_app/Main-Features/club/widgets/available_courts_widget.dart';
import 'package:tennis_app/Main-Features/create_event_match/single_tournment/cubit/edit_match_cubit.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/chosen_court.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/Main-Features/create_event_match/single_friendly_match/cubit/single_match_state.dart';
import 'package:tennis_app/Main-Features/create_event_match/widgets/player_info_widget.dart';
import 'package:tennis_app/core/utils/widgets/input_date_and_time.dart';
import 'package:tennis_app/generated/l10n.dart';
import 'package:tennis_app/models/double_match.dart';
import 'package:tennis_app/models/player.dart';

class EditDoubleMatchItem extends StatefulWidget {
  const EditDoubleMatchItem({
    super.key,
    required this.match,
    required this.tournamentId,
  });
  final DoubleMatch match;
  final String tournamentId;
  @override
  State<EditDoubleMatchItem> createState() => _EditDoubleMatchItemState();
}

class _EditDoubleMatchItemState extends State<EditDoubleMatchItem> {
  Player? _selectedPlayer;
  Player? _selectedPlayer2;
  final TextEditingController courtNameController = TextEditingController();
  final TextEditingController rulesController = TextEditingController();
  Player? _selectedPlayer3;
  Player? _selectedPlayer4;
  @override
  void initState() {
    super.initState();
    _loadPlayers();
    courtNameController.text = widget.match.courtName;
    context.read<DateTimeCubit>().selectDateTime(widget.match.startTime);
    context.read<EndDateTimeCubit>().selectDateTime(widget.match.endTime);
  }

  // Function to load player data asynchronously
  Future<void> _loadPlayers() async {
    final method = Method();

    final player1 = await method.getUserById(widget.match.player1Id);
    final player2 = await method.getUserById(widget.match.player2Id);
    final player3 = await method.getUserById(widget.match.player3Id);
    final player4 = await method.getUserById(widget.match.player4Id);

    setState(() {
      _selectedPlayer = player1;
      _selectedPlayer2 = player2;
      _selectedPlayer3 = player3;
      _selectedPlayer4 = player4;
    });
  }

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

  void _onPlayerSelected3(Player player) {
    setState(() {
      _selectedPlayer3 = player;
    });
  }

  void _onPlayerSelected4(Player player) {
    setState(() {
      _selectedPlayer4 = player;
    });
  }

  int? _radioValue = 1;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocProvider(
        create: (context) => EditMatchCubit(context),
        child: BlocBuilder<EditMatchCubit, SaveMatchState>(
          builder: (context, state) {
            if (state is SaveMatchInProgress) {
              return const Dialog.fullscreen(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is SaveMatchFailure) {
              return Scaffold(
                body: Center(
                  child: Text(state.error),
                ),
              );
            }
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Click to choose a player',
                      style: TextStyle(
                        color: Color(0xFF313131),
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            children: [
                              PlayerInfoWidget(
                                selectedPlayer: _selectedPlayer,
                                onPlayerSelected: _onPlayerSelected,
                              ),
                              PlayerInfoWidget(
                                selectedPlayer: _selectedPlayer2,
                                onPlayerSelected: _onPlayerSelected2,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/images/versus.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            children: [
                              PlayerInfoWidget(
                                selectedPlayer: _selectedPlayer3,
                                onPlayerSelected: _onPlayerSelected3,
                              ),
                              PlayerInfoWidget(
                                selectedPlayer: _selectedPlayer4,
                                onPlayerSelected: _onPlayerSelected4,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                    if (widget.match.courtName != 'Your Court')
                      ChosenCourt(
                        courtId: widget.match.courtName,
                        isUser: false,
                        courtNameController: courtNameController,
                        isSaveUser: false,
                      )
                    else
                      const Text("Your Court",
                          style: TextStyle(
                            color: Color(0xFF2A2A2A),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          )),
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
                                    courtNameController.text = 'Your Court';
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
                                S.of(context).ReverseCourt,
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
                    BottomSheetContainer(
                      buttonText: 'Update',
                      onPressed: () {
                        if (_selectedPlayer == null ||
                            _selectedPlayer2 == null ||
                            courtNameController.text.isEmpty) {
                          return showSnackBar(context,
                              'You Must Choose Two Players and court ');
                        }
                        if (formKey.currentState!.validate()) {
                          context.read<EditMatchCubit>().editDoubleMatch(
                              courtNameController: courtNameController,
                              selectedPlayer: _selectedPlayer!,
                              selectedPlayer2: _selectedPlayer2!,
                              tournamentId: widget.tournamentId,
                              match: widget.match,
                              selectedPlayer3: _selectedPlayer3!,
                              selectedPlayer4: _selectedPlayer4!);
                          showSnackBar(context, 'Match Updated Successfully');
                        }
                        GoRouter.of(context).push('/club');
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
