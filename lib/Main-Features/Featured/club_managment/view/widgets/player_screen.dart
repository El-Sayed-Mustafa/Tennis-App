import 'package:flutter/material.dart';
import '../../../../../models/player.dart';
import 'package:intl/intl.dart';

class PlayerScreen extends StatelessWidget {
  final Player player;

  const PlayerScreen({required this.player, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Player Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                player.playerName,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text('Skill level: ${player.skillLevel}'),
              SizedBox(height: 8),
              Text('Membership: ${player.clubRoles['membership'] ?? ''}'),
              SizedBox(height: 8),
              Text('Player type: ${player.playerType}'),
              SizedBox(height: 8),
              Text(
                  'Date: ${DateFormat('MMM d, yyyy').format(player.birthDate)}'),
              SizedBox(height: 8),
              Text('Role: ${player.clubRoles['role'] ?? ''}'),
              SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    (screenHeight + screenWidth) * 0.08 / 5),
                child: Container(
                  height: (screenHeight + screenWidth) * 0.08,
                  width: (screenHeight + screenWidth) * 0.08,
                  child: player.photoURL != null
                      ? Image.network(
                          player.photoURL!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/profileimage.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implement any action you want when the button is pressed
                },
                child: Text('Action Button'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
