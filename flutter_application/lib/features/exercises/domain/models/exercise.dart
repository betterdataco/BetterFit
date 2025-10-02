import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  final int id;
  final String name;
  final String category;
  final String muscleGroup;
  final String equipment;
  final String difficulty;
  final String instructions;
  final int sets;
  final int reps;
  final int restTime; // in seconds
  final int caloriesBurned;
  final String? imageUrl;
  final String? videoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    required this.instructions,
    required this.sets,
    required this.reps,
    required this.restTime,
    required this.caloriesBurned,
    this.imageUrl,
    this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      muscleGroup: json['muscle_group'] as String,
      equipment: json['equipment'] as String,
      difficulty: json['difficulty'] as String,
      instructions: json['instructions'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      restTime: json['rest_time'] as int,
      caloriesBurned: json['calories_burned'] as int,
      imageUrl: json['image_url'] as String?,
      videoUrl: json['video_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'muscle_group': muscleGroup,
      'equipment': equipment,
      'difficulty': difficulty,
      'instructions': instructions,
      'sets': sets,
      'reps': reps,
      'rest_time': restTime,
      'calories_burned': caloriesBurned,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? category,
    String? muscleGroup,
    String? equipment,
    String? difficulty,
    String? instructions,
    int? sets,
    int? reps,
    int? restTime,
    int? caloriesBurned,
    String? imageUrl,
    String? videoUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      equipment: equipment ?? this.equipment,
      difficulty: difficulty ?? this.difficulty,
      instructions: instructions ?? this.instructions,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      restTime: restTime ?? this.restTime,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedRestTime {
    final minutes = restTime ~/ 60;
    final seconds = restTime % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  String get difficultyDisplay {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 'Beginner';
      case 'intermediate':
        return 'Intermediate';
      case 'advanced':
        return 'Advanced';
      default:
        return difficulty;
    }
  }

  String get categoryDisplay {
    switch (category.toLowerCase()) {
      case 'strength':
        return 'Strength';
      case 'cardio':
        return 'Cardio';
      case 'core':
        return 'Core';
      case 'plyometric':
        return 'Plyometric';
      default:
        return category;
    }
  }

  String get muscleGroupDisplay {
    switch (muscleGroup.toLowerCase()) {
      case 'chest':
        return 'Chest';
      case 'back':
        return 'Back';
      case 'legs':
        return 'Legs';
      case 'arms':
        return 'Arms';
      case 'shoulders':
        return 'Shoulders';
      case 'abs':
        return 'Abs';
      case 'full_body':
        return 'Full Body';
      default:
        return muscleGroup;
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        muscleGroup,
        equipment,
        difficulty,
        instructions,
        sets,
        reps,
        restTime,
        caloriesBurned,
        imageUrl,
        videoUrl,
        createdAt,
        updatedAt,
      ];
}
