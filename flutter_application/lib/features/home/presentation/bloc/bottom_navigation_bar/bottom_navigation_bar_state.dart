import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/features/home/presentation/widgets/better_fit_home.dart';
import 'package:flutter_application/features/settings/presentation/page/settings_page.dart';

@immutable
class BottomNavigationBarState extends Equatable {
  const BottomNavigationBarState({
    this.selectedIndex = 0,
  });

  final int selectedIndex;
  static const tabs = <TabItem>[
    TabItem(
      label: "Home",
      icon: Icons.home,
      tooltip: "Home",
      content: BetterFitHome(),
    ),
    TabItem(
      label: "Settings",
      icon: Icons.settings,
      tooltip: "Settings",
      content: SettingsPage(),
    ),
  ];

  BottomNavigationBarState copyWith({int? selectedIndex}) {
    return BottomNavigationBarState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [
        selectedIndex,
        tabs,
      ];
}

class TabItem {
  const TabItem({
    required this.tooltip,
    required this.label,
    required this.icon,
    required this.content,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final Widget content;
}
