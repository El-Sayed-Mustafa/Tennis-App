import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerTypeCubit extends Cubit<String> {
  PlayerTypeCubit() : super('');

  void selectGender(String gender) {
    emit(gender);
  }
}
