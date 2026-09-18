import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/models/sprite_set.dart';

void main() {
  group('SpriteSet.variant', () {
    const complet = SpriteSet(
      frontDefault: 'default.png',
      frontShiny: 'shiny.png',
      frontFemale: 'female.png',
      frontShinyFemale: 'shiny_female.png',
    );

    test('Doit renvoyer la variante exacte quand elle existe', () {
      expect(complet.variant(shiny: false, female: false), 'default.png');
      expect(complet.variant(shiny: true, female: false), 'shiny.png');
      expect(complet.variant(shiny: false, female: true), 'female.png');
      expect(complet.variant(shiny: true, female: true), 'shiny_female.png');
    });

    test('Doit lâcher le sexe avant le chromatique quand la variante manque', () {
      const sansFemelle = SpriteSet(frontDefault: 'default.png', frontShiny: 'shiny.png');

      expect(sansFemelle.variant(shiny: true, female: true), 'shiny.png');
      expect(sansFemelle.variant(shiny: false, female: true), 'default.png');
    });

    test('Doit se rabattre sur n\'importe quelle variante disponible en dernier recours', () {
      const shinyUniquement = SpriteSet(frontShiny: 'shiny.png');

      expect(shinyUniquement.variant(shiny: false, female: false), 'shiny.png');
    });

    test('Doit être vide quand aucune variante n\'est renseignée', () {
      const vide = SpriteSet();

      expect(vide.isEmpty, isTrue);
      expect(vide.variant(shiny: false, female: false), isNull);
    });
  });

  group('parseSpritesByGeneration', () {
    test('Doit imposer l\'ordre chronologique quel que soit l\'ordre du JSON', () {
      final versions = {
        'generation-iii': {
          'emerald': {'front_default': 'emeraude.png'},
        },
        'generation-i': {
          'red-blue': {'front_default': 'rouge_bleu.png'},
        },
      };

      final result = parseSpritesByGeneration(versions);

      expect(result.map((g) => g.generation.key), ['generation-i', 'generation-iii']);
    });

    test('Doit écarter les jeux sans aucun sprite', () {
      final versions = {
        'generation-ii': {
          'gold': {'front_default': 'or.png'},
          'silver': {'front_default': null},
        },
      };

      final result = parseSpritesByGeneration(versions);

      expect(result.single.games.map((g) => g.game.spriteKey), ['gold']);
    });

    test('Doit écarter une génération entièrement vide', () {
      final versions = {
        'generation-ii': {
          'gold': {'front_default': null},
        },
      };

      expect(parseSpritesByGeneration(versions), isEmpty);
    });

    test('Doit corriger l\'extension des jeux stockes en gif', () {
      // L'API annonce du .png pour Ultra-Soleil/Ultra-Lune alors que la banque
      // ne contient que des .gif : l'URL declaree renvoie un 404.
      final versions = {
        'generation-vii': {
          'ultra-sun-ultra-moon': {
            'front_default': 'https://exemple/ultra-sun-ultra-moon/1.png',
            'front_shiny': 'https://exemple/ultra-sun-ultra-moon/shiny/1.png',
          },
        },
      };

      final sprites = parseSpritesByGeneration(versions).single.games.single.sprites;

      expect(sprites.frontDefault, endsWith('/1.gif'));
      expect(sprites.frontShiny, endsWith('/shiny/1.gif'));
    });

    test('Doit laisser les autres jeux en png', () {
      final versions = {
        'generation-i': {
          'red-blue': {'front_default': 'https://exemple/red-blue/1.png'},
        },
      };

      final sprites = parseSpritesByGeneration(versions).single.games.single.sprites;

      expect(sprites.frontDefault, endsWith('/1.png'));
    });

    test('Doit ignorer les cles inconnues de l\'API, comme les icones de menu', () {
      final versions = {
        'generation-vii': {
          'icons': {'front_default': 'icone.png'},
          'ultra-sun-ultra-moon': {'front_default': 'usul.png'},
        },
      };

      final result = parseSpritesByGeneration(versions);

      expect(result.single.games.map((g) => g.game.spriteKey), ['ultra-sun-ultra-moon']);
    });
  });

  group('spritesSinceVersionGroup', () {
    List<GenerationSprites> spritesDeTroisGenerations() => parseSpritesByGeneration({
      'generation-i': {
        'red-blue': {'front_default': 'rb.png'},
      },
      'generation-v': {
        'black-white': {'front_default': 'nb.png'},
      },
      'generation-viii': {
        'brilliant-diamond-shining-pearl': {'front_default': 'bdsp.png'},
      },
    });

    test('Doit masquer les generations anterieures a l\'apparition de la forme', () {
      // Le Gigamax apparait avec Epee-Bouclier : un sprite au style Noir-Blanc
      // existe dans la banque, mais la forme n'existait pas en generation V.
      final result = spritesSinceVersionGroup(spritesDeTroisGenerations(), 'sword-shield');

      expect(result.map((g) => g.generation.key), ['generation-viii']);
    });

    test('Doit tout garder pour une forme presente des l\'origine', () {
      final result = spritesSinceVersionGroup(spritesDeTroisGenerations(), 'red-blue');

      expect(result.length, 3);
    });

    test('Doit dater la forme par sa generation, pas par son jeu', () {
      // Rubis Omega-Saphir Alpha se deroule a Hoenn mais appartient a la gen VI :
      // une forme qui y apparait ne doit pas afficher de sprites de gen V.
      final result = spritesSinceVersionGroup(
        spritesDeTroisGenerations(),
        'omega-ruby-alpha-sapphire',
      );

      expect(result.map((g) => g.generation.key), ['generation-viii']);
    });

    test('Ne doit rien filtrer quand le jeu d\'introduction est inconnu', () {
      expect(spritesSinceVersionGroup(spritesDeTroisGenerations(), null).length, 3);
      expect(spritesSinceVersionGroup(spritesDeTroisGenerations(), 'jeu-invente').length, 3);
    });
  });

}
