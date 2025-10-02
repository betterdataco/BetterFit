import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/models/onboarding_data.dart';
import '../../../../user/domain/models/user_profile.dart';
import '../../../data/services/health_service.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingInitial()) {
    on<OnboardingStarted>(_onOnboardingStarted);
    on<OnboardingStepCompleted>(_onStepCompleted);
    on<OnboardingStepBack>(_onStepBack);
    on<OnboardingDataUpdated>(_onDataUpdated);
    on<HealthKitDataRequested>(_onHealthKitDataRequested);
    on<OnboardingCompleted>(_onOnboardingCompleted);
    on<SmartDefaultsRequested>(_onSmartDefaultsRequested);
  }

  Future<void> _onOnboardingStarted(
    OnboardingStarted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(const OnboardingInProgress(
      data: OnboardingData(),
    ));
  }

  Future<void> _onStepCompleted(
    OnboardingStepCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is! OnboardingInProgress) return;
    final currentData = (state as OnboardingInProgress).data;

    // Infer data from health kit if available
    InferredData? inferredData = currentData.inferredData;
    if (currentData.healthKitData != null) {
      inferredData = _inferDataFromHealthKit(currentData.healthKitData!);
    }

    final nextStep = _getNextStep(currentData.currentStep);
    final updatedData = currentData.copyWith(
      currentStep: nextStep,
      inferredData: inferredData,
    );

    emit(OnboardingInProgress(data: updatedData));
  }

  Future<void> _onStepBack(
    OnboardingStepBack event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is! OnboardingInProgress) return;
    final currentData = (state as OnboardingInProgress).data;

    final previousStep = _getPreviousStep(currentData.currentStep);
    final updatedData = currentData.copyWith(currentStep: previousStep);

    emit(OnboardingInProgress(data: updatedData));
  }

  Future<void> _onDataUpdated(
    OnboardingDataUpdated event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is! OnboardingInProgress) return;
    final currentData = (state as OnboardingInProgress).data;

    final updatedData = currentData.copyWith(
      name: event.name ?? currentData.name,
      age: event.age ?? currentData.age,
      gender: event.gender ?? currentData.gender,
      heightCm: event.heightCm ?? currentData.heightCm,
      weightKg: event.weightKg ?? currentData.weightKg,
      fitnessLevel: event.fitnessLevel ?? currentData.fitnessLevel,
      goal: event.goal ?? currentData.goal,
      gymAccess: event.gymAccess ?? currentData.gymAccess,
    );

    emit(OnboardingInProgress(data: updatedData));
  }

  Future<void> _onHealthKitDataRequested(
    HealthKitDataRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is! OnboardingInProgress) return;
    final currentData = (state as OnboardingInProgress).data;

    try {
      final healthService = HealthService();

      // Check if health data is available
      final isAvailable = await healthService.isHealthDataAvailable();
      if (!isAvailable) {
        emit(const OnboardingError(
            'Health data is not available on this device'));
        return;
      }

      // Request permissions
      final permissionsGranted = await healthService.requestPermissions();
      if (!permissionsGranted) {
        emit(const OnboardingError('Health data permissions were not granted'));
        return;
      }

      // Fetch health data
      final healthKitData = await healthService.fetchHealthData();
      if (healthKitData == null) {
        emit(const OnboardingError('Failed to fetch health data'));
        return;
      }

      final inferredData = _inferDataFromHealthKit(healthKitData);
      final smartDefaults = _generateSmartDefaults(healthKitData, inferredData);

      final updatedData = currentData.copyWith(
        healthKitData: healthKitData,
        inferredData: inferredData,
        smartDefaults: smartDefaults,
      );

      emit(OnboardingInProgress(data: updatedData));
    } catch (e) {
      emit(OnboardingError('Failed to fetch health data: $e'));
    }
  }

  Future<void> _onSmartDefaultsRequested(
    SmartDefaultsRequested event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is! OnboardingInProgress) return;
    final currentData = (state as OnboardingInProgress).data;

    try {
      final healthService = HealthService();
      final healthKitData = await healthService.fetchHealthData();
      
      if (healthKitData != null) {
        final inferredData = _inferDataFromHealthKit(healthKitData);
        final smartDefaults = _generateSmartDefaults(healthKitData, inferredData);

        final updatedData = currentData.copyWith(
          healthKitData: healthKitData,
          inferredData: inferredData,
          smartDefaults: smartDefaults,
        );

        emit(OnboardingInProgress(data: updatedData));
      }
    } catch (e) {
      emit(OnboardingError('Failed to generate smart defaults: $e'));
    }
  }

  Future<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<OnboardingState> emit,
  ) async {
    if (state is! OnboardingInProgress) return;
    final currentData = (state as OnboardingInProgress).data;

    try {
      final userProfile = currentData.toUserProfile(event.userId, event.email);
      if (userProfile == null) {
        emit(const OnboardingError('Failed to create user profile'));
        return;
      }

      emit(OnboardingSuccess(userProfile: userProfile));
    } catch (e) {
      emit(OnboardingError('Failed to complete onboarding: $e'));
    }
  }

  OnboardingStep _getNextStep(OnboardingStep currentStep) {
    switch (currentStep) {
      case OnboardingStep.welcome:
        return OnboardingStep.name;
      case OnboardingStep.name:
        return OnboardingStep.basicInfo;
      case OnboardingStep.basicInfo:
        return OnboardingStep.fitnessLevel;
      case OnboardingStep.fitnessLevel:
        return OnboardingStep.goal;
      case OnboardingStep.goal:
        return OnboardingStep.gymAccess;
      case OnboardingStep.gymAccess:
        return OnboardingStep.healthKitPermission;
      case OnboardingStep.healthKitPermission:
        return OnboardingStep.complete;
      case OnboardingStep.complete:
        return OnboardingStep.complete;
    }
  }

  OnboardingStep _getPreviousStep(OnboardingStep currentStep) {
    switch (currentStep) {
      case OnboardingStep.welcome:
        return OnboardingStep.welcome;
      case OnboardingStep.name:
        return OnboardingStep.welcome;
      case OnboardingStep.basicInfo:
        return OnboardingStep.name;
      case OnboardingStep.fitnessLevel:
        return OnboardingStep.basicInfo;
      case OnboardingStep.goal:
        return OnboardingStep.fitnessLevel;
      case OnboardingStep.gymAccess:
        return OnboardingStep.goal;
      case OnboardingStep.healthKitPermission:
        return OnboardingStep.gymAccess;
      case OnboardingStep.complete:
        return OnboardingStep.healthKitPermission;
    }
  }

  InferredData _inferDataFromHealthKit(HealthKitData healthKitData) {
    final confidenceBreakdown = <String, double>{};
    double totalConfidence = 0.0;
    FitnessLevel? inferredFitnessLevel;
    FitnessGoal? inferredGoal;
    int? inferredHeight;
    int? inferredWeight;
    int? inferredAge;

    // Infer fitness level from activity data
    if (healthKitData.averageSteps != null) {
      final steps = healthKitData.averageSteps!;
      double stepConfidence = 0.0;
      
      if (steps < 3000) {
        inferredFitnessLevel = FitnessLevel.beginner;
        stepConfidence = 0.8;
      } else if (steps < 6000) {
        inferredFitnessLevel = FitnessLevel.beginner;
        stepConfidence = 0.7;
      } else if (steps < 10000) {
        inferredFitnessLevel = FitnessLevel.intermediate;
        stepConfidence = 0.8;
      } else if (steps < 15000) {
        inferredFitnessLevel = FitnessLevel.advanced;
        stepConfidence = 0.8;
      } else {
        inferredFitnessLevel = FitnessLevel.advanced;
        stepConfidence = 0.9;
      }
      
      confidenceBreakdown['steps'] = stepConfidence;
      totalConfidence += stepConfidence * 0.3; // Steps are 30% of confidence
    }

    // Infer fitness level from heart rate data
    if (healthKitData.restingHeartRate != null) {
      final restingHR = healthKitData.restingHeartRate!;
      double hrConfidence = 0.0;
      
      if (restingHR < 60) {
        inferredFitnessLevel = FitnessLevel.advanced;
        hrConfidence = 0.9;
      } else if (restingHR < 70) {
        inferredFitnessLevel = FitnessLevel.intermediate;
        hrConfidence = 0.8;
      } else if (restingHR < 80) {
        inferredFitnessLevel = FitnessLevel.beginner;
        hrConfidence = 0.7;
      } else {
        inferredFitnessLevel = FitnessLevel.beginner;
        hrConfidence = 0.6;
      }
      
      confidenceBreakdown['resting_heart_rate'] = hrConfidence;
      totalConfidence += hrConfidence * 0.25; // HR is 25% of confidence
    }

    // Infer goal from workout history
    if (healthKitData.workoutHistory != null &&
        healthKitData.workoutHistory!.isNotEmpty) {
      final workouts = healthKitData.workoutHistory!;
      double workoutConfidence = 0.0;
      
      final strengthWorkouts = workouts.where((w) =>
          w.workoutType.toLowerCase().contains('strength') ||
          w.workoutType.toLowerCase().contains('weight') ||
          w.workoutType.toLowerCase().contains('muscle')).length;
      
      final cardioWorkouts = workouts.where((w) =>
          w.workoutType.toLowerCase().contains('running') ||
          w.workoutType.toLowerCase().contains('cycling') ||
          w.workoutType.toLowerCase().contains('cardio')).length;
      
      if (strengthWorkouts > cardioWorkouts) {
        inferredGoal = FitnessGoal.buildMuscle;
        workoutConfidence = 0.8;
      } else if (cardioWorkouts > strengthWorkouts) {
        inferredGoal = FitnessGoal.loseWeight;
        workoutConfidence = 0.8;
      } else {
        inferredGoal = FitnessGoal.maintainHealth;
        workoutConfidence = 0.6;
      }
      
      confidenceBreakdown['workout_history'] = workoutConfidence;
      totalConfidence += workoutConfidence * 0.25; // Workouts are 25% of confidence
    }

    // Use height and weight from health kit
    if (healthKitData.height != null) {
      inferredHeight = healthKitData.height;
      confidenceBreakdown['height'] = 0.9;
      totalConfidence += 0.9 * 0.1; // Height is 10% of confidence
    }

    if (healthKitData.weightHistory != null &&
        healthKitData.weightHistory!.isNotEmpty) {
      final latestWeight = healthKitData.weightHistory!.last;
      inferredWeight = latestWeight.weightKg.round();
      confidenceBreakdown['weight'] = 0.9;
      totalConfidence += 0.9 * 0.1; // Weight is 10% of confidence
    }

    return InferredData(
      inferredFitnessLevel: inferredFitnessLevel,
      inferredGoal: inferredGoal,
      inferredHeight: inferredHeight,
      inferredWeight: inferredWeight,
      inferredAge: inferredAge,
      confidence: totalConfidence.clamp(0.0, 1.0),
      confidenceBreakdown: confidenceBreakdown,
    );
  }

  SmartDefaults _generateSmartDefaults(HealthKitData healthKitData, InferredData inferredData) {
    String reasoning = '';
    
    // Generate smart defaults based on inferred data
    int? suggestedAge;
    int? suggestedHeight = inferredData.inferredHeight;
    int? suggestedWeight = inferredData.inferredWeight;
    FitnessLevel? suggestedFitnessLevel = inferredData.inferredFitnessLevel;
    FitnessGoal? suggestedGoal = inferredData.inferredGoal;

    // Suggest age based on activity patterns (very rough estimation)
    if (healthKitData.averageSteps != null) {
      final steps = healthKitData.averageSteps!;
      if (steps < 5000) {
        suggestedAge = 45; // Older adults tend to be less active
        reasoning += 'Based on low step count, suggesting older age group. ';
      } else if (steps > 12000) {
        suggestedAge = 25; // Younger adults tend to be more active
        reasoning += 'Based on high step count, suggesting younger age group. ';
      } else {
        suggestedAge = 35; // Middle age
        reasoning += 'Based on moderate step count, suggesting middle age group. ';
      }
    }

    // Enhance reasoning based on health data
    if (healthKitData.restingHeartRate != null) {
      final hr = healthKitData.restingHeartRate!;
      if (hr < 60) {
        reasoning += 'Excellent resting heart rate indicates good fitness. ';
      } else if (hr > 80) {
        reasoning += 'Higher resting heart rate suggests room for improvement. ';
      }
    }

    if (healthKitData.workoutHistory?.isNotEmpty ?? false) {
      final workoutCount = healthKitData.workoutHistory!.length;
      reasoning += 'Found $workoutCount recent workouts. ';
    }

    if (reasoning.isEmpty) {
      reasoning = 'Using standard recommendations based on available data.';
    }

    return SmartDefaults(
      suggestedAge: suggestedAge,
      suggestedHeight: suggestedHeight,
      suggestedWeight: suggestedWeight,
      suggestedFitnessLevel: suggestedFitnessLevel,
      suggestedGoal: suggestedGoal,
      reasoning: reasoning,
    );
  }
}
