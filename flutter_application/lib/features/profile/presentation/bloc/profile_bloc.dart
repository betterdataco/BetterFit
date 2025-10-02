import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/profile_section.dart';
import '../../../user/domain/models/user_profile.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileInitial()) {
    on<ProfileLoaded>(_onProfileLoaded);
    on<ProfileSectionSelected>(_onProfileSectionSelected);
    on<ProfileDataUpdated>(_onProfileDataUpdated);
    on<HealthDataSyncRequested>(_onHealthDataSyncRequested);
    on<OnboardingCompleted>(_onOnboardingCompleted);
  }

  Future<void> _onProfileLoaded(
    ProfileLoaded event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // TODO: Load user profile from repository
      final userProfile = event.userProfile;
      final sections = _buildProfileSections(userProfile);
      
      emit(ProfileLoadedState(
        userProfile: userProfile,
        sections: sections,
        selectedSection: ProfileSection.basicInfo,
      ));
    } catch (e) {
      emit(ProfileError('Failed to load profile: $e'));
    }
  }

  Future<void> _onProfileSectionSelected(
    ProfileSectionSelected event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoadedState) {
      final currentState = state as ProfileLoadedState;
      emit(currentState.copyWith(selectedSection: event.section));
    }
  }

  Future<void> _onProfileDataUpdated(
    ProfileDataUpdated event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoadedState) {
      final currentState = state as ProfileLoadedState;
      final updatedProfile = currentState.userProfile.copyWith(
        name: event.name ?? currentState.userProfile.name,
        age: event.age ?? currentState.userProfile.age,
        gender: event.gender ?? currentState.userProfile.gender,
        heightCm: event.heightCm ?? currentState.userProfile.heightCm,
        weightKg: event.weightKg ?? currentState.userProfile.weightKg,
        fitnessLevel: event.fitnessLevel ?? currentState.userProfile.fitnessLevel,
        goal: event.goal ?? currentState.userProfile.goal,
        gymAccess: event.gymAccess ?? currentState.userProfile.gymAccess,
      );

      final sections = _buildProfileSections(updatedProfile);
      
      emit(currentState.copyWith(
        userProfile: updatedProfile,
        sections: sections,
      ));
    }
  }

  Future<void> _onHealthDataSyncRequested(
    HealthDataSyncRequested event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // TODO: Implement health data sync
      emit(const ProfileHealthDataSyncing());
      
      // Simulate sync process
      await Future.delayed(const Duration(seconds: 2));
      
      if (state is ProfileLoadedState) {
        final currentState = state as ProfileLoadedState;
        emit(currentState.copyWith(
          lastSyncDate: DateTime.now(),
        ));
      }
    } catch (e) {
      emit(ProfileError('Failed to sync health data: $e'));
    }
  }

  Future<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // TODO: Complete onboarding process
      if (state is ProfileLoadedState) {
        final currentState = state as ProfileLoadedState;
        final updatedProfile = currentState.userProfile.copyWith(
          // Add onboarding completion fields
        );
        
        final sections = _buildProfileSections(updatedProfile);
        emit(currentState.copyWith(
          userProfile: updatedProfile,
          sections: sections,
        ));
      }
    } catch (e) {
      emit(ProfileError('Failed to complete onboarding: $e'));
    }
  }

  List<ProfileSectionItem> _buildProfileSections(UserProfile userProfile) {
    return [
      const ProfileSectionItem(
        section: ProfileSection.basicInfo,
        isEnabled: true,
      ),
      const ProfileSectionItem(
        section: ProfileSection.fitnessGoals,
        isEnabled: true,
      ),
      const ProfileSectionItem(
        section: ProfileSection.healthDataSync,
        isEnabled: true,
      ),
      const ProfileSectionItem(
        section: ProfileSection.preferences,
        isEnabled: true,
      ),
      ProfileSectionItem(
        section: ProfileSection.aiTrainingSettings,
        isEnabled: userProfile.isProfileComplete,
        badge: userProfile.isProfileComplete ? null : 'Complete Profile First',
      ),
      ProfileSectionItem(
        section: ProfileSection.completeOnboarding,
        isEnabled: !userProfile.isProfileComplete,
        badge: !userProfile.isProfileComplete ? 'Required' : null,
      ),
    ];
  }
} 