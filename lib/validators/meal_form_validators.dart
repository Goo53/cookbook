class MealFormValidators {
  static String? requiredText(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? positiveInt(String? value, String message) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null || number <= 0) {
      return message;
    }
    return null;
  }

  static String? nonEmptyLines(String? value, String message) {
    final lines = (value ?? '')
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty);

    if (lines.isEmpty) {
      return message;
    }
    return null;
  }
}
