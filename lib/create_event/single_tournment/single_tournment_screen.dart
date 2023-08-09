import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/single_match.dart';
import '../../models/single_tournment.dart';

class TournamentScreen extends StatefulWidget {
  @override
  _TournamentScreenState createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  String tournamentId = ''; // Updated to store the generated tournament ID
  List<SingleMatch> matches = [];
  bool addingMatch = false; // Track whether the user is adding a match

  @override
  void initState() {
    super.initState();
    _createTournament();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tournament Matches'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider.builder(
              itemCount: matches.length,
              itemBuilder: (context, index, realIndex) {
                final match = matches[index];
                return MatchCard(match: match);
              },
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                addingMatch = true; // Show match input form
              });
            },
            child: Text('Add Match'),
          ),
          if (addingMatch) MatchInputForm(onSave: _saveMatch),
        ],
      ),
    );
  }

  Future<void> _createTournament() async {
    final newTournament = SingleTournament(
      name: 'Tournament Name',
      isDoubles: false,
      id: '',
    );

    final tournamentRef = await FirebaseFirestore.instance
        .collection('singleTournaments')
        .add(newTournament.toFirestore());

    setState(() {
      tournamentId = tournamentRef.id;
    });
  }

  void _saveMatch(SingleMatch newMatch) async {
    final tournamentRef = FirebaseFirestore.instance
        .collection('singleTournaments')
        .doc(tournamentId);

    final newMatchRef = tournamentRef.collection('singleMatches').doc();
    await newMatchRef.set(newMatch.toFirestore());

    setState(() {
      matches.add(newMatch);
      addingMatch = false; // Hide match input form
    });
  }
}

class MatchCard extends StatelessWidget {
  final SingleMatch match;

  MatchCard({required this.match});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Customize card layout as needed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Match ${match.matchId}'),
          Text('Court: ${match.courtName}'),
          // Display other match details as needed
        ],
      ),
    );
  }
}

class MatchInputForm extends StatefulWidget {
  final void Function(SingleMatch newMatch) onSave;

  MatchInputForm({required this.onSave});

  @override
  _MatchInputFormState createState() => _MatchInputFormState();
}

class _MatchInputFormState extends State<MatchInputForm> {
  String player1Id = '';
  String player2Id = '';
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  String winner = '';
  String courtName = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Player 1 ID'),
          onChanged: (value) => player1Id = value,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Player 2 ID'),
          onChanged: (value) => player2Id = value,
        ),
        // Add more text fields for other match data
        ElevatedButton(
          onPressed: _saveMatch,
          child: Text('Save Match'),
        ),
      ],
    );
  }

  void _saveMatch() {
    final newMatch = SingleMatch(
      matchId: '', // Auto-generated ID will be assigned by Firestore
      player1Id: player1Id,
      player2Id: player2Id,
      startTime: startTime,
      endTime: endTime,
      winner: winner,
      courtName: courtName,
    );

    widget.onSave(newMatch); // Call the callback to save the match
  }
}
