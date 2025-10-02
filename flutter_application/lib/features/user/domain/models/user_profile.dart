import 'package:equatable/equatable.dart';

enum FitnessLevel { beginner, intermediate, advanced }

enum Gender { male, female, other, preferNotToSay }

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.email,
    this.name,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.fitnessLevel,
    this.goal,
    this.gymAccess = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String email;
  final String? name;
  final int? age;
  final Gender? gender;
  final int? heightCm;
  final int? weightKg;
  final FitnessLevel? fitnessLevel;
  final String? goal;
  final bool gymAccess;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isProfileComplete {
    return name != null &&
        age != null &&
        gender != null &&
        heightCm != null &&
        weightKg != null &&
        fitnessLevel != null &&
        goal != null;
  }

  double? get bmi {
    if (heightCm == null || weightKg == null) return null;
    final heightM = heightCm! / 100;
    return weightKg! / (heightM * heightM);
  }

  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;

    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal weight';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? name,
    int? age,
    Gender? gender,
    int? heightCm,
    int? weightKg,
    FitnessLevel? fitnessLevel,
    String? goal,
    bool? gymAccess,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      goal: goal ?? this.goal,
      gymAccess: gymAccess ?? this.gymAccess,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        age,
        gender,
        heightCm,
        weightKg,
        fitnessLevel,
        goal,
        gymAccess,
        createdAt,
        updatedAt,
      ];
}
