import '../../../../models/player.dart';

abstract class ClubManagementState {}

class ClubManagementInitial extends ClubManagementState {}

class ClubManagementLoading extends ClubManagementState {}

class ClubManagementLoaded extends ClubManagementState {
  final List<Player> members;

  ClubManagementLoaded(this.members);
}

class ClubManagementError extends ClubManagementState {
  final String errorMessage;

  ClubManagementError(this.errorMessage);
}
