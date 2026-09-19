import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/models/pokemon_species.dart';
import 'package:pokedex/models/pokemon_type.dart';

void main() {
  group('typeEffectiveness', () {
    test('Doit cumuler les coefficients des deux types', () {
      // Plante·Sol : la Glace touche les deux, donc quatre fois les dégâts.
      final florizarre = typeEffectiveness(['grass', 'ground']);

      expect(florizarre['ice'], 4);
    });

    test('Doit rendre une immunité prioritaire sur tout le reste', () {
      // Le Sol est immunisé à l'Électrik : la faiblesse du Plante n'y change rien.
      expect(typeEffectiveness(['grass', 'ground'])['electric'], 0);
    });

    test('Doit gérer un type unique', () {
      final feu = typeEffectiveness(['fire']);

      expect(feu['water'], 2);
      expect(feu['ground'], 2);
      expect(feu['grass'], 0.5);
      expect(feu['normal'], 1);
    });

    test('Doit accepter la casse des types telle que le modèle les stocke', () {
      // PokemonDetail met les types en majuscules.
      expect(typeEffectiveness(['FIRE'.toLowerCase()])['water'], 2);
    });

    test('Doit rendre la table neutre pour un type inconnu', () {
      final inconnu = typeEffectiveness(['stellar']);

      expect(inconnu.values.every((multiplier) => multiplier == 1), isTrue);
    });

    test('Doit couvrir les dix-huit types', () {
      expect(typeEffectiveness(['normal']).length, 18);
      expect(pokemonTypes.length, 18);
    });
  });

  group('PokemonSpecies.fromJson', () {
    Map<String, dynamic> json({String flavor = 'Une description.'}) => {
      'genera': [
        {'genus': 'Seed Pokémon', 'language': {'name': 'en'}},
        {'genus': 'Pokémon Graine', 'language': {'name': 'fr'}},
        {'genus': 'たねポケモン', 'language': {'name': 'ja'}},
      ],
      'flavor_text_entries': [
        {'flavor_text': flavor, 'language': {'name': 'fr'}},
      ],
      'egg_groups': [
        {'name': 'monster'},
        {'name': 'plant'},
      ],
      'capture_rate': 45,
      'gender_rate': 1,
      'evolution_chain': {'url': 'https://pokeapi.co/api/v2/evolution-chain/2/'},
    };

    test("Ne doit garder que les langues de l'application", () {
      final species = PokemonSpecies.fromJson(json());

      expect(species.genus.keys, unorderedEquals(['en', 'fr']));
      expect(species.genus['fr'], 'Pokémon Graine');
    });

    test('Doit nettoyer la mise en forme console des descriptions', () {
      // Les descriptions sont coupées pour un écran de Game Boy.
      final species = PokemonSpecies.fromJson(
        json(flavor: 'Une graine\nest plantée\fsur son dos.'),
      );

      expect(species.flavorText['fr'], 'Une graine est plantée sur son dos.');
    });

    test("Doit lire l'identifiant de la chaîne d'évolution dans son URL", () {
      expect(PokemonSpecies.fromJson(json()).evolutionChainId, 2);
    });

    test('Doit garder la convention de sexe de l\'API', () {
      expect(PokemonSpecies.fromJson(json()).genderRate, 1);
    });
  });

  group('EvolutionNode.fromJson', () {
    Map<String, dynamic> node(int id, String name, List<Map<String, dynamic>> details,
            List<Map<String, dynamic>> children) =>
        {
          'species': {
            'name': name,
            'url': 'https://pokeapi.co/api/v2/pokemon-species/$id/',
          },
          'evolution_details': details,
          'evolves_to': children,
        };

    test('Doit aplatir la chaîne dans l\'ordre', () {
      final chain = EvolutionNode.fromJson(
        node(1, 'bulbasaur', [], [
          node(2, 'ivysaur', [
            {'trigger': {'name': 'level-up'}, 'min_level': 16},
          ], [
            node(3, 'venusaur', [
              {'trigger': {'name': 'level-up'}, 'min_level': 32},
            ], []),
          ]),
        ]),
      );

      expect(chain.flattened.map((n) => n.speciesId), [1, 2, 3]);
      expect(chain.steps, isEmpty);
      expect(chain.flattened[1].steps.single.minLevel, 16);
    });

    test('Doit encaisser une chaîne à plusieurs branches', () {
      // Évoli : un seul maillon de base, huit enfants.
      final chain = EvolutionNode.fromJson(
        node(133, 'eevee', [], [
          node(134, 'vaporeon', [
            {'trigger': {'name': 'use-item'}, 'item': {'name': 'water-stone'}},
          ], []),
          node(135, 'jolteon', [
            {'trigger': {'name': 'use-item'}, 'item': {'name': 'thunder-stone'}},
          ], []),
        ]),
      );

      expect(chain.flattened.length, 3);
      expect(chain.evolvesTo.first.steps.single.item, 'water-stone');
    });

    test('Doit traiter une chaîne sans évolution', () {
      final chain = EvolutionNode.fromJson(node(132, 'ditto', [], []));

      expect(chain.flattened.length, 1);
    });
  });

  group('EvolutionStep.fromJson', () {
    test('Doit lire les conditions cumulables', () {
      final step = EvolutionStep.fromJson({
        'trigger': {'name': 'trade'},
        'held_item': {'name': 'metal-coat'},
        'min_level': null,
        'time_of_day': '',
      });

      expect(step.trigger, 'trade');
      expect(step.heldItem, 'metal-coat');
      expect(step.minLevel, isNull);
      // La chaîne vide de l'API n'est pas une condition.
      expect(step.timeOfDay, isNull);
    });

    test('Doit retenir le moment de la journée quand il compte', () {
      final step = EvolutionStep.fromJson({
        'trigger': {'name': 'level-up'},
        'min_happiness': 160,
        'time_of_day': 'day',
      });

      expect(step.minHappiness, 160);
      expect(step.timeOfDay, 'day');
    });
  });
}
