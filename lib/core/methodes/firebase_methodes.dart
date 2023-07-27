import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/club.dart';
import '../../models/player.dart';

class Method {
  Future<Player> getCurrentUser() async {
    // Get the current user from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch additional user data from Firestore based on the uid
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('players')
          .doc(user.uid)
          .get();

      return Player.fromSnapshot(snapshot);
    }
    throw Exception("User not found");
  }

  Future<Club> fetchClubData(String clubId) async {
    final clubSnapshot =
        await FirebaseFirestore.instance.collection('clubs').doc(clubId).get();

    // Assuming the Club class has a factory constructor to parse data from Firestore
    final clubData = Club.fromSnapshot(clubSnapshot);
    return clubData;
  }
}
