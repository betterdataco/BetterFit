part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoadedState extends ProfileState {
  const ProfileLoadedState({
    required this.userProfile,
    required this.sections,
    required this.selectedSection,
    this.lastSyncDate,
  });

  final UserProfile userProfile;
  final List<ProfileSectionItem> sections;
  final ProfileSection selectedSection;
  final DateTime? lastSyncDate;

  ProfileLoadedState copyWith({
    UserProfile? userProfile,
    List<ProfileSectionItem>? sections,
    ProfileSection? selectedSection,
    DateTime? lastSyncDate,
  }) {
    return ProfileLoadedState(
      userProfile: userProfile ?? this.userProfile,
      sections: sections ?? this.sections,
      selectedSection: selectedSection ?? this.selectedSection,
      lastSyncDate: lastSyncDate ?? this.lastSyncDate,
    );
  }

  @override
  List<Object?> get props => [
        userProfile,
        sections,
        selectedSection,
        lastSyncDate,
      ];
}

class ProfileHealthDataSyncing extends ProfileState {
  const ProfileHealthDataSyncing();
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
} 