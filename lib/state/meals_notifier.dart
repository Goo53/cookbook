import 'package:flutter/foundation.dart';

import '../models/meal.dart';
import '../services/meal_repository.dart';

class MealsNotifier extends ChangeNotifier {
  MealsNotifier(this._repository);

  final MealRepository _repository;

  List<Meal> _meals = const [];
  bool _isLoading = false;
  bool _hasLoaded = false;
  Object? _loadError;

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  Object? get loadError => _loadError;

  Meal? mealById(String id) {
    for (final meal in _meals) {
      if (meal.id == id) {
        return meal;
      }
    }
    return null;
  }

  List<Meal> mealsForCategory(String categoryApiKey) {
    return List.unmodifiable(
        _meals.where((meal) => meal.categories.contains(categoryApiKey)));
  }

  Future<void> loadMeals() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      final meals = await _repository.fetchMeals();
      _meals = List.unmodifiable(meals);
      _hasLoaded = true;
    } catch (e) {
      _loadError = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMeal(Meal meal) async {
    await _repository.createMeal(meal);
    _meals = List.unmodifiable(
        [..._meals.where((existingMeal) => existingMeal.id != meal.id), meal]);
    notifyListeners();
  }

  Future<void> updateMeal(String mealId, Meal updatedMeal) async {
    await _repository.updateMeal(mealId, updatedMeal);
    _meals = List.unmodifiable(_meals.map((existingMeal) {
      if (existingMeal.id == mealId) {
        return updatedMeal;
      }
      return existingMeal;
    }));
    notifyListeners();
  }

  Future<void> deleteMeal(String mealId) async {
    await _repository.deleteMeal(mealId);
    _meals = List.unmodifiable(
        _meals.where((existingMeal) => existingMeal.id != mealId));
    notifyListeners();
  }
}
