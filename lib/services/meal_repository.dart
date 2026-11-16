import '../models/meal.dart';

abstract interface class MealRepository {
  Future<List<Meal>> fetchMeals();
  Future<Set<String>> fetchFavoriteIds();

  Future<void> createMeal(Meal meal);
  Future<void> updateMeal(String mealId, Meal meal);
  Future<void> deleteMeal(String mealId);

  Future<void> setFavorite(String mealId, {required bool isFavorite});
}
