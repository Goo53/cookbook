import 'package:cookbook/screens/categories.dart';
//import 'package:cookbook/screens/meal_detail.dart';
//import 'package:cookbook/widgets/meals_list.dart';
import 'package:cookbook/screens/meals_screen.dart';
import 'package:cookbook/services/meal_service.dart';
import 'package:cookbook/state/fav_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:cookbook/models/meal.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await MealService.getMeals();
      await MealService.loadFavorites();
      if (!mounted) return;
      context.read<FavoritesNotifier>().setFavorites(MealService.getFavoriteIds());
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Failed to load meals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
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
        title: 'All Recipes',
        meals: allMeals,
        colors: const [Colors.blue, Colors.cyan],
      ),
      MealsScreen(
        title: 'Your Favorites',
        meals: favMeals,
        colors: const [Colors.red, Colors.orange],
      ),
    ];

    return Scaffold(
      appBar: AppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "All Recipes",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
        ],
        onTap: _selectPage,
      ),
    );
  }
}
