import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/player.dart';
import 'club_management_state.dart';

class ClubManagementCubit extends Cubit<ClubManagementState> {
  ClubManagementCubit() : super(ClubManagementInitial());

  Future<void> fetchClubData(String? createdClubId) async {
    emit(ClubManagementLoading());
    if (createdClubId != null && createdClubId.isNotEmpty) {
      final clubSnapshot = await FirebaseFirestore.instance
          .collection('clubs')
          .doc(createdClubId)
          .get();

      if (clubSnapshot.exists) {
        final clubData = clubSnapshot.data();
        if (clubData != null) {
          final List<String> memberIds =
              List<String>.from(clubData['memberIds'] ?? []);
          // Now you have the list of memberIds, fetch the member data for each member
          try {
            List<Player> members = await fetchMembersData(memberIds);
            emit(ClubManagementLoaded(members));
          } catch (error) {
            emit(ClubManagementError('Error fetching members data'));
          }
        }
      }
    } else {
      emit(ClubManagementError('No club ID available'));
    }
  }

  Future<List<Player>> fetchMembersData(List<String> memberIds) async {
    List<Player> members = [];
    for (String memberId in memberIds) {
      final memberSnapshot = await FirebaseFirestore.instance
          .collection('players')
          .doc(memberId)
          .get();

      if (memberSnapshot.exists) {
        Player member = Player.fromSnapshot(memberSnapshot);
        members.add(member);
      }
    }
    return members;
  }
}
