import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../../models/club.dart';
import '../../../../../../models/player.dart';

class PlayerNamesCubit extends Cubit<List<String>> {
  PlayerNamesCubit() : super([]);

  Future<void> fetchCreatedClubId(String playerId) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('players')
              .doc(playerId)
              .get();
      final createdClubId = snapshot.data()?['createdClubId'] as String?;

      if (createdClubId != null) {
        fetchClubMemberIds(createdClubId);
      } else {
        // If createdClubId is null, it means the playerId doesn't have a created club.
        emit([]);
      }
      print(playerId);
      print(createdClubId);
    } catch (error) {
      emit([]);
      throw Exception('Failed to fetch created club ID: $error');
    }
  }

  Future<void> fetchClubMemberIds(String clubId) async {
    try {
      // Step 1: Fetch the club data from the 'clubs' collection based on the provided clubId
      final DocumentSnapshot<Map<String, dynamic>> clubSnapshot =
          await FirebaseFirestore.instance
              .collection('clubs')
              .doc(clubId)
              .get();

      // Step 2: Get the 'memberIds' list from the club data, or an empty list if it's null
      final clubData = clubSnapshot.data();
      final List<dynamic>? clubMemberIdsRaw = clubData?['memberIds'];
      final List<String> clubMemberIds =
          List<String>.from(clubMemberIdsRaw ?? []);
      print(clubData);
      print(clubMemberIdsRaw);

      fetchPlayerNames(clubMemberIds);
    } catch (error) {
      emit([]);
      throw Exception('Failed to fetch club memberIds: $error');
    }
  }

  Future<void> fetchPlayerNames(List<String> playerIds) async {
    try {
      // Step 1: Fetch the player data from the 'players' collection based on the provided playerIds
      final List<Future<DocumentSnapshot<Map<String, dynamic>>>>
          playerSnapshotsFutures = playerIds
              .map((playerId) => FirebaseFirestore.instance
                  .collection('players')
                  .doc(playerId)
                  .get())
              .toList();
      print(playerSnapshotsFutures);
      // Step 2: Wait for all the playerSnapshots to complete
      final List<DocumentSnapshot<Map<String, dynamic>>> playerSnapshots =
          await Future.wait(playerSnapshotsFutures);

      // Step 3: Extract the names from each playerSnapshot and emit the result
      final List<String> playerNames = playerSnapshots
          .map((snapshot) => snapshot.data()?['playerName'] as String?)
          .whereType<String>()
          .toList();
      print(playerNames);

      emit(playerNames); // Emit the player names to the UI
    } catch (error) {
      throw Exception('Failed to fetch player names: $error');
    }
  }
}

class ClubComboBox extends StatefulWidget {
  const ClubComboBox({Key? key, required this.controller});
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
