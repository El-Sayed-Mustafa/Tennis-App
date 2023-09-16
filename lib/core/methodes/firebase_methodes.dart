import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/models/court.dart';

import '../../models/message.dart';
import '../../models/club.dart';
import '../../models/player.dart';

class Method {
  late final FirebaseAuth _auth;

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {}
  }

  Future<Player> getCurrentUser() async {
    // Get the current user from Firebase Authentication
    final String playerId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('players')
        .doc(playerId)
        .get();

    return Player.fromSnapshot(snapshot);
  }

  Future<Player> getUserById(String playerId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('players')
        .doc(playerId)
        .get();

    return Player.fromSnapshot(snapshot);
  }

  Future<void> updateCourt(Court court) async {
    try {
      final courtDocRef =
          FirebaseFirestore.instance.collection('courts').doc(court.courtId);
      await courtDocRef.update(court.toJson());
    } catch (error) {
      // Handle the error if needed
      throw error;
    }
  }

  Future<Club> fetchClubData(String clubId) async {
    final clubSnapshot =
        await FirebaseFirestore.instance.collection('clubs').doc(clubId).get();

    // Assuming the Club class has a factory constructor to parse data from Firestore
    final clubData = Club.fromSnapshot(clubSnapshot);
    return clubData;
  }

//Function to get all chats for the current player sorted from newest to oldest
  Future<List<ChatMessage>> getAllChatsForCurrentPlayer(
      String currentPlayerId) async {
    try {
      // Perform a query to get chats where the current player is either the sender or receiver
      final querySnapshot = await FirebaseFirestore.instance
          .collection('chats')
          .where('messages', arrayContainsAny: [
        {'senderId': currentPlayerId},
        {'receiverId': currentPlayerId},
      ]).get();

      // Extract the chats from the query result
      final chats = querySnapshot.docs.map((doc) {
        final chatData = doc.data();
        final messagesData = chatData['messages'] as List<dynamic>;
        // Sort the messages based on the timestamp (newest to oldest)
        messagesData.sort((a, b) {
          final aTimestamp = a['timestamp'] as Timestamp;
          final bTimestamp = b['timestamp'] as Timestamp;
          return bTimestamp.compareTo(aTimestamp);
        });

        // Create the ChatMessage instance from the first (latest) message in each chat
        return ChatMessage.fromMap(messagesData.first);
      }).toList();

      return chats;
    } catch (e) {
      return [];
    }
  }

  Future<bool> doesPlayerHaveRight(String requiredRight) async {
    final String playerId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final playerSnapshot = await FirebaseFirestore.instance
          .collection('players')
          .doc(playerId)
          .get();
      final playerData = playerSnapshot.data();
      if (playerData == null) {
        // Handle the case if player data not found
        return false;
      }
      final clubdata = await fetchClubData(playerData['participatedClubId']);
      if (clubdata.clubAdmin == playerId) {
        return true;
      }
      final Map<String, dynamic> clubRolesMap = playerData['clubRoles'] ?? {};
      final List<String> roleIds = (clubRolesMap.values).join(',').split(',');

      final rolesSnapshot = await FirebaseFirestore.instance
          .collection('roles')
          .where(FieldPath.documentId, whereIn: roleIds)
          .get();
      final rolesData = rolesSnapshot.docs;
      for (final roleDoc in rolesData) {
        final roleData = roleDoc.data();
        final List<String> rights = List<String>.from(roleData['rights'] ?? []);
        if (rights.contains(requiredRight)) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Handle errors if necessary
      return false;
    }
  }

  Future<void> deleteClub(String clubId) async {
    try {
      final clubsCollection = FirebaseFirestore.instance.collection('clubs');
      final clubDoc = clubsCollection.doc(clubId);

      // Step 1: Fetch the club data to access the associated data
      final DocumentSnapshot<Map<String, dynamic>> clubSnapshot =
          await clubDoc.get();
      final Club club = Club.fromSnapshot(clubSnapshot);

      if (club != null) {
        final List<String> eventIds = List<String>.from(club.eventIds ?? []);
        final List<String> courtIds = List<String>.from(club.courtIds ?? []);
        final String clubChatId = club.clubChatId;
        final List<String> singleMatchesIds =
            List<String>.from(club.singleMatchesIds ?? []);
        final List<String> doubleMatchesIds =
            List<String>.from(club.doubleMatchesIds ?? []);
        final List<String> singleTournamentsIds =
            List<String>.from(club.singleTournamentsIds ?? []);
        final List<String> doubleTournamentsIds =
            List<String>.from(club.doubleTournamentsIds ?? []);

        // Check if these fields are not empty before proceeding
        if (eventIds.isNotEmpty) {
          // Step 2: Delete events associated with the club
          final eventsCollection =
              FirebaseFirestore.instance.collection('events');
          for (final eventId in eventIds) {
            final DocumentSnapshot<Map<String, dynamic>> eventSnapshot =
                await eventsCollection.doc(eventId).get();
            if (eventSnapshot.exists) {
              await eventsCollection.doc(eventId).delete();
            }
          }
        }

        if (courtIds.isNotEmpty) {
          // Step 3: Delete courts associated with the club
          final courtsCollection =
              FirebaseFirestore.instance.collection('courts');
          for (final courtId in courtIds) {
            final DocumentSnapshot<Map<String, dynamic>> courtSnapshot =
                await courtsCollection.doc(courtId).get();
            if (courtSnapshot.exists) {
              await courtsCollection.doc(courtId).delete();
            }
          }
        }

        if (!clubChatId.isEmpty) {
          // Step 4: Delete club chat
          final chatsCollection =
              FirebaseFirestore.instance.collection('Chats');
          final DocumentSnapshot<Map<String, dynamic>> clubChatSnapshot =
              await chatsCollection.doc(clubChatId).get();
          if (clubChatSnapshot.exists) {
            await chatsCollection.doc(clubChatId).delete();
          }
        }

        if (singleMatchesIds.isNotEmpty) {
          // Step 5: Delete single matches associated with the club
          final singleMatchesCollection =
              FirebaseFirestore.instance.collection('single_matches');
          for (final match in singleMatchesIds) {
            final DocumentSnapshot<Map<String, dynamic>> matchSnapshot =
                await singleMatchesCollection.doc(match).get();
            if (matchSnapshot.exists) {
              await singleMatchesCollection.doc(match).delete();
            }
          }
        }

        if (doubleMatchesIds.isNotEmpty) {
          // Step 6: Delete double matches associated with the club
          final doubleMatchesCollection =
              FirebaseFirestore.instance.collection('double_matches');
          for (final match in doubleMatchesIds) {
            final DocumentSnapshot<Map<String, dynamic>> matchSnapshot =
                await doubleMatchesCollection.doc(match).get();
            if (matchSnapshot.exists) {
              await doubleMatchesCollection.doc(match).delete();
            }
          }
        }

        if (singleTournamentsIds.isNotEmpty) {
          // Step 7: Delete single tournaments associated with the club
          final singleTournamentCollection =
              FirebaseFirestore.instance.collection('singleTournaments');
          for (final match in singleTournamentsIds) {
            final DocumentSnapshot<Map<String, dynamic>> matchSnapshot =
                await singleTournamentCollection.doc(match).get();
            if (matchSnapshot.exists) {
              await singleTournamentCollection.doc(match).delete();
            }
          }
        }

        if (doubleTournamentsIds.isNotEmpty) {
          // Step 8: Delete double tournaments associated with the club
          final doubleTournamentsCollection =
              FirebaseFirestore.instance.collection('doubleTournaments');
          for (final match in doubleTournamentsIds) {
            final DocumentSnapshot<Map<String, dynamic>> matchSnapshot =
                await doubleTournamentsCollection.doc(match).get();
            if (matchSnapshot.exists) {
              await doubleTournamentsCollection.doc(match).delete();
            }
          }
        }

        // Additional steps to remove references from other collections
        // Step 9: Fetch the list of member IDs from the club you're deleting
        final List<String> memberIds = List<String>.from(club.memberIds ?? []);

        for (final memberId in memberIds) {
          final playerRef =
              FirebaseFirestore.instance.collection('players').doc(memberId);
          // Clear the 'eventsId' list for the player
          final updatedData = {
            'playerLevel': '0',
            'skillLevel': '0',
            'clubRoles': {},
            'participatedClubId': '',
            'isRated': false,
            'eventIds': [],
            'reversedCourtsIds': [],
            'matchId': [],
            'singleMatchesIds': [],
            'doubleMatchesIds': [],
            'singleTournamentsIds': [],
            'doubleTournamentsIds': [],
          };
          await playerRef.update(updatedData);
        }

        // Step 11: Delete the club
        final DocumentSnapshot<Map<String, dynamic>> clubSnapshot =
            await clubDoc.get();
        if (clubSnapshot.exists) {
          await clubDoc.delete();
        }
      }
    } catch (error) {
      // Handle any errors that occur during the deletion process.
    }
  }

  Future<void> updateMatchPlayedAndTotalWins(
      String playerId, bool isWinner) async {
    try {
      final playerRef =
          FirebaseFirestore.instance.collection('players').doc(playerId);
      final playerDoc = await playerRef.get();

      if (playerDoc.exists) {
        final data = playerDoc.data() as Map<String, dynamic>;
        final int currentMatchPlayed = data['matchPlayed'] ?? 0;
        final int currentTotalWins = data['totalWins'] ?? 0;

        final updatedData;
        if (isWinner) {
          updatedData = {
            'matchPlayed': currentMatchPlayed + 1,
            'totalWins': currentTotalWins + 1,
          };
        } else {
          updatedData = {
            'matchPlayed': currentMatchPlayed + 1,
          };
        }

        await playerRef.update(updatedData);
      } else {}
    } catch (e) {}
  }

  Future<void> reEnterResult(String playerId, bool isWinner) async {
    try {
      final playerRef =
          FirebaseFirestore.instance.collection('players').doc(playerId);
      final playerDoc = await playerRef.get();

      if (playerDoc.exists) {
        final data = playerDoc.data() as Map<String, dynamic>;
        final int currentMatchPlayed = data['matchPlayed'] ?? 0;
        final int currentTotalWins = data['totalWins'] ?? 0;

        final updatedData;
        if (isWinner) {
          updatedData = {
            'matchPlayed': currentMatchPlayed - 1,
            'totalWins': currentTotalWins - 1,
          };
        } else {
          updatedData = {
            'matchPlayed': currentMatchPlayed - 1,
          };
        }

        await playerRef.update(updatedData);
      } else {}
    } catch (e) {}
  }
}
