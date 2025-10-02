import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/spacings.dart';
import '../../../../core/extensions/build_context_extensions.dart';
import '../bloc/profile_bloc.dart';

class HealthDataSyncSection extends StatelessWidget {
  const HealthDataSyncSection({
    super.key,
    this.lastSyncDate,
  });

  final DateTime? lastSyncDate;

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
                Icons.sync,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: Spacing.s8),
              Text(
                'Health Data Sync',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.s16),
          
          // Apple HealthKit
          _buildHealthAppCard(
            'Apple HealthKit',
            Icons.apple,
            'Connect your Apple Health data',
            () => _syncHealthData(context, 'Apple HealthKit'),
          ),
          
          const SizedBox(height: Spacing.s12),
          
          // Google Fit
          _buildHealthAppCard(
            'Google Fit',
            Icons.fitness_center,
            'Connect your Google Fit data',
            () => _syncHealthData(context, 'Google Fit'),
          ),
          
          const SizedBox(height: Spacing.s16),
          
          // Sync Status
          if (lastSyncDate != null) _buildSyncStatus(),
        ],
      ),
    );
  }

  Widget _buildHealthAppCard(
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      color: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[800]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.s16),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 32,
              ),
              const SizedBox(width: Spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSyncStatus() {
    return Container(
      padding: const EdgeInsets.all(Spacing.s12),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: AppColors.success,
          ),
          const SizedBox(width: Spacing.s8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Last Synced',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${lastSyncDate!.day}/${lastSyncDate!.month}/${lastSyncDate!.year} at ${lastSyncDate!.hour}:${lastSyncDate!.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _syncHealthData(BuildContext context, String appName) {
    context.read<ProfileBloc>().add(const HealthDataSyncRequested());
    context.showSnackBarMessage('Syncing with $appName...');
  }
} 