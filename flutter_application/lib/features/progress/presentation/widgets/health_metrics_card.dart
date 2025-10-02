import 'package:flutter/material.dart';
import '../../domain/models/progress_data.dart';
import '../../../../core/constants/colors.dart';

class HealthMetricsCard extends StatelessWidget {
  const HealthMetricsCard({
    super.key,
    required this.healthMetrics,
  });

  final HealthMetricsTrends healthMetrics;

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
                Icons.favorite,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Health Metrics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Metrics Grid
          Row(
            children: [
              Expanded(child: _buildMetricCard('Weight', '${_getLatestWeight()} kg', Icons.monitor_weight)),
              const SizedBox(width: 8),
              Expanded(child: _buildMetricCard('Steps', '${_getLatestSteps()}', Icons.directions_walk)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildMetricCard('Sleep', '${_getLatestSleep()}h', Icons.bedtime)),
              const SizedBox(width: 8),
              Expanded(child: _buildMetricCard('Heart Rate', '${_getLatestHeartRate()} bpm', Icons.favorite)),
            ],
          ),
          const SizedBox(height: 16),
          
          // Trend Indicators
          _buildTrendIndicators(),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textSecondary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIndicators() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '30-Day Trends',
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildTrendIndicator('Weight', _getWeightTrend()),
            const SizedBox(width: 16),
            _buildTrendIndicator('Steps', _getStepsTrend()),
            const SizedBox(width: 16),
            _buildTrendIndicator('Sleep', _getSleepTrend()),
            const SizedBox(width: 16),
            _buildTrendIndicator('HR', _getHeartRateTrend()),
          ],
        ),
      ],
    );
  }

  Widget _buildTrendIndicator(String label, double trend) {
    final isPositive = trend > 0;
    final isNeutral = trend == 0;
    
    return Column(
      children: [
        Icon(
          isPositive ? Icons.trending_up : isNeutral ? Icons.trending_flat : Icons.trending_down,
          color: isPositive ? AppColors.success : isNeutral ? AppColors.textSecondary : AppColors.error,
          size: 16,
        ),
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

  // Helper methods to get latest values and trends
  double _getLatestWeight() {
    if (healthMetrics.weightData.isEmpty) return 70.0;
    return healthMetrics.weightData.last.weightKg;
  }

  int _getLatestSteps() {
    if (healthMetrics.stepsData.isEmpty) return 8000;
    return healthMetrics.stepsData.last.steps;
  }

  double _getLatestSleep() {
    if (healthMetrics.sleepData.isEmpty) return 7.5;
    return healthMetrics.sleepData.last.hours;
  }

  int _getLatestHeartRate() {
    if (healthMetrics.heartRateData.isEmpty) return 70;
    return healthMetrics.heartRateData.last.bpm;
  }

  double _getWeightTrend() {
    if (healthMetrics.weightData.length < 2) return 0.0;
    final first = healthMetrics.weightData.first.weightKg;
    final last = healthMetrics.weightData.last.weightKg;
    return last - first;
  }

  double _getStepsTrend() {
    if (healthMetrics.stepsData.length < 2) return 0.0;
    final first = healthMetrics.stepsData.first.steps;
    final last = healthMetrics.stepsData.last.steps;
    return (last - first) / 1000.0; // Convert to thousands
  }

  double _getSleepTrend() {
    if (healthMetrics.sleepData.length < 2) return 0.0;
    final first = healthMetrics.sleepData.first.hours;
    final last = healthMetrics.sleepData.last.hours;
    return last - first;
  }

  double _getHeartRateTrend() {
    if (healthMetrics.heartRateData.length < 2) return 0.0;
    final first = healthMetrics.heartRateData.first.bpm;
    final last = healthMetrics.heartRateData.last.bpm;
    return (first - last).toDouble(); // Lower is better for heart rate
  }
} 