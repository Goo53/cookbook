enum Complexity { simple, challenging, hard }

enum Affordability { affordable, pricey, luxurious }

class Meal {
  const Meal({
    required this.id,
    required this.categories,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.isMeat,
    required this.isVegetarian,
  });

  final String id;
  final List<String> categories;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  final bool isMeat;
  final bool isVegetarian;

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'] ?? '',
      duration: json['duration'],
      complexity: Complexity.values.firstWhere(
        (e) => e.name == json['complexity'],
      ),
      affordability: Affordability.values.firstWhere(
        (e) => e.name == json['affordability'],
      ),
      isMeat: json['isMeat'],
      isVegetarian: json['isVegetarian'],
      categories: List<String>.from(json['categories'] ?? []),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'duration': duration,
      'complexity': complexity.name,
      'affordability': affordability.name,
      'isMeat': isMeat,
      'isVegetarian': isVegetarian,
      'categories': categories,
      'ingredients': ingredients,
      'steps': steps,
    };
  }
}
