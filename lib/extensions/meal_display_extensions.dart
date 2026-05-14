import 'package:cookbook/models/meal.dart';
import '../generated/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension ComplexityDisplay on Complexity {
  String displayLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      Complexity.simple => l10n.complexitySimple,
      Complexity.challenging => l10n.complexityChallenging,
      Complexity.hard => l10n.complexityHard,
    };
  }
}

extension AffordabilityDisplay on Affordability {
  String displayLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      Affordability.affordable => l10n.affordabilityAffordable,
      Affordability.pricey => l10n.affordabilityPricey,
      Affordability.luxurious => l10n.affordabilityLuxurious,
    };
  }
}
