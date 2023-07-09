import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerTypeCubit extends Cubit<String> {
  PlayerTypeCubit() : super('Singles');

  void selectGender(String gender) {
    emit(gender);
  }
}
