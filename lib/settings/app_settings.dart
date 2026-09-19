import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Sort réservé, dans le Pokédex National d'un jeu, aux espèces que ce jeu ne
/// contient pas.
enum MissingSpeciesDisplay {
  /// Grisées et désaturées : elles gardent leur numéro, comme le `-----` du
  /// vrai Pokédex.
  greyed,

  /// Retirées de la grille. La numérotation saute alors, c'est assumé.
  hidden,

  /// Affichées comme les autres, sans distinction.
  shown,
}

/// Les réglages de l'application, conservés d'un lancement à l'autre.
///
/// Un [ChangeNotifier] plutôt qu'une bibliothèque d'état : il y a quatre
/// réglages, et `ListenableBuilder` suffit à reconstruire l'application quand
/// l'un d'eux change.
class AppSettings extends ChangeNotifier {
  static const _keyLanguage = 'language';
  static const _keyThemeMode = 'themeMode';
  static const _keyShiny = 'shinyByDefault';
  static const _keyMissing = 'missingSpecies';

  /// Les langues que l'interface sait parler. L'anglais est le repli.
  static const List<Locale> supportedLocales = [Locale('en'), Locale('fr')];

  final SharedPreferences _preferences;

  Locale _locale;
  ThemeMode _themeMode;
  bool _shinyByDefault;
  MissingSpeciesDisplay _missingSpecies;

  /// Positionnel parce que Dart interdit les paramètres nommés commençant par
  /// un tiret bas : les nommer obligerait à réassigner chaque champ dans la
  /// liste d'initialisation, ce que l'analyseur reproche à juste titre.
  AppSettings._(
    this._preferences,
    this._locale,
    this._themeMode,
    this._shinyByDefault,
    this._missingSpecies,
  );

  /// Relit les réglages du disque. L'anglais et le thème sombre sont les
  /// valeurs de départ : l'application ne suit pas la langue du téléphone.
  static Future<AppSettings> load() async {
    final preferences = await SharedPreferences.getInstance();

    return AppSettings._(
      preferences,
      Locale(preferences.getString(_keyLanguage) ?? 'en'),
      ThemeMode.values.byNameOr(preferences.getString(_keyThemeMode), ThemeMode.dark),
      preferences.getBool(_keyShiny) ?? false,
      MissingSpeciesDisplay.values.byNameOr(
        preferences.getString(_keyMissing),
        MissingSpeciesDisplay.greyed,
      ),
    );
  }

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  bool get shinyByDefault => _shinyByDefault;
  MissingSpeciesDisplay get missingSpecies => _missingSpecies;

  set locale(Locale value) {
    if (value == _locale) return;
    _locale = value;
    _preferences.setString(_keyLanguage, value.languageCode);
    notifyListeners();
  }

  set themeMode(ThemeMode value) {
    if (value == _themeMode) return;
    _themeMode = value;
    _preferences.setString(_keyThemeMode, value.name);
    notifyListeners();
  }

  set shinyByDefault(bool value) {
    if (value == _shinyByDefault) return;
    _shinyByDefault = value;
    _preferences.setBool(_keyShiny, value);
    notifyListeners();
  }

  set missingSpecies(MissingSpeciesDisplay value) {
    if (value == _missingSpecies) return;
    _missingSpecies = value;
    _preferences.setString(_keyMissing, value.name);
    notifyListeners();
  }
}

extension<T extends Enum> on List<T> {
  /// `byName` lève si la valeur stockée n'existe plus — ce qui arrive après
  /// avoir renommé une constante. On retombe alors sur la valeur par défaut.
  T byNameOr(String? name, T fallback) {
    if (name == null) return fallback;

    for (final value in this) {
      if (value.name == name) return value;
    }
    return fallback;
  }
}

/// Rend les réglages lisibles depuis n'importe quel widget, et reconstruit
/// ceux qui en dépendent quand ils changent.
class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({super.key, required AppSettings settings, required super.child})
    : super(notifier: settings);

  static AppSettings of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppSettingsScope>()!.notifier!;
}

extension AppSettingsContext on BuildContext {
  AppSettings get settings => AppSettingsScope.of(this);
}
