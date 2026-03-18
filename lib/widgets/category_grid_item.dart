import 'package:cookbook/data/dummy_data.dart';
import 'package:cookbook/screens/meals_screen.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/models/category.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
  });

  final Category category;

  void _selectCategory(BuildContext context, Category category) {
    final results = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();

    String titlepush = category.title;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: titlepush,
          meals: results, //dummyMeals,
          colors: [
            category.color.withOpacity(0.30),
            category.color.withOpacity(0.6),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // <- BuildContext context in statelessWidgets enables use od Navigator.push(context, route)
    return InkWell(
      onTap: () {
        _selectCategory(context, category);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.30),
              category.color.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}
