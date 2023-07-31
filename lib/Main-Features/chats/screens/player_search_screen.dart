import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_app/Main-Features/chats/screens/private_chat.dart';

import '../../../core/utils/widgets/pop_app_bar.dart';
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
      body: Column(
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
            text: '    Players Search',
            suffixIconPath: '',
          ),
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
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final player = Player.fromSnapshot(filteredPlayers[index]);
            return GestureDetector(
              onTap: () {
                // Navigate to the PrivateChat screen when the item is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivateChat(player: player),
                  ),
                );
              },
              child: PlayerCard(
                  player: player), // Use the custom PlayerCard widget
            );
          },
        );
      },
    );
  }
}

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center the content vertically
        children: [
          // Player photo
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.grey, // Customize the border color here
                width: 1.0, // Customize the border width here
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: (player.photoURL != null
                  ? FadeInImage.assetNetwork(
                      placeholder: 'assets/images/loadin.gif',
                      image: player.photoURL!,
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/profile-event.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/images/internet.png',
                      fit: BoxFit.cover,
                    )),
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            // Make the player's name take up the remaining vertical space
            child: Text(
              player.playerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
