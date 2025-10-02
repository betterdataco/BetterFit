part of 'bottom_navigation_bar_bloc.dart';

abstract class BottomNavigationBarEvent extends Equatable {
  const BottomNavigationBarEvent();

  @override
  List<Object> get props => [];
}

class SelectTab extends BottomNavigationBarEvent {
  final int index;

  const SelectTab(this.index);

  @override
  List<Object> get props => [index];
} 