import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../data/available_categories.dart';
import '../exceptions/meal_exception.dart';

class MealService {
  static const String baseUrl = 'http://localhost:8080/api'; //macOS/iOS/desktop
  // http://10.0.2.2:8080/api <- Android emulator
  // http://YOUR-PC-IP:8080/api <- Phone
  static const String token = 'my-secret-token';
  static List<Meal> _cachedMeals = [];
  static final Map<String, List<Meal>> _cachedByCategory = {};
  static final Set<String> _favoriteIds = {};

  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  static Future<List<Meal>> getMeals() async {
    final response = await http.get(
      Uri.parse('$baseUrl/meals'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body) as List;
      _cachedMeals = data.map((e) => Meal.fromJson(e)).toList();
      return _cachedMeals;
    } else {
      throw const MealException(MealErrorType.failedToLoadMeals);
    }
  }

  static List<Meal> getCachedMeals() =>
      List.unmodifiable(_cachedMeals); //load all once

  static Future<List<Meal>> getMealsByCategory(String categoryId) async {
    if (_cachedByCategory.containsKey(categoryId)) {
      return _cachedByCategory[categoryId]!;
    }

    // Convert category ID to actual category name for backend
    final categoryName = getCategoryApiKey(categoryId);

    // if not cached yet call backend
    final response = await http.get(
      Uri.parse('$baseUrl/meals_filter?category=$categoryName'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body) as List;
      final meals = data.map((e) => Meal.fromJson(e)).toList();
      _cachedByCategory[categoryId] = meals;
      return meals;
      // REMEMBER TO CLEARCACHE() after backend changes OR ADD REFRESH BUTTON
    } else {
      throw const MealException(MealErrorType.failedToLoadMealsByCategory);
    }
  }

  static Future<void> loadFavorites() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favorites'),
        headers: headers,
      );
      if (response.statusCode != 200) {
        throw const MealException(MealErrorType.serverError);
      }
      final data = jsonDecode(response.body);
      if (data is! List) {
        throw const MealException(MealErrorType.unexpectedResponseFormat);
      }
      _favoriteIds
        ..clear()
        ..addAll(data.map((e) => e.toString()));
    } on SocketException {
      throw const MealException(MealErrorType.noInternetConnection);
    }
  }

  static Future<void> toggleFavorite(String mealId) async {
    try {
      if (_favoriteIds.contains(mealId)) {
        final res = await http.delete(
          Uri.parse('$baseUrl/favorites/$mealId'),
          headers: headers,
        );
        if (res.statusCode != 200) {
          throw const MealException(MealErrorType.failedToRemoveFavorite);
        }
        _favoriteIds.remove(mealId);
      } else {
        final res = await http.post(
          Uri.parse('$baseUrl/favorites/$mealId'),
          headers: headers,
        );
        if (res.statusCode != 200) {
          throw const MealException(MealErrorType.failedToAddFavorite);
        }
        _favoriteIds.add(mealId);
      }
    } on SocketException {
      throw const MealException(MealErrorType.noInternetConnection);
    }
  }

  static bool isFavorite(String mealId) {
    return _favoriteIds.contains(mealId);
  }

  static Set<String> getFavoriteIds() {
    return Set.unmodifiable(_favoriteIds);
  }

  static Future<void> addMeal(Meal meal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/meals'),
      headers: headers,
      body: jsonEncode(meal.toJson()),
    );
    if (response.statusCode != 201) {
      throw const MealException(MealErrorType.failedToAddMeal);
    }
  }
  // TO DO
  //static Future<Meal> getMealById(String id) async {}
  //static Future<void> updateMeal(String id, Meal meal) async {}
  //static Future<void> deleteMeal(String id) async {}
}
