import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/spacings.dart';
import '../../../user/domain/models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.userProfile,
  });

  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.s16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Avatar and Name
          Row(
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.warning],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    _getInitials(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: Spacing.s16),
              
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile.name ?? 'Unknown User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: Spacing.s4),
                    Text(
                      userProfile.email,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: Spacing.s8),
                    _buildProfileStatus(),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: Spacing.s16),
          
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Age',
                  '${userProfile.age ?? 'N/A'}',
                  Icons.calendar_today,
                ),
              ),
              const SizedBox(width: Spacing.s12),
              Expanded(
                child: _buildStatCard(
                  'Height',
                  '${userProfile.heightCm ?? 'N/A'} cm',
                  Icons.height,
                ),
              ),
              const SizedBox(width: Spacing.s12),
              Expanded(
                child: _buildStatCard(
                  'Weight',
                  '${userProfile.weightKg ?? 'N/A'} kg',
                  Icons.monitor_weight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStatus() {
    final isComplete = userProfile.isProfileComplete;
    
    return Container(
              padding: const EdgeInsets.symmetric(
          horizontal: Spacing.s12,
          vertical: Spacing.s8,
        ),
      decoration: BoxDecoration(
        color: isComplete ? AppColors.success : AppColors.warning,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isComplete ? Icons.check_circle : Icons.warning,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: Spacing.s4),
          Text(
            isComplete ? 'Profile Complete' : 'Profile Incomplete',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(Spacing.s12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(height: Spacing.s4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: Spacing.s4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials() {
    if (userProfile.name == null || userProfile.name!.isEmpty) {
      return 'U';
    }
    
    final names = userProfile.name!.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    
    return userProfile.name![0].toUpperCase();
  }
} 