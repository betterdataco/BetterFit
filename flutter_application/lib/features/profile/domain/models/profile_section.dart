import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum ProfileSection {
  basicInfo('Basic Info', Icons.person, 'Manage your personal information'),
  fitnessGoals('Fitness Goals', Icons.fitness_center, 'Set your fitness objectives'),
  healthDataSync('Health Data Sync', Icons.sync, 'Connect health apps'),
  preferences('Preferences', Icons.settings, 'Customize your experience'),
  aiTrainingSettings('AI Training Settings', Icons.psychology, 'Configure AI assistant'),
  completeOnboarding('Complete Onboarding', Icons.assignment, 'Finish setup process');

  const ProfileSection(this.title, this.icon, this.description);
  final String title;
  final IconData icon;
  final String description;
}

class ProfileSectionItem extends Equatable {
  const ProfileSectionItem({
    required this.section,
    required this.isEnabled,
    this.badge,
  });

  final ProfileSection section;
  final bool isEnabled;
  final String? badge;

  @override
  List<Object?> get props => [section, isEnabled, badge];
} 