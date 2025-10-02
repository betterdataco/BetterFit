import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/food_search_bloc.dart';
import '../../domain/models/food_search_result.dart';
import '../../domain/models/meal_food.dart';
import '../../domain/models/meal.dart';
import '../../../../core/constants/colors.dart';
import '../../../../dependency_injection.dart';

class FoodSearchWidget extends StatefulWidget {
  final Function(MealFood) onFoodSelected;
  final MealType mealType;

  const FoodSearchWidget({
    super.key,
    required this.onFoodSelected,
    required this.mealType,
  });

  @override
  State<FoodSearchWidget> createState() => _FoodSearchWidgetState();
}

class _FoodSearchWidgetState extends State<FoodSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FoodSearchBloc>(),
      child: Builder(
        builder: (context) {
          return BlocListener<FoodSearchBloc, FoodSearchState>(
            listener: (context, state) {
              if (state is FoodSearchError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Column(
              children: [
                _buildSearchBar(context),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<FoodSearchBloc, FoodSearchState>(
                    builder: (context, state) {
                      if (state is FoodSearchInitial) {
                        return _buildInitialState();
                      } else if (state is FoodSearchLoading) {
                        return _buildLoadingState();
                      } else if (state is FoodSearchLoaded) {
                        return _buildSearchResults(state.results);
                      } else if (state is FoodDetailsLoading) {
                        return _buildLoadingState();
                      } else if (state is FoodDetailsLoaded) {
                        return _buildFoodDetails(
                            state.food, state.nutritionValues);
                      } else if (state is FoodSearchError) {
                        return _buildErrorState(state.message);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.text),
        decoration: InputDecoration(
          hintText: 'Search for food...',
          hintStyle: const TextStyle(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    context
                        .read<FoodSearchBloc>()
                        .add(const FoodSearchCleared());
                  },
                )
              : null,
          border: InputBorder.none,
        ),
        onChanged: (query) {
          _debouncer.run(() {
            context.read<FoodSearchBloc>().add(FoodSearchRequested(query));
          });
        },
      ),
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16),
          Text(
            'Search for foods to add to your meal',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildSearchResults(List<FoodSearchResult> results) {
    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_food,
              size: 64,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No foods found',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final food = results[index];
        return _buildFoodItem(food);
      },
    );
  }

  Widget _buildFoodItem(FoodSearchResult food) {
    return Builder(
      builder: (context) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: AppColors.cardBackground,
          child: ListTile(
            title: Text(
              food.description,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: food.brandName != null
                ? Text(
                    food.brandName!,
                    style: const TextStyle(color: AppColors.textSecondary),
                  )
                : null,
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.textSecondary,
              size: 16,
            ),
            onTap: () {
              context
                  .read<FoodSearchBloc>()
                  .add(FoodDetailsRequested(food.fdcId));
            },
          ),
        );
      },
    );
  }

  Widget _buildFoodDetails(
      FoodSearchResult food, Map<String, double> nutrition) {
    return Builder(
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food header
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.text),
                    onPressed: () {
                      context
                          .read<FoodSearchBloc>()
                          .add(const FoodSearchCleared());
                    },
                  ),
                  Expanded(
                    child: Text(
                      food.description,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (food.brandName != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Brand: ${food.brandName}',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
              const SizedBox(height: 24),

              // Nutrition information
              const Text(
                'Nutrition Information (per 100g)',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _buildNutritionCard(nutrition),
              const SizedBox(height: 24),

              // Quantity selector
              _buildQuantitySelector(food, nutrition),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNutritionCard(Map<String, double> nutrition) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildNutritionRow('Calories',
              '${nutrition['calories']?.toStringAsFixed(0) ?? '0'} kcal'),
          _buildNutritionRow('Protein',
              '${nutrition['protein']?.toStringAsFixed(1) ?? '0.0'}g'),
          _buildNutritionRow(
              'Carbs', '${nutrition['carbs']?.toStringAsFixed(1) ?? '0.0'}g'),
          _buildNutritionRow(
              'Fat', '${nutrition['fat']?.toStringAsFixed(1) ?? '0.0'}g'),
          if (nutrition['fiber'] != null && nutrition['fiber']! > 0)
            _buildNutritionRow(
                'Fiber', '${nutrition['fiber']!.toStringAsFixed(1)}g'),
          if (nutrition['sodium'] != null && nutrition['sodium']! > 0)
            _buildNutritionRow(
                'Sodium', '${nutrition['sodium']!.toStringAsFixed(0)}mg'),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(
      FoodSearchResult food, Map<String, double> nutrition) {
    return StatefulBuilder(
      builder: (context, setState) {
        double quantity = 100.0; // Default to 100g
        UnitType unit = UnitType.grams;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quantity',
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: AppColors.text),
                    decoration: InputDecoration(
                      hintText: '100',
                      hintStyle:
                          const TextStyle(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.cardBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                    onChanged: (value) {
                      quantity = double.tryParse(value) ?? 100.0;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<UnitType>(
                  value: unit,
                  dropdownColor: AppColors.cardBackground,
                  style: const TextStyle(color: AppColors.text),
                  items: UnitType.values.map((unitType) {
                    return DropdownMenuItem(
                      value: unitType,
                      child: Text(unitType.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        unit = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print(
                      'FoodSearchWidget: Creating MealFood with quantity: $quantity ${unit.name}');
                  print('FoodSearchWidget: Nutrition values: $nutrition');

                  final mealFood = MealFood(
                    id: '', // Will be generated by Supabase
                    mealId: '', // Will be set when added to meal
                    foodName: food.description,
                    usdaFdcId: food.fdcId,
                    quantity: quantity,
                    unit: unit,
                    calories: ((nutrition['calories'] ?? 0) * (quantity / 100))
                        .round(),
                    protein: (nutrition['protein'] ?? 0) * (quantity / 100),
                    carbs: (nutrition['carbs'] ?? 0) * (quantity / 100),
                    fat: (nutrition['fat'] ?? 0) * (quantity / 100),
                    fiber: (nutrition['fiber'] ?? 0) * (quantity / 100),
                    sodium: (nutrition['sodium'] ?? 0) * (quantity / 100),
                    createdAt: DateTime.now(),
                  );

                  print(
                      'FoodSearchWidget: Created MealFood: ${mealFood.toJson()}');
                  widget.onFoodSelected(mealFood);
                  // Don't call Navigator.pop() here - let the parent widget handle closing the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add to Meal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Builder(
      builder: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              const Text(
                'Error loading foods',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.read<FoodSearchBloc>().add(const FoodSearchCleared());
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
