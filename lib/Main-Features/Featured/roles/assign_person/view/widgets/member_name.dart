import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../cubit/member_names_cubit.dart';

class ClubComboBox extends StatefulWidget {
  const ClubComboBox({super.key, required this.controller});
  final TextEditingController controller;

  @override
  _ClubComboBoxState createState() => _ClubComboBoxState();
}

class _ClubComboBoxState extends State<ClubComboBox> {
  final String playerId = FirebaseAuth.instance.currentUser!.uid;
  late final PlayerNamesCubit clubNamesCubit;

  @override
  void initState() {
    super.initState();
    clubNamesCubit = PlayerNamesCubit();
    clubNamesCubit.fetchCreatedClubId(playerId);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * .83,
      child: BlocBuilder<PlayerNamesCubit, List<String>>(
        bloc: clubNamesCubit,
        builder: (context, playerNames) {
          if (playerNames.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildTypeAhead(playerNames);
          }
        },
      ),
    );
  }

  Widget _buildTypeAhead(List<String> playerNames) {
    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          hintText: 'Select Person',
          hintStyle: const TextStyle(
            color: Color(0xFFA8A8A8),
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // Add prefix icon with a search icon
          prefixIcon: Icon(Icons.search),
          // You can adjust the padding between the icon and the text if needed
          prefixIconConstraints: BoxConstraints(minWidth: 40, minHeight: 40),
        ),
      ),
      suggestionsCallback: (pattern) {
        // Filter player names based on user input pattern
        return playerNames
            .where((name) => name.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (String suggestion) async {
        // Handle the selected suggestion
        setState(() {
          widget.controller.text = suggestion;
        });
      },
    );
  }

  @override
  void dispose() {
    clubNamesCubit.close();
    super.dispose();
  }
}
