// Define the state classes
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SaveMatchState {}

class SaveMatchInitial extends SaveMatchState {}

class SaveMatchInProgress extends SaveMatchState {}

class SaveMatchSuccess extends SaveMatchState {}

class SaveMatchFailure extends SaveMatchState {
  final String error;
  SaveMatchFailure({required this.error});
}
