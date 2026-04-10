import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';

class MealService {
  static const String baseUrl = 'http://10.0.2.2:8080/api'; //android emulator
  // http://localhost:8080/api <- iOS
  // http://YOUR-PC-ID:8080/api <-phone
  static const String token = 'my-secret-token';
  static List<Meal> _cachedMeals = [];
  static final Map<String, List<Meal>> _cachedByCategory = {};

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
      throw Exception('Failed to load meals');
    }
  }

  static List<Meal> getCachedMeals() =>
      List.unmodifiable(_cachedMeals); //load all once

  static Future<List<Meal>> getMealsByCategory(String categoryId) async {
    if (_cachedByCategory.containsKey(categoryId)) {
      return _cachedByCategory[categoryId]!;
    }

    // if not cached yet call backend
    final response = await http.get(
      Uri.parse('$baseUrl/meals/filter?category=$categoryId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body) as List;
      final meals = data.map((e) => Meal.fromJson(e)).toList();
      _cachedByCategory[categoryId] = meals;
      return meals;
      // REMEMBER TO CLEARCACHE() after backend changes OR ADD REFRESH BUTTON
    } else {
      throw Exception('Failed to load meals by category');
    }
  }

  static Future<void> addMeal(Meal meal) async {
    final response = await http.post(
      Uri.parse('$baseUrl/meals'),
      headers: headers,
      body: jsonEncode(meal.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add meal: ${response.body}');
    }
  }
  // TO DO
  //static Future<Meal> getMealById(String id) async {}
  //static Future<void> updateMeal(String id, Meal meal) async {}
  //static Future<void> deleteMeal(String id) async {}
}
