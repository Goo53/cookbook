import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cookbook/state/locale_notifier.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocaleNotifier>().locale;

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      onSelected: (Locale locale) {
        context.read<LocaleNotifier>().setLocale(locale);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
        PopupMenuItem<Locale>(
          value: const Locale('en'),
          child: Row(
            children: [
              const Text('English'),
              if (currentLocale.languageCode == 'en')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check),
                ),
            ],
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('pl'),
          child: Row(
            children: [
              const Text('Polski'),
              if (currentLocale.languageCode == 'pl')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
