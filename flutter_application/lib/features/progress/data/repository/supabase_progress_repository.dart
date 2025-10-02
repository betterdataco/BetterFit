import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/progress_repository.dart';
import '../../domain/models/progress_data.dart';

@Injectable(as: ProgressRepository)
class SupabaseProgressRepository implements ProgressRepository {
  SupabaseProgressRepository(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<ProgressData> getProgressData() async {
    try {
      // Fetch all data in parallel
      final futures = await Future.wait([
        _getProgressSummary(),
        getWeeklyAdherence(),
        getHealthMetricsTrends(),
        getWorkoutPerformance(),
        generateAISummary(),
        getAchievements(),
      ]);

      return ProgressData(
        summary: futures[0] as ProgressSummary,
        weeklyAdherence: futures[1] as WeeklyAdherence,
        healthMetrics: futures[2] as HealthMetricsTrends,
        workoutPerformance: futures[3] as WorkoutPerformance,
        aiSummary: futures[4] as AISummary,
        achievements: futures[5] as List<Achievement>,
      );
    } catch (e) {
      throw Exception('Failed to fetch progress data: $e');
    }
  }

  Future<ProgressSummary> _getProgressSummary() async {
    try {
      // Fetch user profile data
      final userResponse = await _supabaseClient
          .from('user_profiles')
          .select('goal, fitness_level')
          .eq('id', _supabaseClient.auth.currentUser!.id)
          .single();

      // Fetch current workout plan
      final workoutResponse = await _supabaseClient
          .from('workouts')
          .select('title, summary')
          .eq('user_id', _supabaseClient.auth.currentUser!.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      final goal = userResponse['goal'] ?? 'Build Muscle';
      final fitnessLevel = userResponse['fitness_level'] ?? 'intermediate';
      final currentPlan =
          workoutResponse?['title'] ?? '4-Day Gym Split – Push/Pull';

      // Generate AI assessment (simplified for now)
      final aiAssessment = _generateAIAssessment(goal, fitnessLevel);

      return ProgressSummary(
        userGoal: goal,
        fitnessStage: _getFitnessStage(fitnessLevel),
        currentPlan: currentPlan,
        aiAssessment: aiAssessment,
      );
    } catch (e) {
      return const ProgressSummary(
        userGoal: '🏋️‍♂️ Muscle Gain',
        fitnessStage: 'Intermediate',
        currentPlan: '4-Day Gym Split – Push/Pull',
        aiAssessment:
            "You're on track! Your last 10 days show consistent progress in upper-body strength. Let's keep building.",
      );
    }
  }

  String _getFitnessStage(String level) {
    switch (level) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return 'Intermediate';
    }
  }

  String _generateAIAssessment(String goal, String fitnessLevel) {
    // Simplified AI assessment - in a real app, this would use an LLM
    if (goal.toLowerCase().contains('muscle')) {
      return "You're on track! Your last 10 days show consistent progress in upper-body strength. Let's keep building.";
    } else if (goal.toLowerCase().contains('weight')) {
      return "Great progress! Your consistent workouts and nutrition are paying off. Keep up the momentum!";
    } else {
      return "You're making steady progress toward your fitness goals. Consistency is key!";
    }
  }

  @override
  Future<WeeklyAdherence> getWeeklyAdherence() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 14));

      // Fetch exercise logs for the last 14 days
      final exerciseLogs = await _supabaseClient
          .from('exercise_log')
          .select('date, exercise_name')
          .eq('user_id', _supabaseClient.auth.currentUser!.id)
          .gte('date', startDate.toIso8601String().split('T')[0])
          .lte('date', now.toIso8601String().split('T')[0]);

      // Fetch workout plans
      final workouts = await _supabaseClient
          .from('workouts')
          .select('plan')
          .eq('user_id', _supabaseClient.auth.currentUser!.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      // Generate adherence data
      final days = <AdherenceDay>[];
      int completedWorkouts = 0;
      int plannedWorkouts = 0;
      int streak = 0;

      for (int i = 13; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateStr = date.toIso8601String().split('T')[0];

        final hasWorkout = exerciseLogs.any((log) => log['date'] == dateStr);
        final isPlanned = _isWorkoutPlanned(date, workouts?['plan']);

        if (isPlanned) plannedWorkouts++;
        if (hasWorkout) completedWorkouts++;

        if (hasWorkout && isPlanned) {
          streak++;
        } else {
          streak = 0;
        }

        days.add(AdherenceDay(
          date: date,
          isCompleted: hasWorkout,
          isPlanned: isPlanned,
          workoutType: hasWorkout ? 'Strength' : null,
        ));
      }

      return WeeklyAdherence(
        days: days,
        completedWorkouts: completedWorkouts,
        plannedWorkouts: plannedWorkouts,
        streak: streak,
      );
    } catch (e) {
      // Return mock data if there's an error
      return _getMockWeeklyAdherence();
    }
  }

  bool _isWorkoutPlanned(DateTime date, dynamic plan) {
    // Simplified logic - in a real app, this would parse the workout plan
    // For now, assume workouts are planned on Monday, Wednesday, Friday, Sunday
    final weekday = date.weekday;
    return weekday == 1 || weekday == 3 || weekday == 5 || weekday == 7;
  }

  WeeklyAdherence _getMockWeeklyAdherence() {
    final now = DateTime.now();
    final days = <AdherenceDay>[];

    for (int i = 13; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final isPlanned = date.weekday == 1 ||
          date.weekday == 3 ||
          date.weekday == 5 ||
          date.weekday == 7;
      final isCompleted = isPlanned && i % 2 == 0; // Mock completion pattern

      days.add(AdherenceDay(
        date: date,
        isCompleted: isCompleted,
        isPlanned: isPlanned,
        workoutType: isCompleted ? 'Strength' : null,
      ));
    }

    return WeeklyAdherence(
      days: days,
      completedWorkouts: 8,
      plannedWorkouts: 10,
      streak: 3,
    );
  }

  @override
  Future<HealthMetricsTrends> getHealthMetricsTrends() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 30));

      // Fetch health data
      final healthData = await _supabaseClient
          .from('health_data')
          .select('date, steps, heart_rate_avg, sleep_hours')
          .eq('user_id', _supabaseClient.auth.currentUser!.id)
          .gte('date', startDate.toIso8601String().split('T')[0])
          .lte('date', now.toIso8601String().split('T')[0])
          .order('date');

      // Fetch weight data from progress table
      final progressData = await _supabaseClient
          .from('progress')
          .select('date, weight_kg')
          .eq('user_id', _supabaseClient.auth.currentUser!.id)
          .gte('date', startDate.toIso8601String().split('T')[0])
          .lte('date', now.toIso8601String().split('T')[0])
          .order('date');

      // Parse data
      final weightData = progressData
          .map((entry) => WeightEntry(
                date: DateTime.parse(entry['date']),
                weightKg: (entry['weight_kg'] as num).toDouble(),
              ))
          .toList();

      final stepsData = healthData
          .map((entry) => StepsEntry(
                date: DateTime.parse(entry['date']),
                steps: entry['steps'] ?? 0,
              ))
          .toList();

      final sleepData = healthData
          .map((entry) => SleepEntry(
                date: DateTime.parse(entry['date']),
                hours: (entry['sleep_hours'] as num?)?.toDouble() ?? 7.5,
              ))
          .toList();

      final heartRateData = healthData
          .map((entry) => HeartRateEntry(
                date: DateTime.parse(entry['date']),
                bpm: (entry['heart_rate_avg'] as num?)?.toInt() ?? 70,
              ))
          .toList();

      return HealthMetricsTrends(
        weightData: weightData,
        stepsData: stepsData,
        sleepData: sleepData,
        heartRateData: heartRateData,
      );
    } catch (e) {
      return _getMockHealthMetrics();
    }
  }

  HealthMetricsTrends _getMockHealthMetrics() {
    final now = DateTime.now();
    final weightData = <WeightEntry>[];
    final stepsData = <StepsEntry>[];
    final sleepData = <SleepEntry>[];
    final heartRateData = <HeartRateEntry>[];

    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      weightData.add(WeightEntry(
        date: date,
        weightKg: 70.0 + (i * 0.1), // Mock weight progression
      ));
      stepsData.add(StepsEntry(
        date: date,
        steps: 8000 + (i * 100), // Mock steps progression
      ));
      sleepData.add(SleepEntry(
        date: date,
        hours: 7.5 + (i * 0.05), // Mock sleep progression
      ));
      heartRateData.add(HeartRateEntry(
        date: date,
        bpm: (70 - (i * 0.5)).toInt(), // Mock heart rate improvement
      ));
    }

    return HealthMetricsTrends(
      weightData: weightData,
      stepsData: stepsData,
      sleepData: sleepData,
      heartRateData: heartRateData,
    );
  }

  @override
  Future<WorkoutPerformance> getWorkoutPerformance() async {
    try {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 14));

      // Fetch exercise logs
      final exerciseLogs = await _supabaseClient
          .from('exercise_log')
          .select('exercise_name, reps, sets, duration_minutes')
          .eq('user_id', _supabaseClient.auth.currentUser!.id)
          .gte('date', startDate.toIso8601String().split('T')[0])
          .lte('date', now.toIso8601String().split('T')[0]);

      // Calculate top exercises
      final exerciseCounts = <String, int>{};
      final exerciseVolumes = <String, double>{};

      for (final log in exerciseLogs) {
        final name = log['exercise_name'] as String;
        final reps = log['reps'] as int? ?? 0;
        final sets = log['sets'] as int? ?? 0;
        final volume = reps * sets;

        exerciseCounts[name] = (exerciseCounts[name] ?? 0) + 1;
        exerciseVolumes[name] = (exerciseVolumes[name] ?? 0) + volume;
      }

      // Sort by frequency and get top 3
      final sortedExercises = exerciseCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      final topExercises = sortedExercises.take(3).map((entry) {
        final name = entry.key;
        final frequency = entry.value;
        final totalVolume = exerciseVolumes[name] ?? 0.0;
        final progressPercentage = 20.0 + (frequency * 5.0); // Mock progress

        return TopExercise(
          name: name,
          frequency: frequency,
          totalVolume: totalVolume,
          progressPercentage: progressPercentage,
        );
      }).toList();

      // Mock volume progress
      const volumeProgress = VolumeProgress(
        exerciseName: 'Squats',
        currentVolume: 1200.0,
        previousVolume: 1000.0,
        percentageChange: 20.0,
      );

      // Mock cardio progress
      const cardioProgress = CardioProgress(
        duration: 45,
        pace: 5.5,
        caloriesBurned: 350,
      );

      // Mock AI insight
      const aiInsight =
          "You've improved in squat depth and volume. Add resistance next week.";

      return WorkoutPerformance(
        topExercises: topExercises,
        volumeProgress: volumeProgress,
        cardioProgress: cardioProgress,
        aiInsight: aiInsight,
      );
    } catch (e) {
      return _getMockWorkoutPerformance();
    }
  }

  WorkoutPerformance _getMockWorkoutPerformance() {
    return const WorkoutPerformance(
      topExercises: [
        TopExercise(
          name: 'Squats',
          frequency: 8,
          totalVolume: 1200.0,
          progressPercentage: 25.0,
        ),
        TopExercise(
          name: 'Bench Press',
          frequency: 6,
          totalVolume: 800.0,
          progressPercentage: 15.0,
        ),
        TopExercise(
          name: 'Deadlifts',
          frequency: 4,
          totalVolume: 600.0,
          progressPercentage: 10.0,
        ),
      ],
      volumeProgress: VolumeProgress(
        exerciseName: 'Squats',
        currentVolume: 1200.0,
        previousVolume: 1000.0,
        percentageChange: 20.0,
      ),
      cardioProgress: CardioProgress(
        duration: 45,
        pace: 5.5,
        caloriesBurned: 350,
      ),
      aiInsight:
          "You've improved in squat depth and volume. Add resistance next week.",
    );
  }

  @override
  Future<AISummary> generateAISummary() async {
    try {
      // In a real app, this would call an LLM API
      // For now, return a mock summary
      return AISummary(
        content:
            "Over the past 14 days, you've completed 8 of 10 planned workouts. Your average steps per day rose to 8,200, and your resting HR dropped slightly. You're progressing toward your muscle gain goal, especially in upper-body strength. Let's continue this plan, but increase rest intervals on leg days.",
        generatedAt: DateTime.now(),
        period: "14 days",
      );
    } catch (e) {
      return AISummary(
        content:
            "Your progress is looking great! Keep up the consistent workouts and you'll reach your goals.",
        generatedAt: DateTime.now(),
        period: "14 days",
      );
    }
  }

  @override
  Future<List<Achievement>> getAchievements() async {
    // Mock achievements - in a real app, these would be calculated based on actual data
    return [
      Achievement(
        title: '5 Workouts This Week',
        description: 'Completed 5 workouts in a single week',
        icon: '🏋️',
        earnedAt: DateTime.now(),
        isUnlocked: true,
      ),
      Achievement(
        title: '10,000 Steps in a Day',
        description: 'Reached 10,000 steps in a single day',
        icon: '👟',
        earnedAt: DateTime.now(),
        isUnlocked: true,
      ),
      const Achievement(
        title: 'Hit Goal Weight Milestone',
        description: 'Reached a significant weight milestone',
        icon: '⚖️',
        earnedAt: null,
        isUnlocked: false,
      ),
      const Achievement(
        title: 'Completed Full Week Plan',
        description: 'Completed all planned workouts for a week',
        icon: '📅',
        earnedAt: null,
        isUnlocked: false,
      ),
    ];
  }

  @override
  Future<void> updateProgressData(ProgressData data) async {
    try {
      // Update progress summary in the database
      await _supabaseClient.from('progress').upsert({
        'user_id': _supabaseClient.auth.currentUser!.id,
        'date': DateTime.now().toIso8601String().split('T')[0],
        'summary': data.aiSummary.content,
        'notes': 'Progress dashboard update',
      });
    } catch (e) {
      throw Exception('Failed to update progress data: $e');
    }
  }
}
