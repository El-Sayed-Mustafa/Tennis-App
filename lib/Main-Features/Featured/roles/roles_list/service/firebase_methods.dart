import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../models/club.dart';
import '../../../../../models/player.dart';
import '../../../../../models/roles.dart';

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
