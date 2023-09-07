import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerTypeCubit extends Cubit<String> {
  PlayerTypeCubit({String initialType = 'Singles'}) : super(initialType);

  void selectPlayerType(String playerType) {
    emit(playerType);
  }
}
