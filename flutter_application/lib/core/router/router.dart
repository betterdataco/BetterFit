import 'package:flutter/material.dart';
import 'package:flutter_application/core/router/routes.dart';
import 'package:flutter_application/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application/features/home/presentation/home_page.dart';
import 'package:flutter_application/features/theme_mode/presentation/page/theme_mode__page.dart';
import 'package:flutter_application/features/user/presentation/page/change_email_address_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/page/login_page.dart';
import '../../features/auth/presentation/page/onboarding_page.dart';
import '../../features/profile/presentation/page/profile_page.dart';
import '../../features/progress/presentation/page/progress_dashboard_page.dart';
import '../../features/meal_tracking/presentation/pages/food_search_test_page.dart';
import '../../features/settings/presentation/page/settings_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: Routes.initial.name,
      path: Routes.initial.path,
      builder: (context, state) => BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthUserAuthenticated) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    ),
    GoRoute(
      name: Routes.login.name,
      path: Routes.login.path,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      name: Routes.home.name,
      path: Routes.home.path,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: Routes.settings.name,
      path: Routes.settings.path,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      name: Routes.changeEmailAddress.name,
      path: Routes.changeEmailAddress.path,
      builder: (context, state) => const ChangeEmailAddressPage(),
    ),
    GoRoute(
      name: Routes.themeMode.name,
      path: Routes.themeMode.path,
      builder: (context, state) => const ThemeModePage(),
    ),
    GoRoute(
      name: Routes.onboarding.name,
      path: Routes.onboarding.path,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      name: Routes.profile.name,
      path: Routes.profile.path,
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      name: Routes.progress.name,
      path: Routes.progress.path,
      builder: (context, state) => const ProgressDashboardPage(),
    ),
    GoRoute(
      name: Routes.foodSearchTest.name,
      path: Routes.foodSearchTest.path,
      builder: (context, state) => const FoodSearchTestPage(),
    ),
    GoRoute(
      name: Routes.mealTracking.name,
      path: Routes.mealTracking.path,
      builder: (context, state) =>
          const FoodSearchTestPage(), // TODO: Replace with actual meal tracking page
    ),
    GoRoute(
      name: Routes.exercises.name,
      path: Routes.exercises.path,
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text(
            'Exercise Plan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ), // TODO: Replace with actual exercises page
    ),
    GoRoute(
      name: Routes.mealPlan.name,
      path: Routes.mealPlan.path,
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text(
            'Meal Plan',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ), // TODO: Replace with actual meal plan page
    ),
  ],
);
