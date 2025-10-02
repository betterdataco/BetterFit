import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/meal.dart';
import '../../domain/models/meal_food.dart';
import '../../domain/models/nutrition_goals.dart';
import '../../domain/models/food_search_result.dart';
import '../../domain/repository/meal_tracking_repository.dart';
import '../services/fda_food_data_service.dart';

@Injectable(as: MealTrackingRepository)
class SupabaseMealTrackingRepository implements MealTrackingRepository {
  final SupabaseClient _supabase;

  SupabaseMealTrackingRepository(this._supabase);

  @override
  Future<List<Meal>> getMealsForDate(DateTime date) async {
    final dateStr = date.toIso8601String().split('T')[0];

    final response = await _supabase.from('meals').select('''
          *,
          meal_foods (*)
        ''').eq('meal_date', dateStr).order('meal_time', ascending: true);

    return (response as List).map((json) => Meal.fromJson(json)).toList();
  }

  @override
  Future<Meal> createMeal(Meal meal) async {
    final response =
        await _supabase.from('meals').insert(meal.toJson()).select().single();

    return Meal.fromJson(response);
  }

  @override
  Future<Meal> updateMeal(Meal meal) async {
    final response = await _supabase
        .from('meals')
        .update(meal.toJson())
        .eq('id', meal.id)
        .select()
        .single();

    return Meal.fromJson(response);
  }

  @override
  Future<void> deleteMeal(String mealId) async {
    await _supabase.from('meals').delete().eq('id', mealId);
  }

  @override
  Future<MealFood> addFoodToMeal(MealFood mealFood) async {
    final response = await _supabase
        .from('meal_foods')
        .insert(mealFood.toJson())
        .select()
        .single();

    return MealFood.fromJson(response);
  }

  @override
  Future<MealFood> updateMealFood(MealFood mealFood) async {
    final response = await _supabase
        .from('meal_foods')
        .update(mealFood.toJson())
        .eq('id', mealFood.id)
        .select()
        .single();

    return MealFood.fromJson(response);
  }

  @override
  Future<void> removeFoodFromMeal(String mealFoodId) async {
    await _supabase.from('meal_foods').delete().eq('id', mealFoodId);
  }

  @override
  Future<NutritionGoals> getNutritionGoals() async {
    final response =
        await _supabase.from('user_nutrition_goals').select().single();

    return NutritionGoals.fromJson(response);
  }

  @override
  Future<NutritionGoals> updateNutritionGoals(NutritionGoals goals) async {
    final response = await _supabase
        .from('user_nutrition_goals')
        .update(goals.toJson())
        .eq('id', goals.id)
        .select()
        .single();

    return NutritionGoals.fromJson(response);
  }

  @override
  Future<Map<String, dynamic>> getWeeklyNutritionSummary(
      DateTime weekStart) async {
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekStartStr = weekStart.toIso8601String().split('T')[0];
    final weekEndStr = weekEnd.toIso8601String().split('T')[0];

    final response = await _supabase
        .from('meals')
        .select('''
          *,
          meal_foods (*)
        ''')
        .gte('meal_date', weekStartStr)
        .lte('meal_date', weekEndStr)
        .order('meal_date', ascending: true);

    final meals =
        (response as List).map((json) => Meal.fromJson(json)).toList();

    // Calculate weekly totals
    int totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;
    double totalFiber = 0;
    double totalSodium = 0;
    int daysTracked = 0;
    Set<String> trackedDates = {};

    for (final meal in meals) {
      totalCalories += meal.totalCalories;
      totalProtein += meal.totalProtein;
      totalCarbs += meal.totalCarbs;
      totalFat += meal.totalFat;
      totalFiber += meal.totalFiber;
      totalSodium += meal.totalSodium;
      trackedDates.add(meal.mealDate.toIso8601String().split('T')[0]);
    }

    daysTracked = trackedDates.length;

    return {
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFat': totalFat,
      'totalFiber': totalFiber,
      'totalSodium': totalSodium,
      'daysTracked': daysTracked,
      'avgCalories':
          daysTracked > 0 ? (totalCalories / daysTracked).round() : 0,
      'avgProtein': daysTracked > 0 ? totalProtein / daysTracked : 0,
      'avgCarbs': daysTracked > 0 ? totalCarbs / daysTracked : 0,
      'avgFat': daysTracked > 0 ? totalFat / daysTracked : 0,
      'meals': meals,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> searchUsdaFoods(String query) async {
    // For now, return mock data. Later we'll integrate with USDA API
    return [
      {
        'fdcId': '123456',
        'description': 'Chicken breast, raw',
        'brandOwner': 'Generic',
        'calories': 165,
        'protein': 31.0,
        'carbs': 0.0,
        'fat': 3.6,
        'fiber': 0.0,
        'sodium': 74.0,
      },
      {
        'fdcId': '789012',
        'description': 'Brown rice, cooked',
        'brandOwner': 'Generic',
        'calories': 111,
        'protein': 2.6,
        'carbs': 23.0,
        'fat': 0.9,
        'fiber': 1.8,
        'sodium': 5.0,
      },
      {
        'fdcId': '345678',
        'description': 'Broccoli, raw',
        'brandOwner': 'Generic',
        'calories': 34,
        'protein': 2.8,
        'carbs': 7.0,
        'fat': 0.4,
        'fiber': 2.6,
        'sodium': 33.0,
      },
    ]
        .where((food) => food['description']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<FoodSearchResult>> searchFoods(String query) async {
    try {
      return await FdaFoodDataService.searchFoods(query);
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockFoodSearchResults(query);
    }
  }

  @override
  Future<FoodSearchResult> getFoodDetails(String fdcId) async {
    try {
      return await FdaFoodDataService.getFoodDetails(fdcId);
    } catch (e) {
      throw Exception('Failed to get food details: $e');
    }
  }

  @override
  Future<List<FoodSearchResult>> getFoodsByIds(List<String> fdcIds) async {
    try {
      return await FdaFoodDataService.getFoodsByIds(fdcIds);
    } catch (e) {
      throw Exception('Failed to get foods by IDs: $e');
    }
  }

  @override
  Future<Map<String, double>> extractNutritionValues(
      FoodSearchResult food) async {
    return FdaFoodDataService.extractNutritionValues(food);
  }

  List<FoodSearchResult> _getMockFoodSearchResults(String query) {
    final mockFoods = [
      const FoodSearchResult(
        fdcId: '123456',
        description: 'Chicken breast, raw',
        brandName: 'Generic',
        nutrients: [
          FoodNutrient(
              nutrientId: 1008,
              nutrientName: 'Energy',
              unitName: 'KCAL',
              value: 165),
          FoodNutrient(
              nutrientId: 1003,
              nutrientName: 'Protein',
              unitName: 'G',
              value: 31.0),
          FoodNutrient(
              nutrientId: 1005,
              nutrientName: 'Carbohydrate, by difference',
              unitName: 'G',
              value: 0.0),
          FoodNutrient(
              nutrientId: 1004,
              nutrientName: 'Total lipid (fat)',
              unitName: 'G',
              value: 3.6),
          FoodNutrient(
              nutrientId: 1079,
              nutrientName: 'Fiber, total dietary',
              unitName: 'G',
              value: 0.0),
          FoodNutrient(
              nutrientId: 1093,
              nutrientName: 'Sodium, Na',
              unitName: 'MG',
              value: 74.0),
        ],
      ),
      const FoodSearchResult(
        fdcId: '789012',
        description: 'Brown rice, cooked',
        brandName: 'Generic',
        nutrients: [
          FoodNutrient(
              nutrientId: 1008,
              nutrientName: 'Energy',
              unitName: 'KCAL',
              value: 111),
          FoodNutrient(
              nutrientId: 1003,
              nutrientName: 'Protein',
              unitName: 'G',
              value: 2.6),
          FoodNutrient(
              nutrientId: 1005,
              nutrientName: 'Carbohydrate, by difference',
              unitName: 'G',
              value: 23.0),
          FoodNutrient(
              nutrientId: 1004,
              nutrientName: 'Total lipid (fat)',
              unitName: 'G',
              value: 0.9),
          FoodNutrient(
              nutrientId: 1079,
              nutrientName: 'Fiber, total dietary',
              unitName: 'G',
              value: 1.8),
          FoodNutrient(
              nutrientId: 1093,
              nutrientName: 'Sodium, Na',
              unitName: 'MG',
              value: 5.0),
        ],
      ),
      const FoodSearchResult(
        fdcId: '345678',
        description: 'Broccoli, raw',
        brandName: 'Generic',
        nutrients: [
          FoodNutrient(
              nutrientId: 1008,
              nutrientName: 'Energy',
              unitName: 'KCAL',
              value: 34),
          FoodNutrient(
              nutrientId: 1003,
              nutrientName: 'Protein',
              unitName: 'G',
              value: 2.8),
          FoodNutrient(
              nutrientId: 1005,
              nutrientName: 'Carbohydrate, by difference',
              unitName: 'G',
              value: 7.0),
          FoodNutrient(
              nutrientId: 1004,
              nutrientName: 'Total lipid (fat)',
              unitName: 'G',
              value: 0.4),
          FoodNutrient(
              nutrientId: 1079,
              nutrientName: 'Fiber, total dietary',
              unitName: 'G',
              value: 2.6),
          FoodNutrient(
              nutrientId: 1093,
              nutrientName: 'Sodium, Na',
              unitName: 'MG',
              value: 33.0),
        ],
      ),
      const FoodSearchResult(
        fdcId: '456789',
        description: 'Apple, raw, with skin',
        brandName: 'Generic',
        nutrients: [
          FoodNutrient(
              nutrientId: 1008,
              nutrientName: 'Energy',
              unitName: 'KCAL',
              value: 52),
          FoodNutrient(
              nutrientId: 1003,
              nutrientName: 'Protein',
              unitName: 'G',
              value: 0.3),
          FoodNutrient(
              nutrientId: 1005,
              nutrientName: 'Carbohydrate, by difference',
              unitName: 'G',
              value: 14.0),
          FoodNutrient(
              nutrientId: 1004,
              nutrientName: 'Total lipid (fat)',
              unitName: 'G',
              value: 0.2),
          FoodNutrient(
              nutrientId: 1079,
              nutrientName: 'Fiber, total dietary',
              unitName: 'G',
              value: 2.4),
          FoodNutrient(
              nutrientId: 1093,
              nutrientName: 'Sodium, Na',
              unitName: 'MG',
              value: 1.0),
        ],
      ),
    ];

    return mockFoods
        .where((food) =>
            food.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
