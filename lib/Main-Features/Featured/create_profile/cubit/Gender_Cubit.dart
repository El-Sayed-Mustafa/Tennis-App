import 'package:flutter_bloc/flutter_bloc.dart';

class GenderCubit extends Cubit<String> {
  GenderCubit() : super('');

  void selectGender(String gender) {
    emit(gender);
  }
}
