abstract class DoubleMatchState {}

class DoubleMatchInitial extends DoubleMatchState {}

class DoubleMatchInProgress extends DoubleMatchState {}

class DoubleMatchSuccess extends DoubleMatchState {}

class DoubleMatchFailure extends DoubleMatchState {
  final String error;
  DoubleMatchFailure({required this.error});
}
