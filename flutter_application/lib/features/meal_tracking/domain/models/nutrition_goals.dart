import 'package:equatable/equatable.dart';

class NutritionGoals extends Equatable {
  final String id;
  final String userId;
  final int dailyCalories;
  final double dailyProtein;
  final double dailyCarbs;
  final double dailyFat;
  final double dailyFiber;
  final double dailySodium;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NutritionGoals({
    required this.id,
    required this.userId,
    this.dailyCalories = 2000,
    this.dailyProtein = 150.0,
    this.dailyCarbs = 250.0,
    this.dailyFat = 65.0,
    this.dailyFiber = 25.0,
    this.dailySodium = 2300.0,
    required this.createdAt,
    required this.updatedAt,
  });

  NutritionGoals copyWith({
    String? id,
    String? userId,
    int? dailyCalories,
    double? dailyProtein,
    double? dailyCarbs,
    double? dailyFat,
    double? dailyFiber,
    double? dailySodium,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NutritionGoals(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      dailyProtein: dailyProtein ?? this.dailyProtein,
      dailyCarbs: dailyCarbs ?? this.dailyCarbs,
      dailyFat: dailyFat ?? this.dailyFat,
      dailyFiber: dailyFiber ?? this.dailyFiber,
      dailySodium: dailySodium ?? this.dailySodium,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'daily_calories': dailyCalories,
      'daily_protein': dailyProtein,
      'daily_carbs': dailyCarbs,
      'daily_fat': dailyFat,
      'daily_fiber': dailyFiber,
      'daily_sodium': dailySodium,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory NutritionGoals.fromJson(Map<String, dynamic> json) {
    return NutritionGoals(
      id: json['id'],
      userId: json['user_id'],
      dailyCalories: json['daily_calories'] ?? 2000,
      dailyProtein: (json['daily_protein'] ?? 150.0).toDouble(),
      dailyCarbs: (json['daily_carbs'] ?? 250.0).toDouble(),
      dailyFat: (json['daily_fat'] ?? 65.0).toDouble(),
      dailyFiber: (json['daily_fiber'] ?? 25.0).toDouble(),
      dailySodium: (json['daily_sodium'] ?? 2300.0).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    dailyCalories,
    dailyProtein,
    dailyCarbs,
    dailyFat,
    dailyFiber,
    dailySodium,
    createdAt,
    updatedAt,
  ];
} 