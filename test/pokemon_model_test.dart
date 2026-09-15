import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/models/pokemon.dart';

void main() {
  group('Pokemon Model Tests', () {
    test('Doit créer un objet Pokemon à partir du JSON de la PokéAPI', () {
      final Map<String, dynamic> mockJson = {
        "id": 1,
        "name": "bulbasaur",
        "height": 7,
        "weight": 69,
      };

      // On teste la création de l'objet
      final pokemon = Pokemon.fromJson(mockJson);

      expect(pokemon.id, 1);
      expect(pokemon.name, 'bulbasaur');
      expect(pokemon.height, 7);
      expect(pokemon.weight, 69);
      // On vérifie que notre constructeur a bien fabriqué le lien de l'image !
      expect(pokemon.imageUrl, 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png');
    });
  });
}