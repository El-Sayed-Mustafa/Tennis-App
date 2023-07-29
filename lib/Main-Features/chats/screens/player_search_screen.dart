import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/player.dart';

class PlayerSearchScreen extends StatefulWidget {
  @override
  _PlayerSearchScreenState createState() => _PlayerSearchScreenState();
}

class _PlayerSearchScreenState extends State<PlayerSearchScreen> {
  String _searchQuery = '';
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search players...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchQuery = '';
                    // Perform the search again with an empty query to show all players
                    _performSearch();
                  },
                ),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _performSearch();
              },
            ),
          ),
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  void _performSearch() {
    setState(() {});
  }

  String _normalizeSearchQuery(String searchQuery) {
    // Normalize the search query to lowercase (or uppercase if preferred)
    return searchQuery.toLowerCase();
  }

  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('players').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final players = snapshot.data!.docs;
        if (players.isEmpty) {
          return Center(child: Text('No players found'));
        }

        final normalizedSearchQuery = _normalizeSearchQuery(_searchQuery);

        // Filter players based on the normalized search query
        final filteredPlayers = players.where((playerDoc) {
          final player = Player.fromSnapshot(playerDoc);
          final normalizedPlayerName = _normalizeSearchQuery(player.playerName);

          // Check if the player name contains the normalized search query
          return normalizedPlayerName.contains(normalizedSearchQuery);
        }).toList();

        if (filteredPlayers.isEmpty) {
          return Center(child: Text('No matching players found'));
        }

        return ListView.builder(
          itemCount: filteredPlayers.length,
          itemBuilder: (context, index) {
            final player = Player.fromSnapshot(filteredPlayers[index]);
            return ListTile(
              title: Text(player.playerName),
              subtitle: Text(player.playerLevel),
              // Add more player information or actions here if needed
            );
          },
        );
      },
    );
  }
}

// The Player class and its factory method (Player.fromSnapshot) are assumed to be defined as shown in the previous examples.
