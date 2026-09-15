import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/services/poke_api_service.dart';

import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

// On crée une classe vide qui copie le comportement d'un http.Client grâce à Mocktail
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('PokeApiService Tests (Réseau réel)', () {
    test(
      'Doit récupérer une liste de Pokémon valide depuis la PokéAPI',
      () async {
        MockHttpClient fakeClient = MockHttpClient();
        int limit = 151;
        final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=$limit');
        http.Response fakeResponse = http.Response(
          '{"results": [{"name": "bulbasaur", "url": "https://pokeapi.co/api/v2/pokemon/1/"}]}',
          200,
        );
        when(() => fakeClient.get(url)).thenAnswer((_) async => fakeResponse);
        final service = PokeApiService(client: fakeClient);

        final pokemons = await service.fetchPokemonList();

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
          '{"height": 7, "weight": 69, "types": [{"type": {"name": "grass"}}, {"type": {"name": "poison"}}]}',
          200,
        );
        when(() => fakeClient.get(url)).thenAnswer((_) async => fakeResponse);
        final service = PokeApiService(client: fakeClient);

        final pokemonDetail = await service.fetchPokemonDetails(1);
        expect(pokemonDetail, isNotNull);
        final firstPokemon = pokemonDetail;
        expect(firstPokemon.height, 7);
        expect(firstPokemon.weight, 69);
        expect(firstPokemon.types, ['GRASS', 'POISON']);
      },
    );
  });
}
