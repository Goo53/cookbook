import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../data/available_categories.dart';
import '../exceptions/meal_exception.dart';
import '../models/meal.dart';

class MealService {
  static const String baseUrl = 'http://127.0.0.1:8080/api'; //for ios simulator
  // 'http://localhost:8080/api'; //macOS/iOS/desktop
  // http://10.0.2.2:8080/api <- Android emulator
  // http://YOUR-PC-IP:8080/api <- Phone
  static const String token = String.fromEnvironment('API_TOKEN');
  static const Duration requestTimeout = Duration(seconds: 10);

  static List<Meal> _cachedMeals = [];
  static final Map<String, List<Meal>> _cachedByCategory = {};
  static final Set<String> _favoriteIds = {};

  static void validateConfig() {
    if (token.isEmpty) {
      throw const MealException(MealErrorType.missingApiToken);
    }
  }

  static Map<String, String> get headers {
    validateConfig();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<T> _handleNetworkErrors<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on TimeoutException {
      throw const MealException(MealErrorType.noInternetConnection);
    } on SocketException {
      throw const MealException(MealErrorType.noInternetConnection);
    } on http.ClientException {
      throw const MealException(MealErrorType.noInternetConnection);
    }
  } // Helper function to handle network errors in one place as all service methods have the same errors

  static Future<List<Meal>> getMeals() {
    return _handleNetworkErrors(() async {
      final response = await http
          .get(
            Uri.parse('$baseUrl/meals'),
            headers: headers,
          )
          .timeout(requestTimeout);

      if (response.statusCode != 200) {
        throw const MealException(MealErrorType.failedToLoadMeals);
      }

      final dynamic decodedBody;
      try {
        decodedBody = jsonDecode(response.body);
      } on FormatException {
        throw const MealException(MealErrorType.invalidServerData);
      }

      if (decodedBody is! List) {
        throw const MealException(MealErrorType.unexpectedResponseFormat);
      }
      try {
        _cachedMeals = decodedBody.map((e) => Meal.fromJson(e)).toList();
        return List.unmodifiable(_cachedMeals);
      } on FormatException {
        throw const MealException(MealErrorType.invalidServerData);
      } on TypeError {
        throw const MealException(MealErrorType.invalidServerData);
      }
    });
  }

  static List<Meal> getCachedMeals() =>
      List.unmodifiable(_cachedMeals); //load all once

  static Future<List<Meal>> getMealsByCategory(String categoryId) {
    return _handleNetworkErrors(() async {
      final cachedMeals = _cachedByCategory[categoryId];
      if (cachedMeals != null) {
        return List.unmodifiable(cachedMeals);
      }
      final categoryName = getCategoryApiKey(categoryId);

      final uri = Uri.parse('$baseUrl/meals_filter').replace(
        queryParameters: {'category': categoryName},
      );

      final response = await http
          .get(
            uri,
            headers: headers,
          )
          .timeout(requestTimeout);
      if (response.statusCode != 200) {
        throw const MealException(MealErrorType.failedToLoadMealsByCategory);
      }
      final decodedBody = jsonDecode(response.body);
      if (decodedBody is! List) {
        throw const MealException(MealErrorType.unexpectedResponseFormat);
      }
      try {
        final meals = decodedBody.map((e) => Meal.fromJson(e)).toList();
        _cachedByCategory[categoryId] = meals;
        return List.unmodifiable(meals);
      } on FormatException {
        throw const MealException(MealErrorType.invalidServerData);
      } on TypeError {
        throw const MealException(MealErrorType.invalidServerData);
      }
    });
  }

  static Future<void> loadFavorites() {
    return _handleNetworkErrors(() async {
      final response = await http
          .get(
            Uri.parse('$baseUrl/favorites'),
            headers: headers,
          )
          .timeout(requestTimeout);
      if (response.statusCode != 200) {
        throw const MealException(MealErrorType.serverError);
      }
      final decodedBody = jsonDecode(response.body);
      if (decodedBody is! List) {
        throw const MealException(MealErrorType.unexpectedResponseFormat);
      }
      _favoriteIds
        ..clear()
        ..addAll(decodedBody.map((e) => e.toString()));
    });
  }

  static Future<void> toggleFavorite(String mealId) {
    return _handleNetworkErrors(() async {
      if (_favoriteIds.contains(mealId)) {
        final res = await http
            .delete(
              Uri.parse('$baseUrl/favorites/$mealId'),
              headers: headers,
            )
            .timeout(requestTimeout);
        if (res.statusCode != 200) {
          throw const MealException(MealErrorType.failedToRemoveFavorite);
        }
        _favoriteIds.remove(mealId);
      } else {
        final res = await http
            .post(
              Uri.parse('$baseUrl/favorites/$mealId'),
              headers: headers,
            )
            .timeout(requestTimeout);
        if (res.statusCode != 200) {
          throw const MealException(MealErrorType.failedToAddFavorite);
        }
        _favoriteIds.add(mealId);
      }
    });
  }

  static bool isFavorite(String mealId) {
    return _favoriteIds.contains(mealId);
  }

  static Set<String> getFavoriteIds() {
    return Set.unmodifiable(_favoriteIds);
  }

  static Future<void> addMeal(Meal meal) {
    return _handleNetworkErrors(() async {
      final response = await http
          .post(
            Uri.parse('$baseUrl/meals'),
            headers: headers,
            body: jsonEncode(meal.toJson()),
          )
          .timeout(requestTimeout);
      if (response.statusCode != 201) {
        throw const MealException(MealErrorType.failedToAddMeal);
      }
      clearCache();
    });
  }

  static Future<void> updateMeal(String mealId, Meal meal) {
    return _handleNetworkErrors(() async {
      final response = await http
          .put(
            Uri.parse('$baseUrl/meals/$mealId'),
            headers: headers,
            body: jsonEncode(meal.toJson()),
          )
          .timeout(requestTimeout);
      if (response.statusCode != 200) {
        throw const MealException(MealErrorType.failedToUpdateMeal);
      }
      clearCache();
    });
  }

  static Future<void> deleteMeal(String mealId) {
    return _handleNetworkErrors(() async {
      final response = await http
          .delete(
            Uri.parse('$baseUrl/meals/$mealId'),
            headers: headers,
          )
          .timeout(requestTimeout);
      if (response.statusCode != 200) {
        throw const MealException(MealErrorType.failedToDeleteMeal);
      }
      _favoriteIds.remove(mealId);
      clearCache();
    });
  }

  static void clearCache() {
    _cachedMeals = [];
    _cachedByCategory.clear();
  }

  static Future<List<Meal>> refreshMeals() async {
    _cachedByCategory.clear();
    return getMeals();
  }
  // TO DO
  //static Future<Meal> getMealById(String id) async {}
}
