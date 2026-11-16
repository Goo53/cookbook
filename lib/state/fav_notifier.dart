import 'package:flutter/foundation.dart';
import 'package:cookbook/models/meal.dart';
import '../services/meal_repository.dart';

class FavoritesNotifier extends ChangeNotifier {
  FavoritesNotifier(this._repository);
  final MealRepository _repository;

  Set<String> _favMealsId = {};
  final Set<String> _pendingIds = {};

  bool _isLoading = false;
  bool _hasLoaded = false;
  Object? _loadError;

  Set<String> get favMealsId => Set.unmodifiable(_favMealsId);

  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  Object? get loadError => _loadError;

  bool isFavorite(String mealId) {
    return _favMealsId.contains(mealId);
  }

  bool isPending(String mealId) {
    return _pendingIds.contains(mealId);
  }

  List<Meal> favoriteMeals(List<Meal> allMeals) {
    return List.unmodifiable(
        allMeals.where((meal) => _favMealsId.contains(meal.id)));
  }

  Future<void> loadFavorites() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      final ids = await _repository.fetchFavoriteIds();
      _favMealsId = Set.unmodifiable(ids);
      _hasLoaded = true;
    } catch (e) {
      _loadError = e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setFavorite(String mealId, bool shouldBeFavorite) async {
    if (_pendingIds.contains(mealId)) {
      return;
    }
    _pendingIds.add(mealId);
    notifyListeners();

    try {
      await _repository.setFavorite(mealId, isFavorite: shouldBeFavorite);
      final updatedIds = {..._favMealsId};

      if (shouldBeFavorite) {
        updatedIds.add(mealId);
      } else {
        updatedIds.remove(mealId);
      }
      _favMealsId = Set.unmodifiable(updatedIds);
    } finally {
      _pendingIds.remove(mealId);
      notifyListeners();
    }
  }

  void removeMeal(String mealId) {
    if (!_favMealsId.contains(mealId)) {
      return;
    }
    _favMealsId = Set.unmodifiable({..._favMealsId}..remove(mealId));
    notifyListeners();
  }
}
