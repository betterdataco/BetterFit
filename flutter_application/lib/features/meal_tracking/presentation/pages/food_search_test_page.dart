import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/food_search_widget.dart';
import '../../domain/models/meal.dart';
import '../../../../core/constants/colors.dart';

class FoodSearchTestPage extends StatelessWidget {
  const FoodSearchTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Food Search Test',
          style: TextStyle(color: AppColors.text),
        ),
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'FDA FoodData Central API Test',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Search for foods using the FDA FoodData Central API',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: FoodSearchWidget(
                mealType: MealType.breakfast,
                onFoodSelected: (mealFood) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('✅ Added ${mealFood.foodName} to your meal!'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
