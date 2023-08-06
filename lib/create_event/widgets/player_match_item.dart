import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/Main-Features/chats/screens/player_search_screen.dart';
import 'package:tennis_app/create_event/widgets/player_search_match.dart';

import '../../Main-Features/chats/screens/private_chat.dart';
import '../../Main-Features/chats/widgets/player_card.dart';
import '../../generated/l10n.dart';
import '../../models/player.dart';

class PlayerMatchItem extends StatefulWidget {
  const PlayerMatchItem({super.key});

  @override
  State<PlayerMatchItem> createState() => _PlayerMatchItemState();
}

class _PlayerMatchItemState extends State<PlayerMatchItem> {
  Player? _selectedPlayer;
  Player? _selectedPlayer2;

  void _onPlayerSelected(Player player) {
    // Update the UI with the selected player's information
    setState(() {
      _selectedPlayer = player;
    });
  }

  void _onPlayerSelected2(Player player) {
    // Update the UI with the selected player's information
    setState(() {
      _selectedPlayer2 = player;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double itemWidth = screenWidth * 0.3;
    final double itemHeight = screenHeight * .2;
    final double imageHeight = (screenHeight + screenWidth) * 0.05;

    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.only(top: 8),
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedPlayer != null
                  ? Column(
                      children: [
                        Text('Selected Player:'),
                        Text('Name: ${_selectedPlayer!.playerName}'),
                        Text('Club Name: ${_selectedPlayer!.gender}'),
                      ],
                    )
                  : Container(),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the PlayerSearchMatch screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerSearchMatch(
                          onPlayerSelected: _onPlayerSelected),
                    ),
                  );
                },
                child: Text('Select Player'),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.only(top: 8),
          width: itemWidth,
          height: itemHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedPlayer != null
                  ? Column(
                      children: [
                        Text('Selected Player:'),
                        Text('Name: ${_selectedPlayer2!.playerName}'),
                        Text('Club Name: ${_selectedPlayer2!.gender}'),
                      ],
                    )
                  : Container(),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the PlayerSearchMatch screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayerSearchMatch(
                          onPlayerSelected: _onPlayerSelected2),
                    ),
                  );
                },
                child: Text('Select Player'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
