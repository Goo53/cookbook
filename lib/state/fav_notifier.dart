import 'package:flutter/foundation.dart';
import 'package:cookbook/models/meal.dart';

class FavoritesNotifier extends ChangeNotifier {
  final Set<String> _favMealsId = {};
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

  Set<String> get fav => _favMealsId;
  List<Meal> getFavMeals(List<Meal> allMeals) {
    return allMeals.where((meal) => _favMealsId.contains(meal.id)).toList();
  }
}
