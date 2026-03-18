import 'package:cookbook/state/fav_notifier.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/models/meal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

// here to create statefull widget to use CheckboxListTile widget managing bool var
// corresponging with earch step and doing:
//(bool? value[i]) {
//              setState(() {
//                checkboxValue[i] = value!;
//              });
//            },
// probably for steps too
// creating bool var dynamically(?) -> creating list of boolean variables alongside ingridients
// and then changing state of it inside list
class MealDetailScreen extends StatefulWidget {
  const MealDetailScreen(
      {super.key,
      required this.meal,
      required this.categoryColors,
      required this.length});

  final Meal meal;
  final List<Color> categoryColors;
  final int length;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  // Map<String, bool> checkMap =
  // for (final ingridient in widget.meal.ingredients) {
  //     checkMap.addEntries({ingridient: false}.entries);
  //   };
  var checkboxValue3 = false;
  final Map<String, bool> _map = {};
  //Map<String, bool> updatedMap = {};
  //List<bool> checkinList = [];
  //List<bool> checkinList = [];

  @override
  void initState() {
    //for(var in widget.meal.ingredients) {checkinList.add(false);}
    //for(int i=0,i<length,i++) {checkinList.add(value)};
    for (final ingredient in widget.meal.ingredients) {
      _map[ingredient] = false;
    }
    //print(_map);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesNotifier>();
    final isFav = favorites.isFav(widget.meal.id);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.meal.title),
          actions: [
            IconButton(
                onPressed: () {
                  favorites.toggleFav(widget.meal.id);
                },
                icon: Icon(isFav ? Icons.star : Icons.star_border_outlined)),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: widget.categoryColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: widget.meal.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey[300]),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 50),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "Ingredients:",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 14),
            // Ingredients checkboxes
            ..._map.entries.map((entry) => CheckboxListTile(
                  value: entry.value,
                  onChanged: (bool? value) {
                    setState(() {
                      _map[entry.key] = value!;
                    });
                  },
                  title: Text(
                    entry.key,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                )),
            const SizedBox(height: 14),
            Text(
              "Steps:",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            ...widget.meal.steps.map((step) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    step,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                )),
          ],
        ));
  }
}

@override
Widget build(BuildContext context) {
  throw UnimplementedError();
}
