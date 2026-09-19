import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'screens/home_page.dart';
import 'services/api_names.dart';
import 'settings/app_settings.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  // Les réglages et les noms d'espèces sont lus avant le premier rendu : les
  // grilles affichent des noms traduits dès la première image, sans clignoter.
  WidgetsFlutterBinding.ensureInitialized();
  await ApiNames.load();
  final settings = await AppSettings.load();

  runApp(PokedexApp(settings: settings));
}

class PokedexApp extends StatelessWidget {
  final AppSettings settings;

  const PokedexApp({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      settings: settings,
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          locale: settings.locale,
          supportedLocales: AppSettings.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.themeMode,
          home: const HomePage(),
        ),
      ),
    );
  }
}
