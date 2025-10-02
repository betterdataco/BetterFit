import 'package:equatable/equatable.dart';

class ProgressData extends Equatable {
  const ProgressData({
    required this.summary,
    required this.weeklyAdherence,
    required this.healthMetrics,
    required this.workoutPerformance,
    required this.aiSummary,
    required this.achievements,
  });

  final ProgressSummary summary;
  final WeeklyAdherence weeklyAdherence;
  final HealthMetricsTrends healthMetrics;
  final WorkoutPerformance workoutPerformance;
  final AISummary aiSummary;
  final List<Achievement> achievements;

  @override
  List<Object?> get props => [
        summary,
        weeklyAdherence,
        healthMetrics,
        workoutPerformance,
        aiSummary,
        achievements,
      ];
}

class ProgressSummary extends Equatable {
  const ProgressSummary({
    required this.userGoal,
    required this.fitnessStage,
    required this.currentPlan,
    required this.aiAssessment,
  });

  final String userGoal;
  final String fitnessStage;
  final String currentPlan;
  final String aiAssessment;

  @override
  List<Object?> get props =>
      [userGoal, fitnessStage, currentPlan, aiAssessment];
}

class WeeklyAdherence extends Equatable {
  const WeeklyAdherence({
    required this.days,
    required this.completedWorkouts,
    required this.plannedWorkouts,
    required this.streak,
  });

  final List<AdherenceDay> days;
  final int completedWorkouts;
  final int plannedWorkouts;
  final int streak;

  double get adherenceRate =>
      plannedWorkouts > 0 ? completedWorkouts / plannedWorkouts : 0.0;

  @override
  List<Object?> get props => [days, completedWorkouts, plannedWorkouts, streak];
}

class AdherenceDay extends Equatable {
  const AdherenceDay({
    required this.date,
    required this.isCompleted,
    required this.isPlanned,
    this.workoutType,
  });

  final DateTime date;
  final bool isCompleted;
  final bool isPlanned;
  final String? workoutType;

  @override
  List<Object?> get props => [date, isCompleted, isPlanned, workoutType];
}

class HealthMetricsTrends extends Equatable {
  const HealthMetricsTrends({
    required this.weightData,
    required this.stepsData,
    required this.sleepData,
    required this.heartRateData,
  });

  final List<WeightEntry> weightData;
  final List<StepsEntry> stepsData;
  final List<SleepEntry> sleepData;
  final List<HeartRateEntry> heartRateData;

  @override
  List<Object?> get props => [weightData, stepsData, sleepData, heartRateData];
}

class WeightEntry extends Equatable {
  const WeightEntry({
    required this.date,
    required this.weightKg,
  });

  final DateTime date;
  final double weightKg;

  @override
  List<Object?> get props => [date, weightKg];
}

class StepsEntry extends Equatable {
  const StepsEntry({
    required this.date,
    required this.steps,
  });

  final DateTime date;
  final int steps;

  @override
  List<Object?> get props => [date, steps];
}

class SleepEntry extends Equatable {
  const SleepEntry({
    required this.date,
    required this.hours,
  });

  final DateTime date;
  final double hours;

  @override
  List<Object?> get props => [date, hours];
}

class HeartRateEntry extends Equatable {
  const HeartRateEntry({
    required this.date,
    required this.bpm,
  });

  final DateTime date;
  final int bpm;

  @override
  List<Object?> get props => [date, bpm];
}

class WorkoutPerformance extends Equatable {
  const WorkoutPerformance({
    required this.topExercises,
    required this.volumeProgress,
    required this.cardioProgress,
    required this.aiInsight,
  });

  final List<TopExercise> topExercises;
  final VolumeProgress volumeProgress;
  final CardioProgress cardioProgress;
  final String aiInsight;

  @override
  List<Object?> get props =>
      [topExercises, volumeProgress, cardioProgress, aiInsight];
}

class TopExercise extends Equatable {
  const TopExercise({
    required this.name,
    required this.frequency,
    required this.totalVolume,
    required this.progressPercentage,
  });

  final String name;
  final int frequency;
  final double totalVolume;
  final double progressPercentage;

  @override
  List<Object?> get props => [name, frequency, totalVolume, progressPercentage];
}

class VolumeProgress extends Equatable {
  const VolumeProgress({
    required this.exerciseName,
    required this.currentVolume,
    required this.previousVolume,
    required this.percentageChange,
  });

  final String exerciseName;
  final double currentVolume;
  final double previousVolume;
  final double percentageChange;

  @override
  List<Object?> get props =>
      [exerciseName, currentVolume, previousVolume, percentageChange];
}

class CardioProgress extends Equatable {
  const CardioProgress({
    required this.duration,
    required this.pace,
    required this.caloriesBurned,
  });

  final int duration; // in minutes
  final double pace; // minutes per km
  final int caloriesBurned;

  @override
  List<Object?> get props => [duration, pace, caloriesBurned];
}

class AISummary extends Equatable {
  const AISummary({
    required this.content,
    required this.generatedAt,
    required this.period,
  });

  final String content;
  final DateTime generatedAt;
  final String period; // e.g., "14 days"

  @override
  List<Object?> get props => [content, generatedAt, period];
}

class Achievement extends Equatable {
  const Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.earnedAt,
    required this.isUnlocked,
  });

  final String title;
  final String description;
  final String icon;
  final DateTime? earnedAt;
  final bool isUnlocked;

  @override
  List<Object?> get props => [title, description, icon, earnedAt, isUnlocked];
}
