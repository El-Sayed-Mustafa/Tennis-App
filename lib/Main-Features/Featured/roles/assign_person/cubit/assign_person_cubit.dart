import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../service/club_roles_service.dart';
import 'assign_person_state.dart';

class AssignPersonCubit extends Cubit<AssignPersonState> {
  final ClubRolesService clubRolesService = ClubRolesService();

  AssignPersonCubit() : super(AssignPersonInitial());

  void assignRole(String memberName, List<String> selectedRole) async {
    if (memberName.isEmpty) {
      emit(AssignPersonError('Please enter the member name'));
      return;
    }

    if (selectedRole.isEmpty) {
      emit(AssignPersonError('Please select at least one role'));
      return;
    }

    emit(AssignPersonLoading());

    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final String? playerId =
            await clubRolesService.getPlayerIdByName(memberName);
        if (playerId == null) {
          emit(AssignPersonError('Player not found with the given name'));
          return;
        }

        final DocumentSnapshot<Map<String, dynamic>> playerSnapshot =
            await FirebaseFirestore.instance
                .collection('players')
                .doc(playerId)
                .get();

        final DocumentSnapshot<Map<String, dynamic>> admin =
            await FirebaseFirestore.instance
                .collection('players')
                .doc(currentUser.uid)
                .get();
        final data = admin.data();
        if (data != null) {
          final String createdClubId = data['createdClubId'] as String? ?? '';
          final Map<String, String> clubRoles = <String, String>{
            createdClubId: selectedRole.join(",")
          };

          await playerSnapshot.reference.update({'clubRoles': clubRoles});

          emit(AssignPersonSuccess('Roles assigned successfully'));
        } else {
          emit(AssignPersonError('Player data not found'));
        }
      } else {
        emit(AssignPersonError('User not logged in'));
      }
    } catch (e) {
      print('Error assigning roles: $e');
      emit(AssignPersonError('Error assigning roles. Please try again later.'));
    }
  }

  Future<void> loadClubRoles() async {
    try {
      final userId = getCurrentUserId();
      final playerSnapshot = await FirebaseFirestore.instance
          .collection('players')
          .doc(userId)
          .get();
      final playerData = playerSnapshot.data();
      if (playerData != null) {
        // Implement the necessary logic here if needed
      }
    } catch (e) {
      print('Error loading club roles: $e');
    }
  }

  Future<void> fetchRoleNames() async {
    try {
      final roleNamesList = await clubRolesService.fetchRoleNames();
      // Emit the fetched role names as a state
      emit(AssignPersonFetchedRoleNames(roleNamesList));
    } catch (e) {
      print('Error fetching role names: $e');
    }
  }

  void updateRoleWithSelectedRole(List<String> roles) {
    emit(AssignPersonSelectedRoles(roles));
  }

  String getCurrentUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? '';
  }
}
