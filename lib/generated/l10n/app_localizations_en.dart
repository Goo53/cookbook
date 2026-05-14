// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flutter Cookbook';

  @override
  String get categoriesLabel => 'Categories';

  @override
  String get allRecipesLabel => 'All Recipes';

  @override
  String get favoritesLabel => 'Favourites';

  @override
  String get categoriesTitle => 'Categories:';

  @override
  String get ingredientsTitle => 'Ingredients:';

  @override
  String get stepsTitle => 'Steps:';

  @override
  String get noMealsText => 'No meals in here';

  @override
  String get failedToLoadMeals => 'Failed to load meals';

  @override
  String get retryButton => 'Retry';

  @override
  String get addedToFavorites => 'Added to favorites';

  @override
  String get removedFromFavorites => 'Removed from favorites';

  @override
  String get undoButton => 'UNDO';

  @override
  String get categoryItalian => 'Italian';

  @override
  String get categoryQuickEasy => 'Quick & Easy';

  @override
  String get categoryHamburgers => 'Hamburgers';

  @override
  String get categoryGerman => 'German';

  @override
  String get categoryLightLovely => 'Light & Lovely';

  @override
  String get categoryExotic => 'Exotic';

  @override
  String get categoryBreakfast => 'Breakfast';

  @override
  String get categoryAsian => 'Asian';

  @override
  String get complexitySimple => 'Simple';

  @override
  String get complexityChallenging => 'Challenging';

  @override
  String get complexityHard => 'Hard';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get affordabilityAffordable => 'Affordable';

  @override
  String get affordabilityPricey => 'Pricey';

  @override
  String get affordabilityLuxurious => 'Luxurious';

  @override
  String get errorFailedToLoadMealsByCategory =>
      'Failed to load meals for this category';

  @override
  String get errorServerError => 'Server error. Please try again.';

  @override
  String get errorUnexpectedResponseFormat =>
      'Unexpected server response. Please try again.';

  @override
  String get errorNoInternetConnection =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorInvalidServerData =>
      'Server returned invalid data. Please try again.';

  @override
  String get errorFailedToRemoveFavorite => 'Failed to remove from favorites.';

  @override
  String get errorFailedToAddMeal => 'Failed to add meal. Please try again.';

  @override
  String get errorFailedToAddFavorite => 'Failed to add to favorites.';
}
