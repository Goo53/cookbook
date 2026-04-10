import 'package:cookbook/widgets/category_grid_item.dart';
import '../data/available_categories.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(" Categories: "),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: availableCategories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemBuilder: (context, index) {
          final category = availableCategories[index];
          return CategoryGridItem(category: category);
        },
      ), //   Optimise as rendering only visible when you have many GridView.builder(gridDelegate: gridDelegate, itemBuilder: itemBuilder),
    );
  }
}

// GridView build everything immediately -> .builder only visible
