import 'package:cookbook/screens/meals_screen.dart';
import 'package:cookbook/services/meal_service.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/models/category.dart';
import 'package:cookbook/data/available_categories.dart';

class CategoryGridItem extends StatelessWidget {
  const CategoryGridItem({
    super.key,
    required this.category,
  });

  final Category category;

  void _selectCategory(BuildContext context, Category category) async {
    final meals = await MealService.getMealsByCategory(category.id);

    if (!context.mounted) return;
    final displayName = getCategoryDisplayName(category.apiKey, context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MealsScreen(
          title: displayName,
          meals: meals, //dummyMeals,
          colors: [
            category.color.withValues(alpha: 0.30),
            category.color.withValues(alpha: 0.6),
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
              category.color.withValues(alpha: 0.30),
              category.color.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          getCategoryDisplayName(category.apiKey, context),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ),
    );
  }
}
