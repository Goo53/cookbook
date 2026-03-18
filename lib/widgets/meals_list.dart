import 'package:cookbook/screens/meal_detail.dart';
import 'package:cookbook/widgets/meal_item_trait.dart';
import 'package:flutter/material.dart';

import 'package:cookbook/models/meal.dart';
//import 'package:transparent_image/transparent_image.dart'; cached is asynchronus and doesn't freezes ui
import 'package:cached_network_image/cached_network_image.dart';

class MealsList extends StatelessWidget {
  const MealsList(
      {super.key, required this.meals, required this.categoryColors});

  final List<Meal> meals;
  final List<Color> categoryColors;

  void _mealDetail(BuildContext context, Meal meal) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MealDetailScreen(
                meal: meal,
                categoryColors: categoryColors,
                length: meal.ingredients.length,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: meals.length,
      itemBuilder: (context, index) => Card(
        child: InkWell(
          onTap: () {
            _mealDetail(context, meals[index]);
          },
          splashColor: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: categoryColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(clipBehavior: Clip.hardEdge, children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: meals[index].imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ), //without AspectRatio images overflove and frezzes ui
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black87,
                              Colors.black54,
                              Colors.black.withOpacity(0.0)
                            ]),
                        //color: Colors.black54,
                        border: Border.all(style: BorderStyle.none),
                      ),
                      //color: Colors.black54,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  meals[index].title,
                                  softWrap: true,
                                  overflow: TextOverflow
                                      .ellipsis, // text cut off with '...'
                                  textAlign: TextAlign.start,
                                  maxLines: 2,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          Wrap(
                            alignment: WrapAlignment.spaceAround,
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              MealItemTrait(
                                  string: "${meals[index].duration} min",
                                  iconData: Icons.schedule),
                              const SizedBox(
                                width: 12,
                              ),
                              MealItemTrait(
                                  string: meals[index]
                                      .complexity
                                      .name
                                      .toUpperCase(),
                                  iconData: Icons.work),
                              const SizedBox(
                                width: 12,
                              ),
                              MealItemTrait(
                                  string: meals[index]
                                      .affordability
                                      .name
                                      .toUpperCase(),
                                  iconData: Icons.attach_money)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
