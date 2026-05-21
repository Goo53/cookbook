import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Flutter Cookbook'**
  String get appTitle;

  /// Label for categories tab
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesLabel;

  /// Label for all recipes tab
  ///
  /// In en, this message translates to:
  /// **'All Recipes'**
  String get allRecipesLabel;

  /// Label for favorites tab
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favoritesLabel;

  /// Title for categories screen
  ///
  /// In en, this message translates to:
  /// **'Categories:'**
  String get categoriesTitle;

  /// Section title for ingredients
  ///
  /// In en, this message translates to:
  /// **'Ingredients:'**
  String get ingredientsTitle;

  /// Section title for cooking steps
  ///
  /// In en, this message translates to:
  /// **'Steps:'**
  String get stepsTitle;

  /// Message when no meals are available
  ///
  /// In en, this message translates to:
  /// **'No meals in here'**
  String get noMealsText;

  /// Error message when meal loading fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load meals'**
  String get failedToLoadMeals;

  /// Button label to retry loading
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Message when meal is added to favorites
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get addedToFavorites;

  /// Message when meal is removed from favorites
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get removedFromFavorites;

  /// Button label to undo action
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undoButton;

  /// Italian cuisine category
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get categoryItalian;

  /// Quick and easy recipes category
  ///
  /// In en, this message translates to:
  /// **'Quick & Easy'**
  String get categoryQuickEasy;

  /// Hamburgers category
  ///
  /// In en, this message translates to:
  /// **'Hamburgers'**
  String get categoryHamburgers;

  /// German cuisine category
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get categoryGerman;

  /// Light and lovely recipes category
  ///
  /// In en, this message translates to:
  /// **'Light & Lovely'**
  String get categoryLightLovely;

  /// Exotic cuisine category
  ///
  /// In en, this message translates to:
  /// **'Exotic'**
  String get categoryExotic;

  /// Breakfast recipes category
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get categoryBreakfast;

  /// Asian cuisine category
  ///
  /// In en, this message translates to:
  /// **'Asian'**
  String get categoryAsian;

  /// Simple complexity level
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get complexitySimple;

  /// Challenging complexity level
  ///
  /// In en, this message translates to:
  /// **'Challenging'**
  String get complexityChallenging;

  /// Hard complexity level
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get complexityHard;

  /// Duration in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String durationMinutes(int minutes);

  /// Cheap in making
  ///
  /// In en, this message translates to:
  /// **'Affordable'**
  String get affordabilityAffordable;

  /// Costly ingredients but within reason
  ///
  /// In en, this message translates to:
  /// **'Pricey'**
  String get affordabilityPricey;

  /// Did you have your payday?
  ///
  /// In en, this message translates to:
  /// **'Luxurious'**
  String get affordabilityLuxurious;

  /// Button or title for creating a new meal
  ///
  /// In en, this message translates to:
  /// **'Add meal'**
  String get addMeal;

  /// Button or title for editing an existing meal
  ///
  /// In en, this message translates to:
  /// **'Edit meal'**
  String get editMeal;

  /// Button label for deleting a meal
  ///
  /// In en, this message translates to:
  /// **'Delete meal'**
  String get deleteMeal;

  /// Button label for saving a meal form
  ///
  /// In en, this message translates to:
  /// **'Save meal'**
  String get saveMeal;

  /// Button label to cancel an action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirmation dialog title before deleting a meal
  ///
  /// In en, this message translates to:
  /// **'Delete this meal?'**
  String get confirmDeleteMeal;

  /// Success message after creating a meal
  ///
  /// In en, this message translates to:
  /// **'Meal created'**
  String get mealCreated;

  /// Success message after updating a meal
  ///
  /// In en, this message translates to:
  /// **'Meal updated'**
  String get mealUpdated;

  /// Success message after deleting a meal
  ///
  /// In en, this message translates to:
  /// **'Meal deleted'**
  String get mealDeleted;

  /// Validation message for an empty required field
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// Validation message for invalid meal duration
  ///
  /// In en, this message translates to:
  /// **'Invalid duration'**
  String get invalidDuration;

  /// Failed to load meals for this category
  ///
  /// In en, this message translates to:
  /// **'Failed to load meals for this category'**
  String get errorFailedToLoadMealsByCategory;

  /// Server error occurred while loading data
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again.'**
  String get errorServerError;

  /// Unexpected server response format
  ///
  /// In en, this message translates to:
  /// **'Unexpected server response. Please try again.'**
  String get errorUnexpectedResponseFormat;

  /// No internet connection available
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Check your network and try again.'**
  String get errorNoInternetConnection;

  /// Server returned invalid data
  ///
  /// In en, this message translates to:
  /// **'Server returned invalid data. Please try again.'**
  String get errorInvalidServerData;

  /// Failed to remove meal from favorites
  ///
  /// In en, this message translates to:
  /// **'Failed to remove from favorites.'**
  String get errorFailedToRemoveFavorite;

  /// Failed to add meal to favorites
  ///
  /// In en, this message translates to:
  /// **'Failed to add meal. Please try again.'**
  String get errorFailedToAddMeal;

  /// Failed to add meal to favorites
  ///
  /// In en, this message translates to:
  /// **'Failed to add to favorites.'**
  String get errorFailedToAddFavorite;

  /// Failed to update meal
  ///
  /// In en, this message translates to:
  /// **'Failed to update meal.'**
  String get errorFailedToUpdateMeal;

  /// Failed to delete meal
  ///
  /// In en, this message translates to:
  /// **'Failed to delete meal.'**
  String get errorFailedToDeleteMeal;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
