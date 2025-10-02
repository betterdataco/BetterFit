import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/models/food_search_result.dart';
import '../../domain/repository/meal_tracking_repository.dart';

part 'food_search_event.dart';
part 'food_search_state.dart';

@injectable
class FoodSearchBloc extends Bloc<FoodSearchEvent, FoodSearchState> {
  final MealTrackingRepository _repository;

  FoodSearchBloc(this._repository) : super(const FoodSearchInitial()) {
    on<FoodSearchRequested>(_onFoodSearchRequested);
    on<FoodDetailsRequested>(_onFoodDetailsRequested);
    on<FoodSearchCleared>(_onFoodSearchCleared);
  }

  Future<void> _onFoodSearchRequested(
    FoodSearchRequested event,
    Emitter<FoodSearchState> emit,
  ) async {
    if (event.query.trim().isEmpty) {
      emit(const FoodSearchInitial());
      return;
    }

    emit(const FoodSearchLoading());

    try {
      final results = await _repository.searchFoods(event.query);
      emit(FoodSearchLoaded(results: results));
    } catch (e) {
      emit(FoodSearchError(message: e.toString()));
    }
  }

  Future<void> _onFoodDetailsRequested(
    FoodDetailsRequested event,
    Emitter<FoodSearchState> emit,
  ) async {
    emit(const FoodDetailsLoading());

    try {
      final foodDetails = await _repository.getFoodDetails(event.fdcId);
      final nutritionValues =
          await _repository.extractNutritionValues(foodDetails);
      emit(FoodDetailsLoaded(
        food: foodDetails,
        nutritionValues: nutritionValues,
      ));
    } catch (e) {
      emit(FoodSearchError(message: e.toString()));
    }
  }

  void _onFoodSearchCleared(
    FoodSearchCleared event,
    Emitter<FoodSearchState> emit,
  ) {
    emit(const FoodSearchInitial());
  }
}
