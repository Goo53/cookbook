import 'package:cookbook/screens/categories.dart';
import 'package:cookbook/screens/meals_screen.dart';
import 'package:cookbook/state/fav_notifier.dart';
import 'package:cookbook/state/meals_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookbook/generated/l10n/app_localizations.dart';
import 'package:cookbook/widgets/language_picker.dart';
import '../exceptions/meal_exception.dart';
import '../extensions/meal_exception_extensions.dart';
import 'package:cookbook/screens/meal_form_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      context.read<MealsNotifier>().loadMeals(),
      context.read<FavoritesNotifier>().loadFavorites(),
    ]);
  }

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final mealsNotifier = context.watch<MealsNotifier>();
    final favoritesNotifier = context.watch<FavoritesNotifier>();
    final loadError = mealsNotifier.loadError ?? favoritesNotifier.loadError;

    if (loadError != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context).failedToLoadMeals,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  loadError is MealException
                      ? loadError.localizedMessage(context)
                      : AppLocalizations.of(context).errorServerError,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context).retryButton),
              ),
            ],
          ),
        ),
      );
    }

    final isInitialLoading =
        !mealsNotifier.hasLoaded || !favoritesNotifier.hasLoaded;
    if (isInitialLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final allMeals = mealsNotifier.meals;
    final favMeals = favoritesNotifier.favoriteMeals(allMeals);

    final pages = [
      const CategoriesScreen(),
      MealsScreen(
        title: AppLocalizations.of(context).allRecipesLabel,
        meals: allMeals,
      ),
      MealsScreen(
        title: AppLocalizations.of(context).favoritesLabel,
        meals: favMeals,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final result = await Navigator.of(context).push<MealFormResult>(
                  MaterialPageRoute(
                    builder: (context) => const MealFormScreen(),
                  ),
                );
                if (!context.mounted) return;
                if (result == MealFormResult.created) {
                  ScaffoldMessenger.of(context)
                    ..clearSnackBars()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context).mealCreated),
                      ),
                    );
                }
              },
              icon: const Icon(Icons.add)),
          const LanguagePicker()
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.set_meal),
            label: AppLocalizations.of(context).categoriesLabel,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu),
            label: AppLocalizations.of(context).allRecipesLabel,
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.star),
              label: AppLocalizations.of(context).favoritesLabel),
        ],
        onTap: _selectPage,
      ),
    );
  }
}
