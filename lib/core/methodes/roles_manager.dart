import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tennis_app/core/methodes/firebase_methodes.dart';

class RolesManager {
  static RolesManager? _instance;
  List<String> _userRoles = [];
  Method method = Method();
  RolesManager._();

  // Singleton instance getter
  static RolesManager get instance {
    _instance ??= RolesManager._(); // Create instance if it doesn't exist
    return _instance!;
  }

  // Method to fetch and store the list of roles and rights
  Future<List<String>> fetchUserRoles() async {
    if (_userRoles.isNotEmpty) {
      return _userRoles;
    } else {
      final String playerId = FirebaseAuth.instance.currentUser!.uid;
      try {
        final playerSnapshot = await FirebaseFirestore.instance
            .collection('players')
            .doc(playerId)
            .get();
        final playerData = playerSnapshot.data();
        if (playerData == null) {
          // Handle the case if player data not found
          return [];
        }
        final clubdata =
            await method.fetchClubData(playerData['participatedClubId']);
        if (clubdata.clubAdmin == playerId) {
          _userRoles = ['admin']; // Store the admin role
          return _userRoles;
        }
        final Map<String, dynamic> clubRolesMap = playerData['clubRoles'] ?? {};
        final List<String> roleIds = (clubRolesMap.values).join(',').split(',');

        final rolesSnapshot = await FirebaseFirestore.instance
            .collection('roles')
            .where(FieldPath.documentId, whereIn: roleIds)
            .get();
        final rolesData = rolesSnapshot.docs;
        List<String> allRights = [];

        for (final roleDoc in rolesData) {
          final roleData = roleDoc.data();
          List<String> rights = List<String>.from(roleData['rights'] ?? []);
          allRights.addAll(rights);
        }

        // Extract the rights and store them in _userRoles
        _userRoles = allRights;
        return allRights;
      } catch (e) {
        // Handle errors if necessary
        SnackBar(content: Text('Error fetching user roles: $e'));
        return [];
      }
    }
  }

  Future<bool> doesPlayerHaveRight(String requiredRight) async {
    final List<String> userRoles = await RolesManager.instance.fetchUserRoles();
    print(userRoles);
    if (userRoles.contains('admin')) {
      return true;
    }
    if (userRoles.contains(requiredRight)) {
      return true;
    } else {
      return false;
    }
  }
}

class RightsManager {
  static RightsManager? _instance;
  List<String> _userRights = [];

  // Private constructor to prevent direct instantiation
  RightsManager._();

  // Singleton instance getter
  static RightsManager get instance {
    // Create instance if it doesn't exist
    _instance ??= RightsManager._();
    return _instance!;
  }

  // Method to fetch and store the list of rights
  Future<void> fetchUserRights() async {
    // Implement the logic to fetch the rights from Firebase here.
    // Example: Fetch rights from Firestore and set _userRights.
  }

  // Method to check if a user has a specific right
  bool hasRight(String right) {
    return _userRights.contains(right);
  }
}
