import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/models/pokemon_forms.dart';

void main() {
  group('PokemonForm Model Tests', () {
    test('Doit parser une forme "nue" (endpoint pokemon.forms)', () {
      final json = {
        'name': 'bulbasaur',
        'url': 'https://pokeapi.co/api/v2/pokemon-form/1/',
      };

      final form = PokemonForm.fromJson(json);

      expect(form.id, 1);
      expect(form.name, 'bulbasaur');
    });

    test('Doit parser une forme "enveloppée" (endpoint pokemon-species.varieties)', () {
      final json = {
        'is_default': false,
        'pokemon': {
          'name': 'venusaur-mega',
          'url': 'https://pokeapi.co/api/v2/pokemon/10033/',
        },
      };

      final form = PokemonForm.fromJson(json);

      expect(form.id, 10033);
      expect(form.name, 'venusaur-mega');
    });
  });
}
