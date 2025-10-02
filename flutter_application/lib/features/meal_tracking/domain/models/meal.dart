import 'package:equatable/equatable.dart';
import 'meal_food.dart';

enum MealType {
  breakfast,
  lunch,
  dinner,
  snack,
}

class Meal extends Equatable {
  final String id;
  final String userId;
  final MealType mealType;
  final DateTime mealDate;
  final DateTime? mealTime;
  final int totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final double totalFiber;
  final double totalSodium;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MealFood> foods;

  const Meal({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.mealDate,
    this.mealTime,
    this.totalCalories = 0,
    this.totalProtein = 0.0,
    this.totalCarbs = 0.0,
    this.totalFat = 0.0,
    this.totalFiber = 0.0,
    this.totalSodium = 0.0,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.foods = const [],
  });

  Meal copyWith({
    String? id,
    String? userId,
    MealType? mealType,
    DateTime? mealDate,
    DateTime? mealTime,
    int? totalCalories,
    double? totalProtein,
    double? totalCarbs,
    double? totalFat,
    double? totalFiber,
    double? totalSodium,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MealFood>? foods,
  }) {
    return Meal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mealType: mealType ?? this.mealType,
      mealDate: mealDate ?? this.mealDate,
      mealTime: mealTime ?? this.mealTime,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProtein: totalProtein ?? this.totalProtein,
      totalCarbs: totalCarbs ?? this.totalCarbs,
      totalFat: totalFat ?? this.totalFat,
      totalFiber: totalFiber ?? this.totalFiber,
      totalSodium: totalSodium ?? this.totalSodium,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      foods: foods ?? this.foods,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'meal_type': mealType.name,
      'meal_date': mealDate.toIso8601String().split('T')[0],
      'meal_time': mealTime?.toIso8601String(),
      'total_calories': totalCalories,
      'total_protein': totalProtein,
      'total_carbs': totalCarbs,
      'total_fat': totalFat,
      'total_fiber': totalFiber,
      'total_sodium': totalSodium,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      userId: json['user_id'],
      mealType: MealType.values.firstWhere(
        (e) => e.name == json['meal_type'],
      ),
      mealDate: DateTime.parse(json['meal_date']),
      mealTime: json['meal_time'] != null 
        ? DateTime.parse(json['meal_time'])
        : null,
      totalCalories: json['total_calories'] ?? 0,
      totalProtein: (json['total_protein'] ?? 0.0).toDouble(),
      totalCarbs: (json['total_carbs'] ?? 0.0).toDouble(),
      totalFat: (json['total_fat'] ?? 0.0).toDouble(),
      totalFiber: (json['total_fiber'] ?? 0.0).toDouble(),
      totalSodium: (json['total_sodium'] ?? 0.0).toDouble(),
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      foods: json['foods'] != null 
        ? (json['foods'] as List).map((f) => MealFood.fromJson(f)).toList()
        : [],
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    mealType,
    mealDate,
    mealTime,
    totalCalories,
    totalProtein,
    totalCarbs,
    totalFat,
    totalFiber,
    totalSodium,
    notes,
    createdAt,
    updatedAt,
    foods,
  ];
} 