class Workout {
  final String name;
  final String duration;
  final List<Exercise> exercises;

  const Workout({
    required this.name,
    required this.duration,
    required this.exercises,
  });
}

class Exercise {
  final String name;
  final int sets;
  final int reps;

  const Exercise({
    required this.name,
    required this.sets,
    required this.reps,
  });
} 