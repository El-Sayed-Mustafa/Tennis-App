import 'package:cloud_firestore/cloud_firestore.dart';

class ClubRolesService {
  Future<List<String>> fetchClubRoles(String clubId) async {
    try {
      final clubDoc = await FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubId)
          .get();
      final clubData = clubDoc.data();
      if (clubData != null) {
        return List<String>.from(clubData['roleIds'] ?? []);
      }
      return [];
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching club roles: $e');
      return [];
    }
  }

  Future<List<String>> fetchRoleNames() async {
    try {
      final roleNamesList = <String>[];
      final rolesSnapshot =
          await FirebaseFirestore.instance.collection('roles').get();
      final rolesData = rolesSnapshot.docs;
      for (final roleDoc in rolesData) {
        final roleData = roleDoc.data();
        final roleName = roleData['name'] as String;
        roleNamesList.add(roleName);
      }
      return roleNamesList;
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching role names: $e');
      return [];
    }
  }
}
