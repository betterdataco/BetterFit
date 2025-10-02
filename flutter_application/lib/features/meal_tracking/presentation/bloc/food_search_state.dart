part of 'food_search_bloc.dart';

abstract class FoodSearchState extends Equatable {
  const FoodSearchState();

  @override
  List<Object?> get props => [];
}

class FoodSearchInitial extends FoodSearchState {
  const FoodSearchInitial();
}

class FoodSearchLoading extends FoodSearchState {
  const FoodSearchLoading();
}

class FoodSearchLoaded extends FoodSearchState {
  final List<FoodSearchResult> results;

  const FoodSearchLoaded({required this.results});

  @override
  List<Object?> get props => [results];
}

class FoodDetailsLoading extends FoodSearchState {
  const FoodDetailsLoading();
}

class FoodDetailsLoaded extends FoodSearchState {
  final FoodSearchResult food;
  final Map<String, double> nutritionValues;

  const FoodDetailsLoaded({
    required this.food,
    required this.nutritionValues,
  });

  @override
  List<Object?> get props => [food, nutritionValues];
}

class FoodSearchError extends FoodSearchState {
  final String message;

  const FoodSearchError({required this.message});

  @override
  List<Object?> get props => [message];
}
