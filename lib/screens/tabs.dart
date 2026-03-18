import 'package:cookbook/screens/categories.dart';
//import 'package:cookbook/screens/meal_detail.dart';
//import 'package:cookbook/widgets/meals_list.dart';
import 'package:cookbook/screens/meals_screen.dart';
import 'package:cookbook/state/fav_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookbook/data/dummy_data.dart';
//import 'package:cookbook/models/meal.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  //final List<Widget> _pages = [
  //  const CategoriesScreen(),
  //  const MealsScreen(meals: [], colors: [])
  //];
  //final List<Meal> _favourites = [];
  // storing fav as a list of objects is dumbdumb, do store ids set<string>, set up notifier

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final favoritesNotifier = context.watch<FavoritesNotifier>();
    final favMeals = favoritesNotifier.getFavMeals(dummyMeals);

    final pages = [
      const CategoriesScreen(),
      MealsScreen(
        title: 'Your Favorites',
        meals: favMeals,
        colors: const [Colors.red, Colors.orange],
      ),
    ];

    //Widget activePage = const CategoriesScreen();
    //
    //  if (_selectedPageIndex == 1) {
    //activePage = const MealsScreen(
    // title: 'Favourites',
    //meals: [],
    //colors: [],
    // );
    //}
    return Scaffold(
      appBar: AppBar(
          // title: ,
          ),
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
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
        ],
        onTap: _selectPage,
      ),
    );
  }
}
