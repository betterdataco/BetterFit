part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingStarted extends OnboardingEvent {
  const OnboardingStarted();
}

class OnboardingStepCompleted extends OnboardingEvent {
  const OnboardingStepCompleted();
}

class OnboardingStepBack extends OnboardingEvent {
  const OnboardingStepBack();
}

class OnboardingDataUpdated extends OnboardingEvent {
  const OnboardingDataUpdated({
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
  final FitnessGoal? goal;
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

class HealthKitDataRequested extends OnboardingEvent {
  const HealthKitDataRequested();
}

class OnboardingCompleted extends OnboardingEvent {
  const OnboardingCompleted({
    required this.userId,
    required this.email,
  });

  final String userId;
  final String email;

  @override
  List<Object?> get props => [userId, email];
}

class SmartDefaultsRequested extends OnboardingEvent {
  const SmartDefaultsRequested();
}
