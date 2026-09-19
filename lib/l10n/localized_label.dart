import 'package:flutter/widgets.dart';

/// Un libellé de référentiel dans les langues de l'application.
///
/// Les noms d'espèces, de types ou de talents viennent de l'API, qui les sert
/// déjà traduits. Restent nos propres référentiels — jeux, générations,
/// Pokédex, régions — dont les libellés vivent dans le code : ils sont portés
/// ici, au plus près de la donnée, plutôt que dans les fichiers `.arb`, qui ne
/// savent pas répondre à une clé calculée à l'exécution.
///
/// Ajouter une langue veut dire ajouter un champ et repasser sur chaque entrée.
/// C'est assumé à deux langues ; au-delà, il faudra une table par code de
/// langue.
@immutable
class LocalizedLabel {
  final String en;
  final String fr;

  const LocalizedLabel(this.en, this.fr);

  /// Replie sur l'anglais pour toute langue non traduite.
  String of(Locale locale) => locale.languageCode == 'fr' ? fr : en;

  @override
  bool operator ==(Object other) =>
      other is LocalizedLabel && other.en == en && other.fr == fr;

  @override
  int get hashCode => Object.hash(en, fr);
}

/// Raccourci de lecture depuis un widget.
extension LocalizedLabelContext on BuildContext {
  String label(LocalizedLabel label) => label.of(Localizations.localeOf(this));
}
