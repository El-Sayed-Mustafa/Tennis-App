// import 'package:flutter/material.dart';

// import '../../../models/player.dart';

// class TournamentScreen extends StatefulWidget {
//   final Tournament tournament;
//   final List<Player> players;

//   TournamentScreen({required this.tournament, required this.players});

//   @override
//   _TournamentScreenState createState() => _TournamentScreenState();
// }

// class _TournamentScreenState extends State<TournamentScreen> {
//   List<String?> _selectedPlayers = [];
//   List<String?> _matchResults = [];

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the selected players and match results list with null values
//     _selectedPlayers = List.filled(widget.tournament.matches.length * 2, null);
//     _matchResults = List.filled(widget.tournament.matches.length, '');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tournament Screen'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           child: ListView.builder(
//             itemCount: widget.tournament.matches.length,
//             itemBuilder: (context, index) {
//               final match = widget.tournament.matches[index];
//               final player1 = widget.players.firstWhere((player) => player.playerId == match.playerId1);
//               final player2 = widget.players.firstWhere((player) => player.playerId == match.playerId2);

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Match ${index + 1}'),
//                   Row(
//                     children: [
//                       Text('Player 1: '),
//                       DropdownButton<String>(
//                         value: _selectedPlayers[index * 2],
//                         onChanged: (newValue) {
//                           setState(() {
//                             _selectedPlayers[index * 2] = newValue;
//                           });
//                         },
//                         items: widget.players.map((player) {
//                           return DropdownMenuItem<String>(
//                             value: player.playerId,
//                             child: Text(player.playerName),
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Text('Player 2: '),
//                       DropdownButton<String>(
//                         value: _selectedPlayers[index * 2 + 1],
//                         onChanged: (newValue) {
//                           setState(() {
//                             _selectedPlayers[index * 2 + 1] = newValue;
//                           });
//                         },
//                         items: widget.players.map((player) {
//                           return DropdownMenuItem<String>(
//                             value: player.playerId,
//                             child: Text(player.playerName),
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   TextFormField(
//                     decoration: InputDecoration(labelText: 'Match Result'),
//                     onChanged: (newValue) {
//                       setState(() {
//                         _matchResults[index] = newValue;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 16),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // TODO: Save the selected players and match results to Firestore or your data storage.
//         },
//         child: Icon(Icons.save),
//       ),
//     );
//   }
// }
