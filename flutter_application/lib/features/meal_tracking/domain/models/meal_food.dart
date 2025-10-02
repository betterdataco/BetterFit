import 'package:equatable/equatable.dart';

enum UnitType {
  grams,
  ounces,
  cups,
  tablespoons,
  teaspoons,
  pieces,
  slices,
}

class MealFood extends Equatable {
  final String id;
  final String mealId;
  final String foodName;
  final String? usdaFdcId;
  final double quantity;
  final UnitType unit;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sodium;
  final DateTime createdAt;

  const MealFood({
    required this.id,
    required this.mealId,
    required this.foodName,
    this.usdaFdcId,
    required this.quantity,
    required this.unit,
    this.calories = 0,
    this.protein = 0.0,
    this.carbs = 0.0,
    this.fat = 0.0,
    this.fiber = 0.0,
    this.sodium = 0.0,
    required this.createdAt,
  });

  MealFood copyWith({
    String? id,
    String? mealId,
    String? foodName,
    String? usdaFdcId,
    double? quantity,
    UnitType? unit,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    double? sodium,
    DateTime? createdAt,
  }) {
    return MealFood(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      foodName: foodName ?? this.foodName,
      usdaFdcId: usdaFdcId ?? this.usdaFdcId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      sodium: sodium ?? this.sodium,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meal_id': mealId,
      'food_name': foodName,
      'usda_fdc_id': usdaFdcId,
      'quantity': quantity,
      'unit': unit.name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sodium': sodium,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MealFood.fromJson(Map<String, dynamic> json) {
    return MealFood(
      id: json['id'],
      mealId: json['meal_id'],
      foodName: json['food_name'],
      usdaFdcId: json['usda_fdc_id'],
      quantity: (json['quantity'] ?? 0.0).toDouble(),
      unit: UnitType.values.firstWhere(
        (e) => e.name == json['unit'],
      ),
      calories: json['calories'] ?? 0,
      protein: (json['protein'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      fat: (json['fat'] ?? 0.0).toDouble(),
      fiber: (json['fiber'] ?? 0.0).toDouble(),
      sodium: (json['sodium'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    mealId,
    foodName,
    usdaFdcId,
    quantity,
    unit,
    calories,
    protein,
    carbs,
    fat,
    fiber,
    sodium,
    createdAt,
  ];
} 