import 'package:cookbook/screens/categories.dart';
import 'package:cookbook/screens/meals_screen.dart';
import 'package:cookbook/services/meal_service.dart';
import 'package:cookbook/state/fav_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookbook/generated/l10n/app_localizations.dart';
import 'package:cookbook/widgets/language_picker.dart';
import '../exceptions/meal_exception.dart';
import '../extensions/meal_exception_extensions.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      await MealService.getMeals();
      await MealService.loadFavorites();
      if (!mounted) return;
      context
          .read<FavoritesNotifier>()
          .setFavorites(MealService.getFavoriteIds());
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
        });
      }
    }
  }

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
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
                  _error is MealException
                      ? (_error as MealException).localizedMessage(context)
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

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final favoritesNotifier = context.watch<FavoritesNotifier>();
    final allMeals = MealService.getCachedMeals();
    final favMeals = favoritesNotifier.getFavMeals(allMeals);
    final pages = [
      const CategoriesScreen(),
      MealsScreen(
        title: AppLocalizations.of(context).allRecipesLabel,
        meals: allMeals,
        colors: const [Colors.blue, Colors.cyan],
      ),
      MealsScreen(
        title: AppLocalizations.of(context).favoritesLabel,
        meals: favMeals,
        colors: const [Colors.red, Colors.orange],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: const [LanguagePicker()],
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
