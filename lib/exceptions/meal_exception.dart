enum MealErrorType {
  failedToLoadMeals,
  failedToLoadMealsByCategory,
  serverError,
  unexpectedResponseFormat,
  noInternetConnection,
  invalidServerData,
  failedToRemoveFavorite,
  failedToAddFavorite,
  failedToAddMeal,
}

class MealException implements Exception {
  final MealErrorType type;
  const MealException(this.type);
}
