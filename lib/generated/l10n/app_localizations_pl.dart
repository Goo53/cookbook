// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Książka Kulinarna Flutter';

  @override
  String get categoriesLabel => 'Kategorie';

  @override
  String get allRecipesLabel => 'Wszystkie Przepisy';

  @override
  String get favoritesLabel => 'Ulubione';

  @override
  String get categoriesTitle => 'Kategorie:';

  @override
  String get ingredientsTitle => 'Składniki:';

  @override
  String get stepsTitle => 'Kroki:';

  @override
  String get noMealsText => 'Brak przepisów tutaj';

  @override
  String get failedToLoadMeals => 'Nie udało się załadować przepisów';

  @override
  String get retryButton => 'Spróbuj ponownie';

  @override
  String get addedToFavorites => 'Dodano do ulubionych';

  @override
  String get removedFromFavorites => 'Usunięto z ulubionych';

  @override
  String get undoButton => 'COFNIJ';

  @override
  String get categoryItalian => 'Włoskie';

  @override
  String get categoryQuickEasy => 'Szybkie & Łatwe';

  @override
  String get categoryHamburgers => 'Hamburgery';

  @override
  String get categoryGerman => 'Niemieckie';

  @override
  String get categoryLightLovely => 'Lekkie & Ładne';

  @override
  String get categoryExotic => 'Egzotyczne';

  @override
  String get categoryBreakfast => 'Śniadanie';

  @override
  String get categoryAsian => 'Azjatyckie';

  @override
  String get complexitySimple => 'Proste';

  @override
  String get complexityChallenging => 'Wyzywające';

  @override
  String get complexityHard => 'Trudne';

  @override
  String durationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get affordabilityAffordable => 'Tanie';

  @override
  String get affordabilityPricey => 'Drogie';

  @override
  String get affordabilityLuxurious => 'Luksusowe';

  @override
  String get addMeal => 'Dodaj przepis';

  @override
  String get editMeal => 'Edytuj przepis';

  @override
  String get deleteMeal => 'Usuń przepis';

  @override
  String get saveMeal => 'Zapisz przepis';

  @override
  String get cancel => 'Anuluj';

  @override
  String get confirmDeleteMeal => 'Usunąć ten przepis?';

  @override
  String get mealCreated => 'Przepis dodany';

  @override
  String get mealUpdated => 'Przepis zaktualizowany';

  @override
  String get mealDeleted => 'Przepis usunięty';

  @override
  String get requiredField => 'Wymagane';

  @override
  String get invalidDuration => 'Nieprawidłowy czas';

  @override
  String get errorFailedToLoadMealsByCategory =>
      'Nie udało się załadować przepisów dla tej kategorii';

  @override
  String get errorServerError => 'Błąd serwera. Spróbuj ponownie.';

  @override
  String get errorUnexpectedResponseFormat =>
      'Nieoczekiwana odpowiedź serwera. Spróbuj ponownie.';

  @override
  String get errorNoInternetConnection =>
      'Brak połączenia internetowego. Sprawdź sieć i spróbuj ponownie.';

  @override
  String get errorInvalidServerData =>
      'Serwer zwrócił nieprawidłowe dane. Spróbuj ponownie.';

  @override
  String get errorFailedToRemoveFavorite =>
      'Nie udało się usunąć z ulubionych.';

  @override
  String get errorFailedToAddMeal =>
      'Nie udało się dodać przepisu. Spróbuj ponownie.';

  @override
  String get errorFailedToAddFavorite => 'Nie udało się dodać do ulubionych.';

  @override
  String get errorFailedToUpdateMeal => 'Nie udało się zaktualizować przepisu.';

  @override
  String get errorFailedToDeleteMeal => 'Nie udało się usunąć przepisu.';

  @override
  String get errorMissingApiToken =>
      'Brakuje tokenu API. Uruchom aplikację ze skonfigurowanym API_TOKEN.';
}
