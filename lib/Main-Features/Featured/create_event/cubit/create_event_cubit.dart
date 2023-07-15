import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'create_event_state.dart';

class CreateEventCubit extends Cubit<CreateEventState> {
  CreateEventCubit() : super(CreateEventInitialState());
  void saveEventData() {}
}
