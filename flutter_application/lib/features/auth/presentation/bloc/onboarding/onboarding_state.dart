part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingInProgress extends OnboardingState {
  const OnboardingInProgress({
    required this.data,
  });

  final OnboardingData data;

  @override
  List<Object?> get props => [data];
}

class OnboardingSuccess extends OnboardingState {
  const OnboardingSuccess({
    required this.userProfile,
  });

  final UserProfile userProfile;

  @override
  List<Object?> get props => [userProfile];
}

class OnboardingError extends OnboardingState {
  const OnboardingError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
