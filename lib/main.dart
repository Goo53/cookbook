import 'package:cookbook/screens/tabs.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cookbook/state/fav_notifier.dart';
//import 'state/fav_notifier.dart'; //adding it here Now context.watch / context.read works everywhere.

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 12, 94, 100),
    brightness: Brightness.dark,
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => FavoritesNotifier(),
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: theme, home: const TabsScreen() //Todo,
        );
  }
}
