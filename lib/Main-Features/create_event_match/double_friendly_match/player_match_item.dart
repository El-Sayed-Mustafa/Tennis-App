import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_app/Main-Features/club/widgets/available_courts_widget.dart';
import 'package:tennis_app/core/utils/snackbar.dart';
import 'package:tennis_app/core/utils/widgets/custom_button.dart';
import 'package:tennis_app/Main-Features/create_event_match/widgets/player_info_widget.dart';
import '../../Featured/Event/create_event/view/widgets/input_end_date.dart';
import '../../../core/utils/widgets/input_date_and_time.dart';
import '../../../generated/l10n.dart';
import '../../../models/player.dart';
import 'cubit/double_match_cubit.dart';
import 'cubit/double_match_state.dart';

class PlayerMatchItem extends StatefulWidget {
  const PlayerMatchItem({super.key});

  @override
  State<PlayerMatchItem> createState() => _PlayerMatchItemState();
}

class _PlayerMatchItemState extends State<PlayerMatchItem> {
  Player? _selectedPlayer;
  Player? _selectedPlayer2;
  Player? _selectedPlayer3;
  Player? _selectedPlayer4;
  int? _radioValue = 0;

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

  @override
  void initState() {
    super.initState();
    courtNameController.text = 'Your Court';
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

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();

    return BlocProvider(
      create: (context) => DoubleMatchCubit(context),
      child: BlocBuilder<DoubleMatchCubit, DoubleMatchState>(
        builder: (context, state) {
          if (state is DoubleMatchInProgress) {
            return const Dialog.fullscreen(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is DoubleMatchFailure) {
            return Scaffold(
              body: Center(
                child: Text(state.error),
              ),
            );
          }
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () async {
              setState(() {});
            },
            child: SingleChildScrollView(
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
                      buttonText: S.of(context).create,
                      onPressed: () {
                        if (_selectedPlayer == null ||
                            _selectedPlayer2 == null ||
                            _selectedPlayer3 == null ||
                            _selectedPlayer4 == null ||
                            courtNameController.text.isEmpty) {
                          // Display a message or alert to inform the user that both players need to be selected
                          return showSnackBar(context,
                              'You Must Choose Two Players and court ');
                        }
                        if (formKey.currentState!.validate()) {
                          context.read<DoubleMatchCubit>().saveDoubleMatch(
                              courtNameController: courtNameController,
                              selectedPlayer: _selectedPlayer!,
                              selectedPlayer2: _selectedPlayer2!,
                              selectedPlayer3: _selectedPlayer3!,
                              selectedPlayer4: _selectedPlayer4!);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
