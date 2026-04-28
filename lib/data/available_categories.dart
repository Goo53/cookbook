import 'package:flutter/material.dart';
import '../models/category.dart';

const availableCategories = [
  Category(
    id: 'c1',
    title: 'Italian',
    color: Colors.red,
  ),
  Category(
    id: 'c2',
    title: 'Quick & Easy',
    color: Colors.orange,
  ),
  Category(
    id: 'c3',
    title: 'Hamburgers',
    color: Colors.amber,
  ),
  Category(
    id: 'c4',
    title: 'German',
    color: Colors.blue,
  ),
  Category(
    id: 'c5',
    title: 'Light & Lovely',
    color: Colors.green,
  ),
  Category(
    id: 'c6',
    title: 'Exotic',
    color: Colors.purple,
  ),
  Category(
    id: 'c7',
    title: 'Breakfast',
    color: Colors.brown,
  ),
  Category(
    id: 'c8',
    title: 'Asian',
    color: Colors.teal,
  ),
];

String getCategoryName(String categoryId) {
  final category = availableCategories.firstWhere(
    (cat) => cat.id == categoryId,
    orElse: () => const Category(id: '', title: '', color: Colors.grey),
  );
  return category.title;
}
