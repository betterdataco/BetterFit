import 'package:flutter/material.dart';
import '../../domain/models/progress_data.dart';
import '../../../../core/constants/colors.dart';

class WeeklyAdherenceCard extends StatelessWidget {
  const WeeklyAdherenceCard({
    super.key,
    required this.adherence,
  });

  final WeeklyAdherence adherence;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Weekly Adherence',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Completed',
                  '${adherence.completedWorkouts}',
                  AppColors.success,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Planned',
                  '${adherence.plannedWorkouts}',
                  AppColors.info,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Streak',
                  '${adherence.streak}',
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Progress Bar
          LinearProgressIndicator(
            value: adherence.adherenceRate,
            backgroundColor: AppColors.textSecondary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              adherence.adherenceRate >= 0.8 ? AppColors.success : AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(adherence.adherenceRate * 100).toStringAsFixed(0)}% Adherence',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          
          // Calendar View
          _buildCalendarView(),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Last 14 Days',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: adherence.days.map((day) {
            return Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: day.isCompleted
                    ? AppColors.success
                    : day.isPlanned
                        ? AppColors.error
                        : AppColors.textSecondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: day.isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 12)
                    : day.isPlanned
                        ? const Icon(Icons.close, color: Colors.white, size: 12)
                        : null,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildLegendItem('Completed', AppColors.success),
            const SizedBox(width: 16),
            _buildLegendItem('Missed', AppColors.error),
            const SizedBox(width: 16),
            _buildLegendItem('No Plan', AppColors.textSecondary.withOpacity(0.2)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
} 