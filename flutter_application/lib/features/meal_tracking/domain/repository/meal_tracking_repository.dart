import '../models/meal.dart';
import '../models/meal_food.dart';
import '../models/nutrition_goals.dart';
import '../models/food_search_result.dart';

abstract class MealTrackingRepository {
  // Meal operations
  Future<List<Meal>> getMealsForDate(DateTime date);
  Future<Meal> createMeal(Meal meal);
  Future<Meal> updateMeal(Meal meal);
  Future<void> deleteMeal(String mealId);

  // Meal food operations
  Future<MealFood> addFoodToMeal(MealFood mealFood);
  Future<MealFood> updateMealFood(MealFood mealFood);
  Future<void> removeFoodFromMeal(String mealFoodId);

  // Nutrition goals
  Future<NutritionGoals> getNutritionGoals();
  Future<NutritionGoals> updateNutritionGoals(NutritionGoals goals);

  // Weekly summaries
  Future<Map<String, dynamic>> getWeeklyNutritionSummary(DateTime weekStart);

  // FDA FoodData Central API
  Future<List<FoodSearchResult>> searchFoods(String query);
  Future<FoodSearchResult> getFoodDetails(String fdcId);
  Future<List<FoodSearchResult>> getFoodsByIds(List<String> fdcIds);
  Future<Map<String, double>> extractNutritionValues(FoodSearchResult food);
}
