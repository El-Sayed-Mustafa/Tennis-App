abstract class FindMatchState {}

class FindMatchInitial extends FindMatchState {}

class FindMatchLoading extends FindMatchState {}

class FindMatchSuccess extends FindMatchState {}

class FindMatchError extends FindMatchState {
  final String errorMessage;

  FindMatchError(this.errorMessage);
}
