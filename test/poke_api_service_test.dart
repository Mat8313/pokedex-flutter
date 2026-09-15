import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/services/poke_api_service.dart'; // Import de ton service

void main() {
  group('PokeApiService Tests (Réseau réel)', () {
    test('Doit récupérer une liste de Pokémon valide depuis la PokéAPI', () async {
      // 1. Arrange : On prépare notre service
      final service = PokeApiService();

      // 2. Act : On fait le VRAI appel réseau
      // /!\ Remplace "getPokemons()" par le vrai nom de ta méthode /!\
      final pokemons = await service.fetchPokemonList();

      // 3. Assert : On vérifie les données reçues
      // On s'assure qu'on a bien reçu une liste qui n'est pas vide
      expect(pokemons, isNotEmpty);
      
      // On vérifie que le premier Pokémon de la liste est bien Bulbizarre (Kanto #1)
      final firstPokemon = pokemons[0];
      expect(firstPokemon.name, 'bulbasaur');
      expect(firstPokemon.id, 1);
      // On vérifie que l'image URL a bien été générée par notre modèle
      expect(firstPokemon.imageUrl, isNotEmpty);
    });
  
    test('Doit récupérer le détail de pokémon valide depuis la PokéAPI', () async {
      final service = PokeApiService();
      final pokemonDetail = await service.fetchPokemonDetails(1);
      expect(pokemonDetail, isNotNull);
      final firstPokemon = pokemonDetail;
      expect(firstPokemon.height, 7);
      expect(firstPokemon.weight, 69);
      expect(firstPokemon.types, ['GRASS','POISON']);
    });
  
  
  });
}