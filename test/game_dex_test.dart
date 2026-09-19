import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/models/game.dart';

/// Invariants du référentiel des Pokédex par jeu. Ces tests n'exercent aucune
/// logique : ils attrapent l'oubli au moment d'ajouter un jeu à la liste.
void main() {
  group('Référentiel gamePokedexes', () {
    test('Aucun version-group en double', () {
      final versionGroups = gamePokedexes
          .map((game) => game.versionGroup)
          .toList();

      expect(versionGroups.toSet().length, versionGroups.length);
    });

    test('Chaque jeu est daté par versionGroupGenerations', () {
      for (final game in gamePokedexes) {
        expect(
          game.generationKey,
          isNotNull,
          reason: '${game.versionGroup} est absent de versionGroupGenerations',
        );
      }
    });

    test('Chaque génération référencée existe dans pokemonGenerations', () {
      for (final game in gamePokedexes) {
        expect(
          generationRank(game.generationKey!),
          greaterThanOrEqualTo(0),
          reason: '${game.versionGroup} pointe une génération inconnue',
        );
      }
    });

    test(
      'Aucun jeu sans Pokédex : Colosseum et XD ne sont pas dans la liste',
      () {
        for (final game in gamePokedexes) {
          expect(game.pokedexes, isNotEmpty, reason: game.versionGroup);
        }
        expect(
          gamePokedexes.map((game) => game.versionGroup),
          isNot(anyElement(anyOf('colosseum', 'xd'))),
        );
      },
    );

    test("Aucun Pokédex en double à l'intérieur d'un même jeu", () {
      for (final game in gamePokedexes) {
        final names = game.pokedexes.map((dex) => dex.apiName).toList();

        expect(names.toSet().length, names.length, reason: game.versionGroup);
      }
    });

    test('Un même Pokédex peut en revanche servir à plusieurs jeux', () {
      // Diamant·Perle (gen IV) et Diamant Étincelant·Perle Scintillante
      // (gen VIII) partagent original-sinnoh : ce n'est pas une anomalie.
      final sinnoh = gamePokedexes
          .where(
            (game) =>
                game.pokedexes.any((dex) => dex.apiName == 'original-sinnoh'),
          )
          .map((game) => game.versionGroup);

      expect(
        sinnoh,
        containsAll(['diamond-pearl', 'brilliant-diamond-shining-pearl']),
      );
    });
    test(
      'Le plafond du Pokédex National, quand il existe, est un numéro valide',
      () {
        for (final game in gamePokedexes) {
          final ceiling = game.nationalDexMax;
          if (ceiling == null) continue;

          expect(ceiling, greaterThan(0), reason: game.versionGroup);
          expect(ceiling, lessThanOrEqualTo(1025), reason: game.versionGroup);
        }
      },
    );

    test("Les jeux dépourvus de Pokédex National n'en annoncent pas", () {
      // Rouge·Bleu : son Pokédex de Kanto est déjà la numérotation nationale.
      // Depuis la génération VII, le Pokédex National a disparu des jeux.
      const sansNational = [
        'red-blue',
        'yellow',
        'sun-moon',
        'ultra-sun-ultra-moon',
        'lets-go-pikachu-lets-go-eevee',
        'sword-shield',
        'legends-arceus',
        'scarlet-violet',
        'legends-za',
        'champions',
      ];

      for (final versionGroup in sansNational) {
        final game = gamePokedexes.firstWhere(
          (g) => g.versionGroup == versionGroup,
        );

        expect(game.nationalDexMax, isNull, reason: versionGroup);
      }
    });

    test('Le plafond suit le jeu, pas sa génération', () {
      // Diamant Étincelant·Perle Scintillante est un jeu de génération VIII,
      // mais c'est un remake : son national s'arrête à Arceus.
      final remake = gamePokedexes.firstWhere(
        (game) => game.versionGroup == 'brilliant-diamond-shining-pearl',
      );

      expect(remake.generationKey, 'generation-viii');
      expect(remake.nationalDexMax, 493);
    });
  });
}
