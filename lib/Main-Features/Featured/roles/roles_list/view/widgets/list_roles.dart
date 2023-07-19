import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../models/club.dart';
import '../../../../../../models/player.dart';
import '../../../../../../models/roles.dart';

class ListRoles extends StatelessWidget {
  const ListRoles({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;
    return FutureBuilder<Player>(
      future: getPlayerData(currentUserID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return const Text('No data found');
        }
        final player = snapshot.data!;
        return FutureBuilder<Club>(
          future: getClubData(player.createdClubId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const Text('No data found');
            }
            final club = snapshot.data!;
            return FutureBuilder<List<Role>>(
              future: getRoles(club.roleIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Text('No data found');
                }
                final roles = snapshot.data!;
                return buildListView(roles);
              },
            );
          },
        );
      },
    );
  }

  Future<Player> getPlayerData(String playerId) async {
    final playerDoc = await FirebaseFirestore.instance
        .collection('players')
        .doc(playerId)
        .get();
    return Player.fromSnapshot(playerDoc);
  }

  Future<Club> getClubData(String clubId) async {
    final clubDoc =
        await FirebaseFirestore.instance.collection('clubs').doc(clubId).get();
    return Club.fromSnapshot(clubDoc);
  }

  Future<List<Role>> getRoles(List<String> roleIds) async {
    final rolesQuery = await FirebaseFirestore.instance
        .collection('roles')
        .where(FieldPath.documentId, whereIn: roleIds)
        .get();
    return rolesQuery.docs.map((doc) => Role.fromSnapshot(doc)).toList();
  }

  Widget buildListView(List<Role> roles) {
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: roles.length,
        itemBuilder: (context, index) {
          final role = roles[index];
          final color = const Color(0x5172B8FF);
          final icon = Icons.person_add_alt;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            child: Container(
              decoration: ShapeDecoration(
                color: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      icon,
                      color: Colors.black,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    role.name,
                    style: const TextStyle(
                      color: Color(0xFF15324F),
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
