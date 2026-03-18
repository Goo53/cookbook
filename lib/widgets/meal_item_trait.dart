import 'package:flutter/material.dart';

class MealItemTrait extends StatelessWidget {
  const MealItemTrait(
      {super.key, required this.string, required this.iconData});

  final IconData iconData;
  final String string;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          size: 17,
          color: Colors.white,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          string,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
