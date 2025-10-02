import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'bottom_navigation_bar_state.dart';

part 'bottom_navigation_bar_event.dart';

@injectable
class BottomNavigationBarBloc extends Bloc<BottomNavigationBarEvent, BottomNavigationBarState> {
  BottomNavigationBarBloc() : super(const BottomNavigationBarState()) {
    on<SelectTab>(_onSelectTab);
  }

  void _onSelectTab(SelectTab event, Emitter<BottomNavigationBarState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }
} 