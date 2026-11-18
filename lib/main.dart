import 'package:cookbook/screens/tabs.dart';
import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cookbook/state/fav_notifier.dart';
import 'package:cookbook/state/locale_notifier.dart';
import 'generated/l10n/app_localizations.dart'; //import 'state/fav_notifier.dart'; //adding it here Now context.watch / context.read works everywhere.
import 'services/meal_repository.dart';
import 'services/fake_meal_repository.dart';
import 'services/meal_service.dart';
import 'state/meals_notifier.dart';

const USE_FAKE_MEAL_REPOSITORY =
    bool.fromEnvironment('useFakeRepository', defaultValue: true);

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 12, 94, 100),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(MultiProvider(
    providers: [
      Provider<MealRepository>(
        create: (_) => USE_FAKE_MEAL_REPOSITORY
            ? FakeMealRepository()
            : MealService(), //dev flag to switch between fake and real repository
        dispose: (_, repository) {
          if (repository is MealService) {
            repository.close();
          }
        },
      ),
      ChangeNotifierProvider(
          create: (context) => MealsNotifier(context.read<MealRepository>())),
      ChangeNotifierProvider(
          create: (context) =>
              FavoritesNotifier(context.read<MealRepository>())),
      ChangeNotifierProvider(create: (_) => LocaleNotifier()),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleNotifier>().locale;

    return MaterialApp(
      locale: locale,
      theme: theme,
      home: const TabsScreen(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: const [Locale('en'), Locale('pl')],
    );
  }
}
