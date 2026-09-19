import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Les noms traduits que l'API ne sert qu'une entrée à la fois.
///
/// Une grille affiche des centaines d'espèces, une fiche cite des talents et
/// des objets : aller les chercher un par un ferait autant de requêtes. Ces
/// tables sont donc produites hors ligne depuis les fichiers CSV du dépôt
/// PokéAPI, qui donnent toutes les langues d'un coup, et chargées au démarrage.
class ApiNames {
  static const Map<String, String> _assets = {
    'species': 'assets/i18n/species_names.json',
    'ability': 'assets/i18n/ability_names.json',
    'item': 'assets/i18n/item_names.json',
  };

  /// Les types de chaque espèce, pour filtrer une grille sans requête.
  static const String _typesAsset = 'assets/i18n/pokemon_types.json';

  static Map<String, List<String>> _speciesTypes = const {};

  static final Map<String, Map<String, Map<String, String>>> _tables = {};

  /// À appeler une fois au démarrage, avant `runApp`.
  static Future<void> load() async {
    for (final entry in _assets.entries) {
      final raw = jsonDecode(await rootBundle.loadString(entry.value)) as Map<String, dynamic>;

      _tables[entry.key] = {
        for (final language in raw.entries)
          language.key: (language.value as Map<String, dynamic>).map(
            (key, name) => MapEntry(key, name as String),
          ),
      };
    }

    final types = jsonDecode(await rootBundle.loadString(_typesAsset)) as Map<String, dynamic>;
    _speciesTypes = {
      for (final entry in types.entries)
        entry.key: [for (final type in entry.value as List) type as String],
    };
  }

  static String _lookup(String table, String key, Locale locale, String fallback) {
    final byLanguage = _tables[table];
    final names = byLanguage?[locale.languageCode] ?? byLanguage?['en'];

    return names?[key] ?? prettify(fallback);
  }

  /// Nom traduit de l'espèce, ou [apiName] mis en forme quand elle est absente
  /// de la table — c'est le cas des formes alternatives, dont l'identifiant
  /// dépasse 10000 et qui n'ont pas de nom d'espèce propre.
  static String species(int speciesId, Locale locale, {required String apiName}) =>
      _lookup('species', '$speciesId', locale, apiName);

  static String ability(int abilityId, Locale locale, {required String apiName}) =>
      _lookup('ability', '$abilityId', locale, apiName);

  /// Les objets sont indexés par identifiant d'API (`fire-stone`), celui que
  /// renvoient les chaînes d'évolution.
  static String item(String identifier, Locale locale) =>
      _lookup('item', identifier, locale, identifier);

  /// Les types d'une espèce, en clés d'API minuscules. Vide pour une forme
  /// alternative, absente de la table.
  static List<String> types(int speciesId) => _speciesTypes['$speciesId'] ?? const [];

  /// `mr-mime` → `Mr Mime`. Dernier recours, quand aucune traduction n'existe.
  static String prettify(String apiName) => apiName
      .split('-')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

extension ApiNamesContext on BuildContext {
  Locale get _locale => Localizations.localeOf(this);

  /// Nom traduit d'une espèce, depuis un widget.
  String speciesName(int speciesId, String apiName) =>
      ApiNames.species(speciesId, _locale, apiName: apiName);

  String abilityName(int abilityId, String apiName) =>
      ApiNames.ability(abilityId, _locale, apiName: apiName);

  String itemName(String identifier) => ApiNames.item(identifier, _locale);
}
