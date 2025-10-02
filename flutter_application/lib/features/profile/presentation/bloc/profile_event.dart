part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileLoaded extends ProfileEvent {
  const ProfileLoaded({required this.userProfile});

  final UserProfile userProfile;

  @override
  List<Object?> get props => [userProfile];
}

class ProfileSectionSelected extends ProfileEvent {
  const ProfileSectionSelected({required this.section});

  final ProfileSection section;

  @override
  List<Object?> get props => [section];
}

class ProfileDataUpdated extends ProfileEvent {
  const ProfileDataUpdated({
    this.name,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.fitnessLevel,
    this.goal,
    this.gymAccess,
  });

  final String? name;
  final int? age;
  final Gender? gender;
  final int? heightCm;
  final int? weightKg;
  final FitnessLevel? fitnessLevel;
  final String? goal;
  final bool? gymAccess;

  @override
  List<Object?> get props => [
        name,
        age,
        gender,
        heightCm,
        weightKg,
        fitnessLevel,
        goal,
        gymAccess,
      ];
}

class HealthDataSyncRequested extends ProfileEvent {
  const HealthDataSyncRequested();
}

class OnboardingCompleted extends ProfileEvent {
  const OnboardingCompleted();
} 