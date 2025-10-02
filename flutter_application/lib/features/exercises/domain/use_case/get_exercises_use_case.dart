import 'package:equatable/equatable.dart';
import '../models/exercise.dart';
import '../repository/exercise_repository.dart';

class GetExercisesUseCase {
  final ExerciseRepository _repository;

  GetExercisesUseCase(this._repository);

  Future<List<Exercise>> call() async {
    try {
      return await _repository.getAllExercises();
    } catch (e) {
      throw ExerciseException('Failed to fetch exercises: $e');
    }
  }
}

class GetExercisesByCategoryUseCase {
  final ExerciseRepository _repository;

  GetExercisesByCategoryUseCase(this._repository);

  Future<List<Exercise>> call(String category) async {
    try {
      return await _repository.getExercisesByCategory(category);
    } catch (e) {
      throw ExerciseException('Failed to fetch exercises by category: $e');
    }
  }
}

class GetExercisesByDifficultyUseCase {
  final ExerciseRepository _repository;

  GetExercisesByDifficultyUseCase(this._repository);

  Future<List<Exercise>> call(String difficulty) async {
    try {
      return await _repository.getExercisesByDifficulty(difficulty);
    } catch (e) {
      throw ExerciseException('Failed to fetch exercises by difficulty: $e');
    }
  }
}

class SearchExercisesUseCase {
  final ExerciseRepository _repository;

  SearchExercisesUseCase(this._repository);

  Future<List<Exercise>> call(String query) async {
    try {
      if (query.trim().isEmpty) {
        return await _repository.getAllExercises();
      }
      return await _repository.searchExercises(query.trim());
    } catch (e) {
      throw ExerciseException('Failed to search exercises: $e');
    }
  }
}

class GetRandomExercisesUseCase {
  final ExerciseRepository _repository;

  GetRandomExercisesUseCase(this._repository);

  Future<List<Exercise>> call({
    required int count,
    String? category,
    String? difficulty,
    String? equipment,
  }) async {
    try {
      return await _repository.getRandomExercises(
        count: count,
        category: category,
        difficulty: difficulty,
        equipment: equipment,
      );
    } catch (e) {
      throw ExerciseException('Failed to fetch random exercises: $e');
    }
  }
}

class GetExerciseStatisticsUseCase {
  final ExerciseRepository _repository;

  GetExerciseStatisticsUseCase(this._repository);

  Future<ExerciseStatistics> call() async {
    try {
      return await _repository.getExerciseStatistics();
    } catch (e) {
      throw ExerciseException('Failed to fetch exercise statistics: $e');
    }
  }
}

class ExerciseException extends Equatable implements Exception {
  final String message;

  const ExerciseException(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'ExerciseException: $message';
}












