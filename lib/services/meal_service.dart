import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../exceptions/meal_exception.dart';
import '../models/meal.dart';
import 'meal_repository.dart';

class MealService implements MealRepository {
  MealService({
    http.Client? client,
    this.baseUrl = defaultBaseUrl,
    this.token = defaultToken,
  }) : _client = client ?? http.Client();

  static const String defaultBaseUrl = 'http://127.0.0.1:8080/api';
  // 'http://localhost:8080/api'; //macOS/iOS/desktop
  // http://10.0.2.2:8080/api <- Android emulator
  // http://YOUR-PC-IP:8080/api <- Phone
  static const String defaultToken = String.fromEnvironment('API_TOKEN');
  static const Duration requestTimeout = Duration(seconds: 10);
  final http.Client _client;
  final String baseUrl;
  final String token;

  @override
  Future<List<Meal>> fetchMeals() {
    return _handleNetworkErrors(() async {
      final response = await _client
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
        final meals = decodedBody
            .map((item) => Meal.fromJson(item as Map<String, dynamic>))
            .toList();
        return List.unmodifiable(meals);
      } on FormatException {
        throw const MealException(MealErrorType.invalidServerData);
      } on TypeError {
        throw const MealException(MealErrorType.invalidServerData);
      } on StateError {
        throw const MealException(MealErrorType.invalidServerData);
      }
    });
  }

  @override
  Future<Set<String>> fetchFavoriteIds() {
    return _handleNetworkErrors(() async {
      final response = await _client
          .get(
            Uri.parse('$baseUrl/favorites'),
            headers: headers,
          )
          .timeout(requestTimeout);

      if (response.statusCode != 200) {
        throw const MealException(MealErrorType.serverError);
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

      return decodedBody.map((item) => item.toString()).toSet();
    });
  }

  @override
  Future<void> createMeal(Meal meal) {
    return _handleNetworkErrors(() async {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/meals'),
            headers: headers,
            body: jsonEncode(meal.toJson()),
          )
          .timeout(requestTimeout);
      if (response.statusCode != 201) {
        throw const MealException(MealErrorType.failedToAddMeal);
      }
    });
  }

  @override
  Future<void> setFavorite(String mealId, {required bool isFavorite}) {
    return _handleNetworkErrors(() async {
      final uri = Uri.parse('$baseUrl/favorites/$mealId');
      final response = isFavorite
          ? await _client.post(uri, headers: headers).timeout(requestTimeout)
          : await _client.delete(uri, headers: headers).timeout(requestTimeout);
      if (response.statusCode != 200) {
        throw MealException(isFavorite
            ? MealErrorType.failedToAddFavorite
            : MealErrorType.failedToRemoveFavorite);
      }
    });
  }

  void validateConfig() {
    if (token.isEmpty) {
      throw const MealException(MealErrorType.missingApiToken);
    }
  }

  Map<String, String> get headers {
    validateConfig();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<T> _handleNetworkErrors<T>(Future<T> Function() request) async {
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

  @override
  Future<void> updateMeal(String mealId, Meal meal) {
    return _handleNetworkErrors(() async {
      final response = await _client
          .put(
            Uri.parse('$baseUrl/meals/$mealId'),
            headers: headers,
            body: jsonEncode(meal.toJson()),
          )
          .timeout(requestTimeout);
      if (response.statusCode != 200) {
        throw const MealException(MealErrorType.failedToUpdateMeal);
      }
    });
  }

  @override
  Future<void> deleteMeal(String mealId) {
    return _handleNetworkErrors(() async {
      final response = await _client
          .delete(
            Uri.parse('$baseUrl/meals/$mealId'),
            headers: headers,
          )
          .timeout(requestTimeout);
      if (response.statusCode != 200) {
        throw const MealException(MealErrorType.failedToDeleteMeal);
      }
    });
  }

  void close() {
    _client.close();
  }
}
