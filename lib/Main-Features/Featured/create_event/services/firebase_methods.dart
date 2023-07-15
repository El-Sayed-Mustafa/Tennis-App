import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<String>> fetchClubNames(String playerId) async {
  try {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('players')
            .doc(playerId)
            .get();
    final clubIds = snapshot.data()?['clubIds'] as List<dynamic>;
    final clubNames = await fetchClubNamesFromIds(clubIds);
    var clubNamesFetched = true;
    return clubNames;
  } catch (error) {
    throw Exception('Failed to fetch club names: $error');
  }
}

Future<List<String>> fetchClubNamesFromIds(List<dynamic> clubIds) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('clubs')
        .where(FieldPath.documentId, whereIn: clubIds)
        .get();
    final clubNames =
        snapshot.docs.map((doc) => doc.data()['clubName'] as String).toList();
    return clubNames;
  } catch (error) {
    throw Exception('Failed to fetch club names from IDs: $error');
  }
}
