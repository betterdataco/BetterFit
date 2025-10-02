class Meal {
  final String name;
  final int calories;
  final String time;
  final MacroNutrients macros;

  const Meal({
    required this.name,
    required this.calories,
    required this.time,
    required this.macros,
  });
}

class MacroNutrients {
  final int protein;
  final int carbs;
  final int fat;

  const MacroNutrients({
    required this.protein,
    required this.carbs,
    required this.fat,
  });
} 