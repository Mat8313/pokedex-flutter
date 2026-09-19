import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/models/game.dart';
import 'package:pokedex/models/game_forms.dart';

GameDex game(String versionGroup) =>
    gamePokedexes.firstWhere((entry) => entry.versionGroup == versionGroup);

void main() {
  group('isFormAvailableIn', () {
    test("Doit accepter une forme a partir de sa generation d'introduction", () {
      // Les formes d'Alola datent de Soleil·Lune.
      expect(isFormAvailableIn('sun-moon', game('sun-moon')), isTrue);
      expect(isFormAvailableIn('sun-moon', game('sword-shield')), isTrue);
    });

    test('Doit refuser une forme anterieure au jeu', () {
      // Pas de forme de Galar avant Epee·Bouclier.
      expect(isFormAvailableIn('sword-shield', game('sun-moon')), isFalse);
      expect(isFormAvailableIn('sword-shield', game('red-blue')), isFalse);
    });

    test('Doit traiter les formes Partenaire comme exclusives a Let\'s Go', () {
      const letsGo = 'lets-go-pikachu-lets-go-eevee';

      expect(isFormAvailableIn(letsGo, game(letsGo)), isTrue);
      expect(isFormAvailableIn(letsGo, game('sword-shield')), isFalse);
      expect(isFormAvailableIn(letsGo, game('scarlet-violet')), isFalse);
    });

    test('Doit accepter une forme introduite par le jeu lui-meme', () {
      expect(isFormAvailableIn('scarlet-violet', game('scarlet-violet')), isTrue);
    });

    test('Doit refuser un jeu d\'introduction inconnu', () {
      expect(isFormAvailableIn('jeu-inexistant', game('scarlet-violet')), isFalse);
    });

    test('Doit dater par generation et non par region', () {
      // Rubis Omega·Saphir Alpha se deroule a Hoenn mais appartient a la
      // generation VI : une forme de la generation VI y existe donc.
      expect(isFormAvailableIn('x-y', game('omega-ruby-alpha-sapphire')), isTrue);
      expect(isFormAvailableIn('x-y', game('ruby-sapphire')), isFalse);
    });
  });
}
