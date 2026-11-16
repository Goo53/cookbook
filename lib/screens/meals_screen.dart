import 'package:cookbook/widgets/meals_list.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/models/meal.dart';
import 'package:cookbook/generated/l10n/app_localizations.dart';
import 'package:cookbook/state/meals_notifier.dart';
import 'package:provider/provider.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({
    super.key,
    this.title,
    this.meals,
    required this.colors,
    this.categoryApiKey,
  }) : assert(meals != null || categoryApiKey != null,
            'Either meals or categoryApiKey must be provided');

  final String? title; //title optional
  final List<Meal>? meals;
  final List<Color> colors;
  final String? categoryApiKey; //categoryApiKey optional

  @override
  Widget build(BuildContext context) {
    // if title ==null return content if not go execute scaffold
    final displayedMeals = categoryApiKey != null
        ? context.watch<MealsNotifier>().mealsForCategory(categoryApiKey!)
        : meals;

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: displayedMeals == null || displayedMeals.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context).noMealsText,
                      style: const TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  )
                : MealsList(
                    meals: displayedMeals,
                    categoryColors: colors,
                  ),
          ),
        ],
      ),
    );
  }
}
