import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerTypeCubit extends Cubit<String> {
  PlayerTypeCubit() : super('');

  void selectPlayerType(String playerType) {
    emit(playerType);
  }
}
