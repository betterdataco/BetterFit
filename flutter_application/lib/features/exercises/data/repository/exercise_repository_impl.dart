import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/exercise.dart';
import '../../domain/repository/exercise_repository.dart';

class ExerciseRepositoryImpl implements ExerciseRepository {
  final SupabaseClient _supabaseClient;

  ExerciseRepositoryImpl(this._supabaseClient);

  @override
  Future<List<Exercise>> getAllExercises() async {
    try {
      final response = await _supabaseClient
          .from('exercises')
          .select()
          .order('name');

      return response.map((json) => Exercise.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch exercises: $e');
    }
  }

  @override
  Future<List<Exercise>> getExercisesByCategory(String category) async {
    try {
      final response = await _supabaseClient
          .from('exercises')
          .select()
          .eq('category', category.toLowerCase())
          .order('name');

      return response.map((json) => Exercise.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch exercises by category: $e');
    }
  }

  @override
  Future<List<Exercise>> getExercisesByMuscleGroup(String muscleGroup) async {
    try {
      final response = await _supabaseClient
          .from('exercises')
          .select()
          .eq('muscle_group', muscleGroup.toLowerCase())
          .order('name');

      return response.map((json) => Exercise.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch exercises by muscle group: $e');
    }
  }

  @override
  Future<List<Exercise>> getExercisesByDifficulty(String difficulty) async {
    try {
      final response = await _supabaseClient
          .from('exercises')
          .select()
          .eq('difficulty', difficulty.toLowerCase())
          .order('name');

      return response.map((json) => Exercise.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch exercises by difficulty: $e');
    }
  }

  @override
  Future<List<Exercise>> getExercisesByEquipment(String equipment) async {
    try {
      final response = await _supabaseClient
          .from('exercises')
          .select()
          .eq('equipment', equipment.toLowerCase())
          .order('name');

      return response.map((json) => Exercise.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch exercises by equipment: $e');
    }
  }

  @override
  Future<Exercise?> getExerciseById(int id) async {
    try {
      final response = await _supabaseClient
          .from('exercises')
          .select()
          .eq('id', id)
          .single();

      return Exercise.fromJson(response);
    } catch (e) {
      if (e is PostgrestException && e.code == 'PGRST116') {
        return null; // No exercise found
      }
      throw Exception('Failed to fetch exercise by ID: $e');
    }
  }

  @override
  Future<List<Exercise>> searchExercises(String query) async {
    try {
      final response = await _supabaseClient
          .from('exercises')
          .select()
          .or('name.ilike.%$query%,instructions.ilike.%$query%')
          .order('name');

      return response.map((json) => Exercise.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to search exercises: $e');
    }
  }

  @override
  Future<List<Exercise>> getExercisesForWorkoutType(String workoutType) async {
    try {
      // Map workout types to appropriate categories
      String category;
      switch (workoutType.toLowerCase()) {
        case 'strength':
        case 'weightlifting':
          category = 'strength';
          break;
        case 'cardio':
        case 'hiit':
          category = 'cardio';
          break;
        case 'core':
        case 'abs':
          category = 'core';
          break;
        case 'plyometric':
        case 'jump':
          category = 'plyometric';
          break;
        default:
          category = 'strength'; // Default to strength
      }

      return await getExercisesByCategory(category);
    } catch (e) {
      throw Exception('Failed to fetch exercises for workout type: $e');
    }
  }

  @override
  Future<List<Exercise>> getRandomExercises({
    required int count,
    String? category,
    String? difficulty,
    String? equipment,
  }) async {
    try {
      var query = _supabaseClient.from('exercises').select();

      if (category != null) {
        query = query.eq('category', category.toLowerCase());
      }
      if (difficulty != null) {
        query = query.eq('difficulty', difficulty.toLowerCase());
      }
      if (equipment != null) {
        query = query.eq('equipment', equipment.toLowerCase());
      }

      final response = await query;
      final exercises = response.map((json) => Exercise.fromJson(json)).toList();

      // Shuffle and take the requested count
      exercises.shuffle(Random());
      return exercises.take(count).toList();
    } catch (e) {
      throw Exception('Failed to fetch random exercises: $e');
    }
  }

  @override
  Future<ExerciseStatistics> getExerciseStatistics() async {
    try {
      // Get all exercises to calculate statistics
      final allExercises = await getAllExercises();
      final totalExercises = allExercises.length;

      // Get statistics from views
      final categoryStats = await _supabaseClient
          .from('exercises_by_category')
          .select();

      final difficultyStats = await _supabaseClient
          .from('exercises_by_difficulty')
          .select();
      
      final exercisesByCategory = <String, int>{};
      for (final stat in categoryStats) {
        exercisesByCategory[stat['category']] = stat['exercise_count'];
      }

      final exercisesByDifficulty = <String, int>{};
      for (final stat in difficultyStats) {
        exercisesByDifficulty[stat['difficulty']] = stat['exercise_count'];
      }

      // Get equipment stats
      final equipmentResponse = await _supabaseClient
          .from('exercises')
          .select('equipment');
      
      final exercisesByEquipment = <String, int>{};
      for (final exercise in equipmentResponse) {
        final equipment = exercise['equipment'] as String;
        exercisesByEquipment[equipment] = (exercisesByEquipment[equipment] ?? 0) + 1;
      }

      // Get muscle group stats
      final muscleGroupResponse = await _supabaseClient
          .from('exercises')
          .select('muscle_group');
      
      final exercisesByMuscleGroup = <String, int>{};
      for (final exercise in muscleGroupResponse) {
        final muscleGroup = exercise['muscle_group'] as String;
        exercisesByMuscleGroup[muscleGroup] = (exercisesByMuscleGroup[muscleGroup] ?? 0) + 1;
      }

      // Calculate average calories burned
      final caloriesResponse = await _supabaseClient
          .from('exercises')
          .select('calories_burned');
      
      final totalCalories = caloriesResponse
          .map((e) => e['calories_burned'] as int)
          .reduce((a, b) => a + b);
      
      final averageCaloriesBurned = totalCalories / totalExercises;

      return ExerciseStatistics(
        totalExercises: totalExercises,
        exercisesByCategory: exercisesByCategory,
        exercisesByDifficulty: exercisesByDifficulty,
        exercisesByMuscleGroup: exercisesByMuscleGroup,
        exercisesByEquipment: exercisesByEquipment,
        averageCaloriesBurned: averageCaloriesBurned,
      );
    } catch (e) {
      throw Exception('Failed to fetch exercise statistics: $e');
    }
  }
}
