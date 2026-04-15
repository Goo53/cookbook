import 'package:flutter/foundation.dart';
import 'package:cookbook/models/meal.dart';
import 'package:flutter/material.dart';

class FavoritesNotifier extends ChangeNotifier {
  Set<String> _favMealsId = {};
  bool isFav(String mealId) {
    return _favMealsId.contains(mealId);
  }

  void toggleFav(String mealId) {
    if (_favMealsId.contains(mealId)) {
      _favMealsId.remove(mealId);
    } else {
      _favMealsId.add(mealId);
    }
    notifyListeners();
  }

  void setFavorites(Set<String> ids) {
    _favMealsId = ids;
    notifyListeners();
  }

  Set<String> get fav => _favMealsId;
  List<Meal> getFavMeals(List<Meal> allMeals) {
    return allMeals.where((meal) => _favMealsId.contains(meal.id)).toList();
  }
}
