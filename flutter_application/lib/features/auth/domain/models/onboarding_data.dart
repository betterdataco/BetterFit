import 'package:equatable/equatable.dart';
import '../../../user/domain/models/user_profile.dart';

enum OnboardingStep {
  welcome,
  name,
  basicInfo, // Combined age/gender/height/weight with smart inference
  fitnessLevel,
  goal,
  gymAccess,
  healthKitPermission,
  complete,
}

enum FitnessGoal {
  loseWeight('Lose Weight', 'Focus on calorie deficit and cardio', '🔥'),
  buildMuscle('Build Muscle', 'Strength training and protein-rich diet', '💪'),
  improveEnergy('Improve Energy', 'Balanced nutrition and moderate exercise', '⚡'),
  maintainHealth('Maintain Health', 'General fitness and wellness', '❤️'),
  athleticPerformance('Athletic Performance', 'Sport-specific training', '🏃');

  const FitnessGoal(this.title, this.description, this.emoji);
  final String title;
  final String description;
  final String emoji;
}

enum ActivityLevel {
  sedentary('Sedentary', 'Little to no exercise', FitnessLevel.beginner, '🛋️'),
  lightlyActive('Lightly Active', 'Light exercise 1-3 days/week', FitnessLevel.beginner, '🚶'),
  moderatelyActive('Moderately Active', 'Moderate exercise 3-5 days/week', FitnessLevel.intermediate, '🏃'),
  veryActive('Very Active', 'Hard exercise 6-7 days/week', FitnessLevel.advanced, '💪'),
  extremelyActive('Extremely Active', 'Very hard exercise, physical job', FitnessLevel.advanced, '🔥');

  const ActivityLevel(this.title, this.description, this.fitnessLevel, this.emoji);
  final String title;
  final String description;
  final FitnessLevel fitnessLevel;
  final String emoji;
}

class OnboardingData extends Equatable {
  const OnboardingData({
    this.currentStep = OnboardingStep.welcome,
    this.name,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.fitnessLevel,
    this.goal,
    this.gymAccess = false,
    this.healthKitData,
    this.inferredData,
    this.smartDefaults,
  });

  final OnboardingStep currentStep;
  final String? name;
  final int? age;
  final Gender? gender;
  final int? heightCm;
  final int? weightKg;
  final FitnessLevel? fitnessLevel;
  final FitnessGoal? goal;
  final bool gymAccess;
  final HealthKitData? healthKitData;
  final InferredData? inferredData;
  final SmartDefaults? smartDefaults;

  OnboardingData copyWith({
    OnboardingStep? currentStep,
    String? name,
    int? age,
    Gender? gender,
    int? heightCm,
    int? weightKg,
    FitnessLevel? fitnessLevel,
    FitnessGoal? goal,
    bool? gymAccess,
    HealthKitData? healthKitData,
    InferredData? inferredData,
    SmartDefaults? smartDefaults,
  }) {
    return OnboardingData(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      goal: goal ?? this.goal,
      gymAccess: gymAccess ?? this.gymAccess,
      healthKitData: healthKitData ?? this.healthKitData,
      inferredData: inferredData ?? this.inferredData,
      smartDefaults: smartDefaults ?? this.smartDefaults,
    );
  }

  UserProfile? toUserProfile(String userId, String email) {
    if (name == null || age == null || gender == null || 
        heightCm == null || weightKg == null || fitnessLevel == null || goal == null) {
      return null;
    }

    return UserProfile(
      id: userId,
      email: email,
      name: name!,
      age: age!,
      gender: gender!,
      heightCm: heightCm!,
      weightKg: weightKg!,
      fitnessLevel: fitnessLevel!,
      goal: goal!.title,
      gymAccess: gymAccess,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        name,
        age,
        gender,
        heightCm,
        weightKg,
        fitnessLevel,
        goal,
        gymAccess,
        healthKitData,
        inferredData,
        smartDefaults,
      ];
}

class HealthKitData extends Equatable {
  const HealthKitData({
    this.averageSteps,
    this.averageHeartRate,
    this.averageSleepHours,
    this.workoutHistory,
    this.weightHistory,
    this.height,
    this.restingHeartRate,
    this.vo2Max,
    this.activeEnergyBurned,
  });

  final int? averageSteps;
  final int? averageHeartRate;
  final double? averageSleepHours;
  final List<WorkoutSession>? workoutHistory;
  final List<WeightEntry>? weightHistory;
  final int? height;
  final int? restingHeartRate;
  final double? vo2Max;
  final int? activeEnergyBurned; // Daily average calories burned

  @override
  List<Object?> get props => [
        averageSteps,
        averageHeartRate,
        averageSleepHours,
        workoutHistory,
        weightHistory,
        height,
        restingHeartRate,
        vo2Max,
        activeEnergyBurned,
      ];
}

class WorkoutSession extends Equatable {
  const WorkoutSession({
    required this.date,
    required this.duration,
    required this.caloriesBurned,
    required this.workoutType,
    this.heartRateData,
  });

  final DateTime date;
  final int duration; // in minutes
  final int caloriesBurned;
  final String workoutType;
  final List<int>? heartRateData;

  @override
  List<Object?> get props => [date, duration, caloriesBurned, workoutType, heartRateData];
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

class InferredData extends Equatable {
  const InferredData({
    this.inferredFitnessLevel,
    this.inferredGoal,
    this.inferredHeight,
    this.inferredWeight,
    this.inferredAge,
    this.confidence = 0.0,
    this.confidenceBreakdown,
  });

  final FitnessLevel? inferredFitnessLevel;
  final FitnessGoal? inferredGoal;
  final int? inferredHeight;
  final int? inferredWeight;
  final int? inferredAge;
  final double confidence;
  final Map<String, double>? confidenceBreakdown; // Detailed confidence scores

  @override
  List<Object?> get props => [
        inferredFitnessLevel,
        inferredGoal,
        inferredHeight,
        inferredWeight,
        inferredAge,
        confidence,
        confidenceBreakdown,
      ];
}

class SmartDefaults extends Equatable {
  const SmartDefaults({
    this.suggestedAge,
    this.suggestedHeight,
    this.suggestedWeight,
    this.suggestedFitnessLevel,
    this.suggestedGoal,
    this.reasoning = '',
  });

  final int? suggestedAge;
  final int? suggestedHeight;
  final int? suggestedWeight;
  final FitnessLevel? suggestedFitnessLevel;
  final FitnessGoal? suggestedGoal;
  final String reasoning;

  @override
  List<Object?> get props => [
        suggestedAge,
        suggestedHeight,
        suggestedWeight,
        suggestedFitnessLevel,
        suggestedGoal,
        reasoning,
      ];
}
