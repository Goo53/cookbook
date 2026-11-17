import 'package:cookbook/services/meal_repository.dart';
import 'package:cookbook/models/meal.dart';
import 'package:cookbook/data/sample_meals.dart';

class FakeMealRepository implements MealRepository {
  final List<Meal> _meals = List<Meal>.of(sampleMeals);
  final Set<String> _favoriteMealIds = {};

  @override
  Future<Set<String>> fetchFavoriteIds() async {
    return Set.unmodifiable(_favoriteMealIds);
  }

  @override
  Future<List<Meal>> fetchMeals() async {
    return List.unmodifiable(_meals);
  }

  @override
  Future<void> createMeal(Meal meal) async {
    _meals.add(meal);
  }

  @override
  Future<void> updateMeal(String mealId, Meal meal) async {
    final index = _meals.indexWhere((m) => m.id == mealId);
    if (index != -1) {
      _meals[index] = meal;
    }
  }

  @override
  Future<void> deleteMeal(String mealId) async {
    _meals.removeWhere((m) => m.id == mealId);
    _favoriteMealIds.remove(mealId);
  }

  @override
  Future<void> setFavorite(String mealId, {required bool isFavorite}) async {
    if (isFavorite) {
      _favoriteMealIds.add(mealId);
    } else {
      _favoriteMealIds.remove(mealId);
    }
  }
}
