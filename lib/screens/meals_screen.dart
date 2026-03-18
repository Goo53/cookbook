import 'package:cookbook/widgets/meals_list.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/models/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen(
      {super.key, this.title, required this.meals, required this.colors});

  final String? title; //title optional
  final List<Meal> meals;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    // if title ==null return content if not go execute scaffold
    if (title == null) {
      return MealsList(meals: meals, categoryColors: colors);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: meals.isEmpty
                ? const Center(
                    child: Text(
                      "No meals in here",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  )
                : MealsList(
                    meals: meals,
                    categoryColors: colors,
                  ),
          ),
        ],
      ),
    );
  }
}
