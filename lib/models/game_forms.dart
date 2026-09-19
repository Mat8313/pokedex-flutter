import 'game.dart';
import 'pokedex_entry.dart';
import '../services/api_names.dart';

/// Insère dans un Pokédex les formes alternatives que le jeu contient.
///
/// Chaque forme suit son espèce, sous le même numéro : dans les jeux, Raichu
/// d'Alola n'a pas d'entrée propre, il partage celle de Raichu.
///
/// **Ce que ce découpage ne couvre pas.** Les méga-évolutions et les formes
/// Gigamax sont absentes du fichier : les données de la PokéAPI les marquent
/// « combat uniquement », et c'est exact — elles n'apparaissent dans aucun
/// Pokédex. Elles restent consultables sur la fiche de détail, qui les traite
/// à part depuis la session du 19/09.
List<PokedexEntry> withGameForms(List<PokedexEntry> entries, GameDex game) {
  final gameRank = _rankOf(game.versionGroup);
  if (gameRank < 0) return entries;

  final expanded = <PokedexEntry>[];

  for (final entry in entries) {
    expanded.add(entry);

    for (final form in ApiNames.forms(entry.speciesId)) {
      final introduction = form['vg'] as String;
      if (!isFormAvailableIn(introduction, game)) continue;

      expanded.add(
        PokedexEntry(
          entryNumber: entry.entryNumber,
          speciesId: entry.speciesId,
          name: form['name'] as String,
          availableInGame: entry.availableInGame,
          formId: form['id'] as int,
          formLabels: {
            'en': form['en'] as String,
            'fr': form['fr'] as String,
          },
        ),
      );
    }
  }

  return expanded;
}

/// Une forme existe dans un jeu à partir de la génération qui l'a introduite.
///
/// C'est une approximation, la même que celle qui date les sprites : elle ne
/// sait pas qu'une forme a pu être retirée d'un jeu ultérieur. Les formes
/// « Partenaire » de Let's Go en sont le contre-exemple évident, et sont donc
/// traitées à part.
bool isFormAvailableIn(String introduction, GameDex game) {
  if (introduction == game.versionGroup) return true;

  // Exclusives à Let's Go, et à rien d'autre.
  if (introduction == 'lets-go-pikachu-lets-go-eevee') return false;

  final gameRank = _rankOf(game.versionGroup);
  final introductionRank = _rankOf(introduction);

  return gameRank >= 0 && introductionRank >= 0 && introductionRank <= gameRank;
}

int _rankOf(String versionGroup) {
  final generation = versionGroupGenerations[versionGroup];

  return generation == null ? -1 : generationRank(generation);
}
