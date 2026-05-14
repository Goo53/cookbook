import 'package:flutter/material.dart';
import '../models/category.dart';
import '../generated/l10n/app_localizations.dart';

const availableCategories = [
  Category(
    id: 'c1',
    apiKey: 'Italian',
    color: Colors.red,
  ),
  Category(
    id: 'c2',
    apiKey: 'Quick & Easy',
    color: Colors.orange,
  ),
  Category(
    id: 'c3',
    apiKey: 'Hamburgers',
    color: Colors.amber,
  ),
  Category(
    id: 'c4',
    apiKey: 'German',
    color: Colors.blue,
  ),
  Category(
    id: 'c5',
    apiKey: 'Light & Lovely',
    color: Colors.green,
  ),
  Category(
    id: 'c6',
    apiKey: 'Exotic',
    color: Colors.purple,
  ),
  Category(
    id: 'c7',
    apiKey: 'Breakfast',
    color: Colors.brown,
  ),
  Category(
    id: 'c8',
    apiKey: 'Asian',
    color: Colors.teal,
  ),
];

String getCategoryApiKey(String categoryId) {
  final category = availableCategories.firstWhere(
    (cat) => cat.id == categoryId,
    orElse: () => const Category(id: '', apiKey: '', color: Colors.grey),
  );
  return category.apiKey;
}

String getCategoryDisplayName(String apiKey, BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return switch (apiKey) {
    'Italian' => l10n.categoryItalian,
    'Quick & Easy' => l10n.categoryQuickEasy,
    'Hamburgers' => l10n.categoryHamburgers,
    'German' => l10n.categoryGerman,
    'Light & Lovely' => l10n.categoryLightLovely,
    'Exotic' => l10n.categoryExotic,
    'Breakfast' => l10n.categoryBreakfast,
    'Asian' => l10n.categoryAsian,
    _ => apiKey,
  };
}
