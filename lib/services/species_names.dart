import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Les noms d'espèces traduits, chargés une fois depuis les assets.
///
/// Les grilles affichent des centaines d'entrées : aller les chercher sur
/// `/pokemon-species` ferait autant de requêtes. Le fichier est donc produit
/// hors ligne depuis `pokemon_species_names.csv` du dépôt PokéAPI, qui donne
/// les 1025 espèces dans toutes les langues d'un coup.
class SpeciesNames {
  static const String _assetPath = 'assets/i18n/species_names.json';

  static Map<String, Map<String, String>> _byLanguage = const {};

  /// À appeler une fois au démarrage, avant `runApp`.
  static Future<void> load() async {
    final raw = jsonDecode(await rootBundle.loadString(_assetPath)) as Map<String, dynamic>;

    _byLanguage = {
      for (final entry in raw.entries)
        entry.key: (entry.value as Map<String, dynamic>).map(
          (id, name) => MapEntry(id, name as String),
        ),
    };
  }

  /// Nom traduit de l'espèce, ou [apiName] mis en forme quand elle est absente
  /// du fichier — c'est le cas des formes alternatives, dont l'identifiant
  /// dépasse 10000 et qui n'ont pas de nom d'espèce propre.
  static String of(int speciesId, Locale locale, {required String apiName}) {
    final table = _byLanguage[locale.languageCode] ?? _byLanguage['en'];

    return table?['$speciesId'] ?? prettify(apiName);
  }

  /// `mr-mime` → `Mr Mime`. Dernier recours, quand aucune traduction n'existe.
  static String prettify(String apiName) => apiName
      .split('-')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

extension SpeciesNamesContext on BuildContext {
  /// Nom traduit d'une espèce, depuis un widget.
  String speciesName(int speciesId, String apiName) =>
      SpeciesNames.of(speciesId, Localizations.localeOf(this), apiName: apiName);
}
