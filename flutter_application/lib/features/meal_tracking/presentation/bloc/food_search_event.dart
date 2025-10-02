part of 'food_search_bloc.dart';

abstract class FoodSearchEvent extends Equatable {
  const FoodSearchEvent();

  @override
  List<Object?> get props => [];
}

class FoodSearchRequested extends FoodSearchEvent {
  final String query;

  const FoodSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class FoodDetailsRequested extends FoodSearchEvent {
  final String fdcId;

  const FoodDetailsRequested(this.fdcId);

  @override
  List<Object?> get props => [fdcId];
}

class FoodSearchCleared extends FoodSearchEvent {
  const FoodSearchCleared();
}
