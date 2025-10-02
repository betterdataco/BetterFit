import 'package:health/health.dart';
import '../../domain/models/onboarding_data.dart';

class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final HealthFactory _health = HealthFactory();

  /// Request health data permissions
  Future<bool> requestPermissions() async {
    try {
      // Request health data permissions
      final types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.SLEEP_IN_BED,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.WEIGHT,
        HealthDataType.HEIGHT,
        HealthDataType.WORKOUT,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.BASAL_ENERGY_BURNED,
        HealthDataType.RESTING_HEART_RATE,
      ];

      final granted = await _health.requestAuthorization(types);
      return granted;
    } catch (e) {
      print('Error requesting health permissions: $e');
      return false;
    }
  }

  /// Check if health data is available
  Future<bool> isHealthDataAvailable() async {
    try {
      // Check if health data is available by trying to get a simple data type
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final testData = await _health.getHealthDataFromTypes(yesterday, now, [HealthDataType.STEPS]);
      return true; // If we can fetch data, health is available
    } catch (e) {
      print('Error checking health data availability: $e');
      return false;
    }
  }

  /// Fetch health data for onboarding with enhanced passive collection
  Future<HealthKitData?> fetchHealthData() async {
    try {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      // Fetch all health data in parallel for better performance
      final futures = await Future.wait([
        _fetchSteps(thirtyDaysAgo, now),
        _fetchHeartRate(thirtyDaysAgo, now),
        _fetchSleepHours(thirtyDaysAgo, now),
        _fetchWorkouts(thirtyDaysAgo, now),
        _fetchWeightHistory(thirtyDaysAgo, now),
        _fetchHeight(),
        _fetchRestingHeartRate(thirtyDaysAgo, now),
        _fetchActiveEnergyBurned(thirtyDaysAgo, now),
      ]);

      final steps = futures[0] as List<int>;
      final heartRate = futures[1] as List<int>;
      final sleepHours = futures[2] as List<double>;
      final workouts = futures[3] as List<WorkoutSession>;
      final weightHistory = futures[4] as List<WeightEntry>;
      final height = futures[5] as int?;
      final restingHeartRate = futures[6] as int?;
      final activeEnergyBurned = futures[7] as int?;

      return HealthKitData(
        averageSteps: steps.isNotEmpty ? (steps.reduce((a, b) => a + b) / steps.length).round() : null,
        averageHeartRate: heartRate.isNotEmpty ? (heartRate.reduce((a, b) => a + b) / heartRate.length).round() : null,
        averageSleepHours: sleepHours.isNotEmpty ? sleepHours.reduce((a, b) => a + b) / sleepHours.length : null,
        workoutHistory: workouts,
        weightHistory: weightHistory,
        height: height,
        restingHeartRate: restingHeartRate,
        activeEnergyBurned: activeEnergyBurned,
      );
    } catch (e) {
      print('Error fetching health data: $e');
      return null;
    }
  }

  /// Fetch steps data with improved analysis
  Future<List<int>> _fetchSteps(DateTime start, DateTime end) async {
    try {
      final steps = await _health.getHealthDataFromTypes(start, end, [HealthDataType.STEPS]);
      return steps.map((e) => e.value as int).toList();
    } catch (e) {
      print('Error fetching steps: $e');
      return [];
    }
  }

  /// Fetch heart rate data with resting heart rate calculation
  Future<List<int>> _fetchHeartRate(DateTime start, DateTime end) async {
    try {
      final heartRate = await _health.getHealthDataFromTypes(start, end, [HealthDataType.HEART_RATE]);
      return heartRate.map((e) => (e.value as double).round()).toList();
    } catch (e) {
      print('Error fetching heart rate: $e');
      return [];
    }
  }

  /// Fetch resting heart rate specifically
  Future<int?> _fetchRestingHeartRate(DateTime start, DateTime end) async {
    try {
      final restingHR = await _health.getHealthDataFromTypes(start, end, [HealthDataType.RESTING_HEART_RATE]);
      if (restingHR.isNotEmpty) {
        return (restingHR.last.value as double).round();
      }
      return null;
    } catch (e) {
      print('Error fetching resting heart rate: $e');
      return null;
    }
  }



  /// Fetch active energy burned
  Future<int?> _fetchActiveEnergyBurned(DateTime start, DateTime end) async {
    try {
      final energyData = await _health.getHealthDataFromTypes(start, end, [HealthDataType.ACTIVE_ENERGY_BURNED]);
      if (energyData.isNotEmpty) {
        // Calculate daily average
        final totalEnergy = energyData.fold<int>(0, (sum, e) => sum + (e.value as int));
        return (totalEnergy / 30).round(); // 30 days average
      }
      return null;
    } catch (e) {
      print('Error fetching active energy burned: $e');
      return null;
    }
  }

  /// Fetch sleep hours with improved calculation
  Future<List<double>> _fetchSleepHours(DateTime start, DateTime end) async {
    try {
      final sleepData = await _health.getHealthDataFromTypes(
        start, 
        end, 
        [HealthDataType.SLEEP_IN_BED, HealthDataType.SLEEP_ASLEEP]
      );
      
      // Calculate sleep hours from sleep data
      final sleepHours = sleepData.map((e) {
        final duration = e.dateTo.difference(e.dateFrom);
        return duration.inMinutes / 60.0;
      }).toList();
      
      return sleepHours;
    } catch (e) {
      print('Error fetching sleep data: $e');
      return [];
    }
  }

  /// Fetch workout data with enhanced analysis
  Future<List<WorkoutSession>> _fetchWorkouts(DateTime start, DateTime end) async {
    try {
      final workouts = await _health.getHealthDataFromTypes(start, end, [HealthDataType.WORKOUT]);
      
      return workouts.map((e) {
        final duration = e.dateTo.difference(e.dateFrom);
        // Estimate calories burned based on workout type and duration
        final caloriesBurned = _estimateCaloriesBurned(e.value.toString(), duration.inMinutes);
        
        return WorkoutSession(
          date: e.dateFrom,
          duration: duration.inMinutes,
          caloriesBurned: caloriesBurned,
          workoutType: e.value.toString(),
        );
      }).toList();
    } catch (e) {
      print('Error fetching workouts: $e');
      return [];
    }
  }

  /// Fetch weight history with trend analysis
  Future<List<WeightEntry>> _fetchWeightHistory(DateTime start, DateTime end) async {
    try {
      final weightData = await _health.getHealthDataFromTypes(start, end, [HealthDataType.WEIGHT]);
      
      return weightData.map((e) => WeightEntry(
        date: e.dateFrom,
        weightKg: e.value as double,
      )).toList();
    } catch (e) {
      print('Error fetching weight data: $e');
      return [];
    }
  }

  /// Fetch height data
  Future<int?> _fetchHeight() async {
    try {
      final now = DateTime.now();
      final heightData = await _health.getHealthDataFromTypes(
        now.subtract(const Duration(days: 365)), 
        now, 
        [HealthDataType.HEIGHT]
      );
      
      if (heightData.isNotEmpty) {
        // Convert height to cm (assuming it's in meters)
        final heightInMeters = heightData.last.value as double?;
        if (heightInMeters != null) {
          return (heightInMeters * 100).round();
        }
      }
      return null;
    } catch (e) {
      print('Error fetching height data: $e');
      return null;
    }
  }

  /// Enhanced calorie estimation based on workout type and duration
  int _estimateCaloriesBurned(String workoutType, int durationMinutes) {
    // More sophisticated calorie estimation based on workout intensity
    final baseCaloriesPerMinute = {
      'running': 12,
      'walking': 4,
      'cycling': 8,
      'swimming': 9,
      'strength_training': 6,
      'yoga': 3,
      'dancing': 7,
      'hiking': 6,
      'rowing': 10,
      'elliptical': 8,
      'stair_climbing': 9,
      'boxing': 11,
      'martial_arts': 10,
      'pilates': 4,
      'crossfit': 12,
      'hiit': 13,
    };

    final caloriesPerMinute = baseCaloriesPerMinute[workoutType.toLowerCase()] ?? 5;
    return caloriesPerMinute * durationMinutes;
  }

  /// Check if specific permissions are granted
  Future<bool> checkPermissions() async {
    try {
      final types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.WEIGHT,
        HealthDataType.HEIGHT,
      ];

      // Try to request permissions and see if they're granted
      final granted = await _health.requestAuthorization(types);
      return granted;
    } catch (e) {
      print('Error checking permissions: $e');
      return false;
    }
  }

  /// Get health data summary for quick assessment
  Future<Map<String, dynamic>> getHealthSummary() async {
    try {
      final healthData = await fetchHealthData();
      if (healthData == null) return {};

      return {
        'hasStepsData': healthData.averageSteps != null,
        'hasHeartRateData': healthData.averageHeartRate != null,
        'hasWorkoutData': healthData.workoutHistory?.isNotEmpty ?? false,
        'hasWeightData': healthData.weightHistory?.isNotEmpty ?? false,
        'hasHeightData': healthData.height != null,
        'averageSteps': healthData.averageSteps,
        'averageHeartRate': healthData.averageHeartRate,
        'workoutCount': healthData.workoutHistory?.length ?? 0,
        'dataQuality': _assessDataQuality(healthData),
      };
    } catch (e) {
      print('Error getting health summary: $e');
      return {};
    }
  }

  /// Assess the quality of health data
  String _assessDataQuality(HealthKitData healthData) {
    int dataPoints = 0;
    int totalPoints = 0;

    if (healthData.averageSteps != null) dataPoints++;
    totalPoints++;

    if (healthData.averageHeartRate != null) dataPoints++;
    totalPoints++;

    if (healthData.workoutHistory?.isNotEmpty ?? false) dataPoints++;
    totalPoints++;

    if (healthData.weightHistory?.isNotEmpty ?? false) dataPoints++;
    totalPoints++;

    if (healthData.height != null) dataPoints++;
    totalPoints++;

    final quality = dataPoints / totalPoints;
    if (quality >= 0.8) return 'Excellent';
    if (quality >= 0.6) return 'Good';
    if (quality >= 0.4) return 'Fair';
    return 'Poor';
  }
} 