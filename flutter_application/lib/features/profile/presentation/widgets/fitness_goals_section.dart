import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/spacings.dart';
import '../../../user/domain/models/user_profile.dart';
import '../bloc/profile_bloc.dart';

class FitnessGoalsSection extends StatefulWidget {
  const FitnessGoalsSection({
    super.key,
    required this.userProfile,
  });

  final UserProfile userProfile;

  @override
  State<FitnessGoalsSection> createState() => _FitnessGoalsSectionState();
}

class _FitnessGoalsSectionState extends State<FitnessGoalsSection> {
  String? _selectedGoal;
  int _selectedDaysPerWeek = 3;
  bool _hasGymAccess = true;

  final List<String> _goals = [
    'Lose fat',
    'Build muscle',
    'Increase energy',
    'Improve endurance',
    'Maintain health',
  ];

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.userProfile.goal;
    _hasGymAccess = widget.userProfile.gymAccess;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.fitness_center,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: Spacing.s8),
              Text(
                'Fitness Goals',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.s16),
          
          // Primary Goal Selection
          _buildGoalSelection(),
          
          const SizedBox(height: Spacing.s16),
          
          // Days per Week Selection
          _buildDaysPerWeekSelection(),
          
          const SizedBox(height: Spacing.s16),
          
          // Gym Access Selection
          _buildGymAccessSelection(),
          
          const SizedBox(height: Spacing.s16),
          
          // Current Fitness Level
          _buildFitnessLevelDisplay(),
        ],
      ),
    );
  }

  Widget _buildGoalSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What\'s your primary goal?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: Spacing.s8),
        Wrap(
          spacing: Spacing.s8,
          runSpacing: Spacing.s8,
          children: _goals.map((goal) {
            final isSelected = _selectedGoal == goal;
            return ChoiceChip(
              label: Text(
                goal.toUpperCase(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[400],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedGoal = selected ? goal : null;
                });
                _updateProfile();
              },
              backgroundColor: AppColors.background,
              selectedColor: AppColors.primary,
              side: BorderSide(color: Colors.grey[600]!),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDaysPerWeekSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How many days per week can you train?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: Spacing.s8),
        Row(
          children: [1, 2, 3, 4, 5, 6, 7].map((days) {
            final isSelected = _selectedDaysPerWeek == days;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ChoiceChip(
                  label: Text(
                    '$days',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedDaysPerWeek = days;
                    });
                    _updateProfile();
                  },
                  backgroundColor: AppColors.background,
                  selectedColor: AppColors.primary,
                  side: BorderSide(color: Colors.grey[600]!),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGymAccessSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Do you have access to a gym?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: Spacing.s8),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Text(
                  'YES',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                selected: _hasGymAccess,
                onSelected: (selected) {
                  setState(() {
                    _hasGymAccess = true;
                  });
                  _updateProfile();
                },
                backgroundColor: AppColors.background,
                selectedColor: AppColors.primary,
                side: BorderSide(color: Colors.grey[600]!),
              ),
            ),
            const SizedBox(width: Spacing.s8),
            Expanded(
              child: ChoiceChip(
                label: const Text(
                  'NO, HOME WORKOUTS',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                selected: !_hasGymAccess,
                onSelected: (selected) {
                  setState(() {
                    _hasGymAccess = false;
                  });
                  _updateProfile();
                },
                backgroundColor: AppColors.background,
                selectedColor: AppColors.primary,
                side: BorderSide(color: Colors.grey[600]!),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFitnessLevelDisplay() {
    final fitnessLevel = widget.userProfile.fitnessLevel;
    if (fitnessLevel == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(Spacing.s12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.trending_up,
            color: AppColors.primary,
          ),
          const SizedBox(width: Spacing.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Fitness Level',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
                Text(
                  fitnessLevel.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateProfile() {
    context.read<ProfileBloc>().add(
      ProfileDataUpdated(
        goal: _selectedGoal,
        gymAccess: _hasGymAccess,
        // TODO: Add days per week to user profile model
      ),
    );
  }
} 