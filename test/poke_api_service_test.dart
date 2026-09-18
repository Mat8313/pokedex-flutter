import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/services/poke_api_service.dart';

import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

// On crée une classe vide qui copie le comportement d'un http.Client grâce à Mocktail
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('PokeApiService Tests (Réseau factice)', () {
    test(
      'Doit récupérer une liste de Pokémon valide depuis la PokéAPI',
      () async {
        MockHttpClient fakeClient = MockHttpClient();
        int limit = 151;
        int offset = 0;
        final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset');
        http.Response fakeResponse = http.Response(
          '{"results": [{"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"}]}',
          200,
        );
        when(() => fakeClient.get(url)).thenAnswer((_) async => fakeResponse);
        final service = PokeApiService(client: fakeClient);

        final pokemons = await service.fetchPokemonList(limit, offset);

        expect(pokemons, isNotEmpty);

        final firstPokemon = pokemons[0];
        expect(firstPokemon.name, 'bulbasaur');
        expect(firstPokemon.id, 1);
        expect(firstPokemon.imageUrl, isNotEmpty);
      },
    );

    test(
      'Doit récupérer le détail de pokémon valide depuis la PokéAPI',
      () async {
        MockHttpClient fakeClient = MockHttpClient();
        int id = 1;
        final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id');
        http.Response fakeResponse = http.Response(
          '{"id": 1, "name": "bulbasaur", "height": 7, "weight": 69, '
          '"types": [{"type": {"name": "grass"}}, {"type": {"name": "poison"}}], '
          '"sprites": {"front_default": "default.png", "front_shiny": null, "front_female": null, "front_shiny_female": null}, '
          '"forms": [{"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon-form/1/"}]}',
          200,
        );
        when(() => fakeClient.get(url)).thenAnswer((_) async => fakeResponse);
        final service = PokeApiService(client: fakeClient);

        final pokemonDetail = await service.fetchPokemonDetails(id);
        expect(pokemonDetail, isNotNull);
        final firstPokemon = pokemonDetail;
        expect(firstPokemon.height, 7);
        expect(firstPokemon.weight, 69);
        expect(firstPokemon.types, ['GRASS', 'POISON']);
      },
    );

    test(
      'Doit garder les formes alternatives classiques et exclure les mega/gmax',
      () async {
        MockHttpClient fakeClient = MockHttpClient();
        int id = 3;
        final url = Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id');
        http.Response fakeResponse = http.Response(
          '{"varieties": ['
          '{"is_default": true, "pokemon": {"name": "venusaur", "url": "https://pokeapi.co/api/v2/pokemon/3/"}}, '
          '{"is_default": false, "pokemon": {"name": "venusaur-mega", "url": "https://pokeapi.co/api/v2/pokemon/10033/"}}, '
          '{"is_default": false, "pokemon": {"name": "venusaur-gmax", "url": "https://pokeapi.co/api/v2/pokemon/10195/"}}, '
          '{"is_default": false, "pokemon": {"name": "venusaur-alt", "url": "https://pokeapi.co/api/v2/pokemon/10222/"}}'
          ']}',
          200,
        );
        when(() => fakeClient.get(url)).thenAnswer((_) async => fakeResponse);
        final service = PokeApiService(client: fakeClient);

        final pokemonForms = await service.fetchPokemonForm(id);

        expect(pokemonForms.length, 1);
        expect(pokemonForms[0].name, 'venusaur-alt');
        expect(pokemonForms[0].id, 10222);
      },
    );

    test(
      'Doit récupérer le jeu qui a introduit une forme',
      () async {
        MockHttpClient fakeClient = MockHttpClient();
        int formId = 10364;
        final url = Uri.parse('https://pokeapi.co/api/v2/pokemon-form/$formId');
        http.Response fakeResponse = http.Response(
          '{"name": "venusaur-gmax", "version_group": {"name": "sword-shield"}}',
          200,
        );
        when(() => fakeClient.get(url)).thenAnswer((_) async => fakeResponse);
        final service = PokeApiService(client: fakeClient);

        expect(await service.fetchFormVersionGroup(formId), 'sword-shield');
      },
    );

    test(
      'Doit récupérer uniquement les formes mega et gmax',
      () async {
        MockHttpClient fakeClient = MockHttpClient();
        int id = 3;
        final url = Uri.parse('https://pokeapi.co/api/v2/pokemon-species/$id');
        http.Response fakeResponse = http.Response(
          '{"varieties": ['
          '{"is_default": true, "pokemon": {"name": "venusaur", "url": "https://pokeapi.co/api/v2/pokemon/3/"}}, '
          '{"is_default": false, "pokemon": {"name": "venusaur-mega", "url": "https://pokeapi.co/api/v2/pokemon/10033/"}}, '
          '{"is_default": false, "pokemon": {"name": "venusaur-gmax", "url": "https://pokeapi.co/api/v2/pokemon/10195/"}}, '
          '{"is_default": false, "pokemon": {"name": "venusaur-alt", "url": "https://pokeapi.co/api/v2/pokemon/10222/"}}'
          ']}',
          200,
        );
        when(() => fakeClient.get(url)).thenAnswer((_) async => fakeResponse);
        final service = PokeApiService(client: fakeClient);

        final transformations = await service.fetchPokemonTransformation(id);

        expect(transformations.length, 2);
        expect(transformations.map((f) => f.name), containsAll(['venusaur-mega', 'venusaur-gmax']));
      },
    );
  });
}
