import 'package:bloc/bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit(int initialIndex) : super(initialIndex);

  void selectPage(int index) {
    emit(index);
  }
}
