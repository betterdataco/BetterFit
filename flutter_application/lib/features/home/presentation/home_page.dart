import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application/dependency_injection.dart';
import 'package:flutter_application/features/home/presentation/bloc/bottom_navigation_bar/bottom_navigation_bar_bloc.dart';
import 'package:flutter_application/features/home/presentation/bloc/bottom_navigation_bar/bottom_navigation_bar_state.dart';
import 'package:flutter_application/features/home/presentation/widgets/better_fit_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BottomNavigationBarBloc>(),
      child: BlocBuilder<BottomNavigationBarBloc, BottomNavigationBarState>(
        buildWhen: (previous, current) => current.selectedIndex != previous.selectedIndex,
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: BottomNavigationBarState.tabs[state.selectedIndex].content,
            ),
            bottomNavigationBar: const BetterFitNavigationBar(),
          );
        },
      ),
    );
  }
}
