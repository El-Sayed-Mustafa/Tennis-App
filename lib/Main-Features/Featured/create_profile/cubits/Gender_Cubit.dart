import 'package:flutter_bloc/flutter_bloc.dart';

class GenderCubit extends Cubit<String> {
  GenderCubit([String initialGender = 'Male']) : super(initialGender);

  void selectGender(String gender) {
    emit(gender);
  }
}
