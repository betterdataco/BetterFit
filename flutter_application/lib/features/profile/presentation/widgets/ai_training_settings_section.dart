import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/spacings.dart';
import '../../../user/domain/models/user_profile.dart';

class AiTrainingSettingsSection extends StatelessWidget {
  const AiTrainingSettingsSection({
    super.key,
    required this.userProfile,
  });

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.psychology,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: Spacing.s8),
              Text(
                'AI Training Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: Spacing.s16),
          Text(
            'AI training settings coming soon...',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
} 