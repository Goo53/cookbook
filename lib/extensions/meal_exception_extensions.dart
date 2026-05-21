import 'package:cookbook/exceptions/meal_exception.dart';
import 'package:cookbook/generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension MealExceptionLocalization on MealException {
  String localizedMessage(BuildContext context) {
    final l = AppLocalizations.of(context);
    return switch (type) {
      MealErrorType.failedToLoadMeals => l.failedToLoadMeals,
      MealErrorType.failedToLoadMealsByCategory =>
        l.errorFailedToLoadMealsByCategory,
      MealErrorType.serverError => l.errorServerError,
      MealErrorType.unexpectedResponseFormat => l.errorUnexpectedResponseFormat,
      MealErrorType.noInternetConnection => l.errorNoInternetConnection,
      MealErrorType.invalidServerData => l.errorInvalidServerData,
      MealErrorType.failedToRemoveFavorite => l.errorFailedToRemoveFavorite,
      MealErrorType.failedToAddFavorite => l.errorFailedToAddFavorite,
      MealErrorType.failedToAddMeal => l.errorFailedToAddMeal,
      MealErrorType.failedToUpdateMeal => l.errorFailedToUpdateMeal,
      MealErrorType.failedToDeleteMeal => l.errorFailedToDeleteMeal,
    };
  }
}
