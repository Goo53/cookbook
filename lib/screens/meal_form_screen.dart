import 'package:cookbook/data/available_categories.dart';
import 'package:cookbook/extensions/meal_display_extensions.dart';
import 'package:cookbook/validators/meal_form_validators.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/models/meal.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:cookbook/generated/l10n/app_localizations.dart';
import 'package:cookbook/services/meal_service.dart';

// pending localizations
class MealFormScreen extends StatefulWidget {
  const MealFormScreen({
    super.key,
    this.meal,
  });

  final Meal? meal;

  @override
  State<MealFormScreen> createState() => _MealFormScreenState();
}

class _MealFormScreenState extends State<MealFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _durationController;
  late final TextEditingController _ingredientsController;
  late final TextEditingController _stepsController;

  Complexity? _selectedComplexity;
  Affordability? _selectedAffordability;
  late final Set<String> _selectedCategories;
  bool _isMeat = false;
  bool _isVegetarian = false;
  bool _isSaving = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // if meal == null => selectedScreen==AddMeal;
    super.initState();
    final meal = widget.meal;
    _titleController = TextEditingController(text: meal?.title ?? '');
    _imageUrlController = TextEditingController(text: meal?.imageUrl ?? '');
    _durationController =
        TextEditingController(text: meal?.duration.toString() ?? '');
    _ingredientsController =
        TextEditingController(text: meal?.ingredients.join('\n') ?? '');
    _stepsController =
        TextEditingController(text: meal?.steps.join('\n') ?? '');
    _selectedCategories = meal?.categories.toSet() ?? <String>{};
    _isMeat = meal?.isMeat ?? false;
    _isVegetarian = meal?.isVegetarian ?? false;
    _selectedComplexity = meal?.complexity;
    _selectedAffordability = meal?.affordability;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _durationController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  List<String> _linesFrom(String value) {
    return value
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  Future<void> _saveMeal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Choose at least one category")));
      return;
    }
    setState(() {
      _isSaving = true;
    });

    final meal = Meal(
      id: widget.meal?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      duration: int.parse(_durationController.text.trim()),
      complexity: _selectedComplexity!,
      affordability: _selectedAffordability!,
      isMeat: _isMeat,
      isVegetarian: _isVegetarian,
      categories: _selectedCategories.toList(),
      ingredients: _linesFrom(_ingredientsController.text),
      steps: _linesFrom(_stepsController.text),
    );
    try {
      if (widget.meal == null) {
        await MealService.addMeal(meal);
      } else {
        await MealService.updateMeal(widget.meal!.id, meal);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.meal != null;
    final imageUrl = _imageUrlController.text.trim();
    return Scaffold(
        appBar: AppBar(
          title: Text(isEditing
              ? AppLocalizations.of(context).editMeal
              : AppLocalizations.of(context)
                  .addMeal), // Add meal / edited meal.title
          actions: [
            IconButton(
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              onPressed: _isSaving ? null : _saveMeal,
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'title'),
                controller: _titleController,
                validator: (value) =>
                    MealFormValidators.requiredText(value, 'Need title'),
              ),
              TextFormField(
                controller: _imageUrlController,
                validator: (value) =>
                    MealFormValidators.requiredText(value, "Need Image Url"),
                decoration: const InputDecoration(labelText: 'Image URL'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(
                height: 14,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: imageUrl.isEmpty
                        ? Container(
                            height: 180,
                            alignment: Alignment.center,
                            color: Colors.grey[800],
                            child: const Icon(Icons.image, size: 48),
                          )
                        : CachedNetworkImage(
                            imageUrl: imageUrl,
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
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => MealFormValidators.positiveInt(
                    value, 'Duration must be greater than 0'),
              ),
              const SizedBox(
                height: 14,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                    labelText: 'Complexity', border: OutlineInputBorder()),
                initialValue: _selectedComplexity,
                items: Complexity.values
                    .map((complexity) => DropdownMenuItem(
                          value: complexity,
                          child: Text(complexity.displayLabel(context)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedComplexity = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please choose complexity';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 14,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Affordability',
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedAffordability,
                items: Affordability.values
                    .map((affordability) => DropdownMenuItem(
                          value: affordability,
                          child: Text(affordability.displayLabel(context)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAffordability = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please choose affordability';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                AppLocalizations.of(context).categoriesTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(
                height: 8,
              ),
              ...availableCategories.map(
                (category) => CheckboxListTile(
                  title: Text(getCategoryDisplayName(category.apiKey, context)),
                  value: _selectedCategories.contains(category.apiKey),
                  onChanged: (isChecked) {
                    setState(() {
                      if (isChecked ?? false) {
                        _selectedCategories.add(category.apiKey);
                      } else {
                        _selectedCategories.remove(category.apiKey);
                      }
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              SwitchListTile(
                title: const Text('Meat'),
                value: _isMeat,
                onChanged: (value) {
                  setState(() {
                    _isMeat = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Vegetarian'),
                value: _isVegetarian,
                onChanged: (value) {
                  setState(() {
                    _isVegetarian = value;
                  });
                },
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                AppLocalizations.of(context).ingredientsTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _ingredientsController,
                validator: (value) => MealFormValidators.nonEmptyLines(
                    value, "Add at least one ingredient"),
                maxLines: 10,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 14),
              Text(
                AppLocalizations.of(context).stepsTitle,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _stepsController,
                validator: (value) => MealFormValidators.nonEmptyLines(
                    value, 'Add at least one step'),
                maxLines: 10,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              )
            ],
          ),
        ));
  }
}
