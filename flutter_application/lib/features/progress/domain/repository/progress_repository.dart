import '../models/progress_data.dart';

abstract class ProgressRepository {
  /// Fetch progress data for the dashboard
  Future<ProgressData> getProgressData();

  /// Generate AI summary for progress
  Future<AISummary> generateAISummary();

  /// Fetch weekly adherence data
  Future<WeeklyAdherence> getWeeklyAdherence();

  /// Fetch health metrics trends
  Future<HealthMetricsTrends> getHealthMetricsTrends();

  /// Fetch workout performance data
  Future<WorkoutPerformance> getWorkoutPerformance();

  /// Fetch achievements
  Future<List<Achievement>> getAchievements();

  /// Update progress data
  Future<void> updateProgressData(ProgressData data);
}
