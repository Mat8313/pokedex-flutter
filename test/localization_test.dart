import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/l10n/localized_label.dart';
import 'package:pokedex/models/game.dart';
import 'package:pokedex/services/species_names.dart';

void main() {
  group('LocalizedLabel', () {
    const label = LocalizedLabel('Gold · Silver', 'Or · Argent');

    test('Doit rendre la langue demandée', () {
      expect(label.of(const Locale('fr')), 'Or · Argent');
      expect(label.of(const Locale('en')), 'Gold · Silver');
    });

    test("Doit se replier sur l'anglais pour une langue non traduite", () {
      expect(label.of(const Locale('de')), 'Gold · Silver');
    });

    test('Doit ignorer le pays', () {
      expect(label.of(const Locale('fr', 'CA')), 'Or · Argent');
    });
  });

  group('Référentiels traduits', () {
    /// Un libellé vide passerait inaperçu à l'exécution : il ne planterait pas,
    /// il afficherait juste du vide.
    void expectTranslated(LocalizedLabel label, String context) {
      expect(label.en, isNotEmpty, reason: '$context : anglais manquant');
      expect(label.fr, isNotEmpty, reason: '$context : français manquant');
    }

    test('Chaque jeu et chacun de ses Pokédex est traduit', () {
      for (final game in gamePokedexes) {
        expectTranslated(game.label, game.versionGroup);
        for (final dex in game.pokedexes) {
          expectTranslated(dex.label, '${game.versionGroup}/${dex.apiName}');
        }
      }
    });

    test('Chaque génération et chaque jeu du référentiel des sprites est traduit', () {
      for (final generation in pokemonGenerations) {
        expectTranslated(generation.label, generation.key);
        for (final game in generation.games) {
          expectTranslated(game.label, game.spriteKey);
        }
      }
    });
  });

  group('SpeciesNames.prettify', () {
    test("Doit mettre en forme un identifiant d'API", () {
      expect(SpeciesNames.prettify('mr-mime'), 'Mr Mime');
      expect(SpeciesNames.prettify('raichu-alola'), 'Raichu Alola');
      expect(SpeciesNames.prettify('pikachu'), 'Pikachu');
    });

    test('Doit encaisser les tirets superflus', () {
      expect(SpeciesNames.prettify('ho--oh'), 'Ho Oh');
      expect(SpeciesNames.prettify(''), '');
    });
  });
}
