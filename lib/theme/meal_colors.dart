import 'package:material_ui/material_ui.dart';
import 'package:cookbook/models/meal.dart';
import 'package:cookbook/data/available_categories.dart';

Color mealCategoryColor(Meal meal) {
  if (meal.categories.isEmpty) {
    return Colors.grey;
  }
  final primaryCategoryKey = meal.categories.first;

  for (final category in availableCategories) {
    if (category.apiKey == primaryCategoryKey) {
      return category.color;
    }
  }
  return Colors.grey;
}

List<Color> mealGradientColors(Meal meal) {
  final categoryColor = mealCategoryColor(meal);
  return [
    categoryColor.withValues(alpha: 0.3),
    categoryColor.withValues(alpha: 0.6),
  ];
}
