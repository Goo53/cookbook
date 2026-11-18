import 'package:material_ui/material_ui.dart';

class Category {
  const Category(
      {required this.id, required this.apiKey, this.color = Colors.amber});

  final String id;
  final String apiKey; // english name send to backend; never localized
  final Color color;
}
