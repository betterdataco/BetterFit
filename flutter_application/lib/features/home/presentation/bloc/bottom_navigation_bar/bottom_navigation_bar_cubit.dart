import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import 'bottom_navigation_bar_state.dart';

@injectable
class BottomNavigationBarCubit extends Cubit<BottomNavigationBarState> {
  BottomNavigationBarCubit() : super(const BottomNavigationBarState());

  void switchTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
