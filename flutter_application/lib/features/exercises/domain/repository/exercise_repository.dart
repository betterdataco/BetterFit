import 'package:equatable/equatable.dart';
import '../models/exercise.dart';

abstract class ExerciseRepository {
  /// Get all exercises
  Future<List<Exercise>> getAllExercises();

  /// Get exercises by category
  Future<List<Exercise>> getExercisesByCategory(String category);

  /// Get exercises by muscle group
  Future<List<Exercise>> getExercisesByMuscleGroup(String muscleGroup);

  /// Get exercises by difficulty level
  Future<List<Exercise>> getExercisesByDifficulty(String difficulty);

  /// Get exercises by equipment type
  Future<List<Exercise>> getExercisesByEquipment(String equipment);

  /// Get exercise by ID
  Future<Exercise?> getExerciseById(int id);

  /// Search exercises by name
  Future<List<Exercise>> searchExercises(String query);

  /// Get exercises for a specific workout type
  Future<List<Exercise>> getExercisesForWorkoutType(String workoutType);

  /// Get random exercises for a quick workout
  Future<List<Exercise>> getRandomExercises({
    required int count,
    String? category,
    String? difficulty,
    String? equipment,
  });

  /// Get exercise statistics
  Future<ExerciseStatistics> getExerciseStatistics();
}

class ExerciseStatistics extends Equatable {
  final int totalExercises;
  final Map<String, int> exercisesByCategory;
  final Map<String, int> exercisesByDifficulty;
  final Map<String, int> exercisesByMuscleGroup;
  final Map<String, int> exercisesByEquipment;
  final double averageCaloriesBurned;

  const ExerciseStatistics({
    required this.totalExercises,
    required this.exercisesByCategory,
    required this.exercisesByDifficulty,
    required this.exercisesByMuscleGroup,
    required this.exercisesByEquipment,
    required this.averageCaloriesBurned,
  });

  @override
  List<Object?> get props => [
        totalExercises,
        exercisesByCategory,
        exercisesByDifficulty,
        exercisesByMuscleGroup,
        exercisesByEquipment,
        averageCaloriesBurned,
      ];
}
