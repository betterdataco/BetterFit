import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/profile_bloc.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/spacings.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../../../../dependency_injection.dart';
import '../../../user/domain/models/user_profile.dart';
import '../../domain/models/profile_section.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_header.dart';
import '../widgets/basic_info_section.dart';
import '../widgets/fitness_goals_section.dart';
import '../widgets/health_data_sync_section.dart';
import '../widgets/preferences_section.dart';
import '../widgets/ai_training_settings_section.dart';
import '../widgets/complete_onboarding_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // TODO: Get user profile from auth or user service
        final userProfile = UserProfile(
          id: 'temp-id',
          email: 'user@example.com',
          name: 'John Doe',
          age: 30,
          gender: Gender.male,
          heightCm: 175,
          weightKg: 70,
          fitnessLevel: FitnessLevel.intermediate,
          goal: 'Build Muscle',
          gymAccess: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        return getIt<ProfileBloc>()
          ..add(ProfileLoaded(userProfile: userProfile));
      },
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            context.showErrorSnackBarMessage(state.message);
          }
        },
        child: const _ProfileView(),
      ),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is ProfileLoadedState) {
            return _buildProfileContent(context, state);
          }

          if (state is ProfileHealthDataSyncing) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: Spacing.s16),
                  Text(
                    'Syncing health data...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text(
              'Failed to load profile',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, ProfileLoadedState state) {
    return Column(
      children: [
        // Profile Header
        ProfileHeader(userProfile: state.userProfile),

        const SizedBox(height: Spacing.s16),

        // Profile Sections
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.s16),
            child: Column(
              children: [
                // Section Cards
                ...state.sections.map((section) => Padding(
                      padding: const EdgeInsets.only(bottom: Spacing.s12),
                      child: ProfileSectionCard(
                        section: section,
                        isSelected: section.section == state.selectedSection,
                        onTap: () {
                          if (section.isEnabled) {
                            context.read<ProfileBloc>().add(
                                  ProfileSectionSelected(
                                      section: section.section),
                                );
                          }
                        },
                      ),
                    )),

                const SizedBox(height: Spacing.s24),

                // Selected Section Content
                _buildSectionContent(context, state.selectedSection, state),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionContent(
    BuildContext context,
    ProfileSection section,
    ProfileLoadedState state,
  ) {
    switch (section) {
      case ProfileSection.basicInfo:
        return BasicInfoSection(userProfile: state.userProfile);
      case ProfileSection.fitnessGoals:
        return FitnessGoalsSection(userProfile: state.userProfile);
      case ProfileSection.healthDataSync:
        return HealthDataSyncSection(
          lastSyncDate: state.lastSyncDate,
        );
      case ProfileSection.preferences:
        return const PreferencesSection();
      case ProfileSection.aiTrainingSettings:
        return AiTrainingSettingsSection(userProfile: state.userProfile);
      case ProfileSection.completeOnboarding:
        return CompleteOnboardingSection(userProfile: state.userProfile);
    }
  }
}
