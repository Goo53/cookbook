import 'package:cookbook/state/meals_notifier.dart';
import 'package:cookbook/state/fav_notifier.dart';
import 'package:cookbook/exceptions/meal_exception.dart';
import 'package:cookbook/extensions/meal_exception_extensions.dart';
import 'package:material_ui/material_ui.dart';
import 'package:cookbook/models/meal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:cookbook/generated/l10n/app_localizations.dart';
import 'package:cookbook/screens/meal_form_screen.dart';
import 'package:cookbook/theme/meal_colors.dart';

class MealDetailScreen extends StatefulWidget {
  const MealDetailScreen({
    super.key,
    required this.mealId,
  });

  final String mealId;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final Map<String, bool> _map = {};

  @override
  Widget build(BuildContext context) {
    final meal = context.select<MealsNotifier, Meal?>(
        (notifier) => notifier.mealById(widget.mealId));
    if (meal == null) {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(AppLocalizations.of(context).noMealsText,
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      );
    }
    final favorites = context.watch<FavoritesNotifier>();
    final isFav = favorites.isFavorite(meal.id);
    final isPending = favorites.isPending(meal.id);
    final gradientColors = mealGradientColors(meal);

    return Scaffold(
        appBar: AppBar(
          title: Text(meal.title),
          actions: [
            IconButton(
                onPressed: () async {
                  final result =
                      await Navigator.of(context).push<MealFormResult>(
                    MaterialPageRoute(
                      builder: (context) => MealFormScreen(meal: meal),
                    ),
                  );
                  if (!context.mounted) {
                    return;
                  }
                  if (result == MealFormResult.updated) {
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(SnackBar(
                          content:
                              Text(AppLocalizations.of(context).mealUpdated)));
                  }
                },
                icon: const Icon(Icons.edit)),
            IconButton(
                onPressed: isPending
                    ? null
                    : () async {
                        final favoritesNotifier =
                            context.read<FavoritesNotifier>();
                        final shouldBeFavorite =
                            !favoritesNotifier.isFavorite(meal.id);
                        try {
                          await favoritesNotifier.setFavorite(
                              meal.id, shouldBeFavorite);
                          if (!context.mounted) {
                            return;
                          }
                          final message = shouldBeFavorite
                              ? AppLocalizations.of(context).addedToFavorites
                              : AppLocalizations.of(context)
                                  .removedFromFavorites;
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              SnackBar(
                                content: Text(message),
                              ),
                            );
                        } catch (error) {
                          if (!context.mounted) {
                            return;
                          }
                          final message = error is MealException
                              ? error.localizedMessage(context)
                              : AppLocalizations.of(context).errorServerError;
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              SnackBar(content: Text(message)),
                            );
                        }
                      },
                icon: Icon(isFav ? Icons.star : Icons.star_border_outlined)),
            IconButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(AppLocalizations.of(context).deleteMeal),
                          content: Text(
                              AppLocalizations.of(context).confirmDeleteMeal),
                          actions: [
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child:
                                    Text(AppLocalizations.of(context).cancel)),
                            TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(
                                    AppLocalizations.of(context).deleteMeal)),
                          ],
                        ));
                if (confirm == true) {
                  try {
                    if (!context.mounted) {
                      return;
                    }
                    final mealsNotifier = context.read<MealsNotifier>();
                    final favoriteNotifier = context.read<FavoritesNotifier>();
                    await mealsNotifier.deleteMeal(meal.id);
                    favoriteNotifier.removeMeal(meal
                        .id); // removeMeal return void and updates local state

                    if (!context.mounted) {
                      return;
                    }
                    Navigator.of(context).pop();
                  } catch (error) {
                    if (!context.mounted) {
                      return;
                    }
                    final message = error is MealException
                        ? error.localizedMessage(context)
                        : AppLocalizations.of(context).errorServerError;
                    ScaffoldMessenger.of(context)
                      ..clearSnackBars()
                      ..showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                  }
                }
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
            ),
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
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: meal.imageUrl,
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
              AppLocalizations.of(context).ingredientsTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 14),
            // Ingredients checkboxes
            ...meal.ingredients.map((ingredient) => CheckboxListTile(
                  value: _map[ingredient] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      _map[ingredient] = value ?? false;
                    });
                  },
                  title: Text(
                    ingredient,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                )),
            const SizedBox(height: 14),
            Text(
              AppLocalizations.of(context).stepsTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            ...meal.steps.map((step) => Padding(
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
