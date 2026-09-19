import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/models/pokedex_entry.dart';

/// Raccourci pour fabriquer une entrée sans passer par le JSON.
PokedexEntry entry(int entryNumber, int speciesId, String name) =>
    PokedexEntry(entryNumber: entryNumber, speciesId: speciesId, name: name);

void main() {
  group('PokedexEntry.fromJson', () {
    test(
      "Doit lire l'id de l'espèce dans l'URL, seul endroit où il figure",
      () {
        final parsed = PokedexEntry.fromJson({
          'entry_number': 1,
          'pokemon_species': {
            'name': 'turtwig',
            'url': 'https://pokeapi.co/api/v2/pokemon-species/387/',
          },
        });

        expect(parsed.entryNumber, 1);
        expect(parsed.speciesId, 387);
        expect(parsed.name, 'turtwig');
      },
    );

    test(
      "Doit distinguer la numérotation régionale de la numérotation nationale",
      () {
        // Tortipouss est le n°1 de Sinnoh et le n°387 du national.
        expect(entry(1, 387, 'turtwig').hasOwnNumbering, isTrue);
        // Bulbizarre est le n°1 dans les deux.
        expect(entry(1, 1, 'bulbasaur').hasOwnNumbering, isFalse);
      },
    );

    test("Doit construire l'URL du visuel sur le numéro national", () {
      expect(entry(1, 387, 'turtwig').imageUrl, endsWith('/387.png'));
    });
  });

  group('speciesInGame', () {
    test('Doit réunir les espèces de tous les Pokédex du jeu', () {
      // Cas Épée·Bouclier : Évoli est à la fois dans Galar et dans Couronneige.
      final galar = [entry(1, 810, 'grookey'), entry(2, 133, 'eevee')];
      final couronneige = [entry(1, 133, 'eevee'), entry(2, 144, 'articuno')];

      expect(speciesInGame([galar, couronneige]), {810, 133, 144});
    });

    test("Doit rendre un ensemble vide quand le jeu n'a aucun Pokédex", () {
      expect(speciesInGame([]), isEmpty);
    });
  });

  group('buildNationalDex', () {
    /// Les espèces 1 à [count], comme les rendrait /pokedex/national.
    List<PokedexEntry> allSpecies(int count) => List.generate(
      count,
      (index) => entry(index + 1, index + 1, 'espece${index + 1}'),
    );

    test('Doit être contigu de 1 au plafond du jeu, sans trou', () {
      // C'est tout l'enjeu : le vrai Pokédex National ne saute aucun numéro,
      // même pour une espèce que le jeu ne contient pas.
      final national = buildNationalDex(
        allSpecies: allSpecies(251),
        upTo: 251,
        availableSpecies: {1, 250},
      );

      expect(national.length, 251);
      expect(
        national.map((e) => e.speciesId),
        List.generate(251, (i) => i + 1),
      );
    });

    test("Doit garder les espèces absentes du jeu, en les marquant", () {
      final national = buildNationalDex(
        allSpecies: allSpecies(5),
        upTo: 5,
        availableSpecies: {2, 4},
      );

      expect(national.map((e) => e.availableInGame), [
        false,
        true,
        false,
        true,
        false,
      ]);
    });

    test('Doit couper au plafond du jeu', () {
      // Or·Argent s'arrête à Celebi : Poussifeu n'existe pas encore.
      final national = buildNationalDex(
        allSpecies: allSpecies(400),
        upTo: 251,
        availableSpecies: const {},
      );

      expect(national.last.speciesId, 251);
      expect(national.map((e) => e.speciesId), isNot(contains(255)));
    });

    test('Doit confondre les deux numérotations, le national étant sa propre échelle', () {
      final national = buildNationalDex(
        allSpecies: allSpecies(3),
        upTo: 3,
        availableSpecies: const {},
      );

      expect(national.every((e) => e.hasOwnNumbering), isFalse);
    });

    test(
      "Ne doit rien inventer quand le jeu ne contient aucune de ces espèces",
      () {
        final national = buildNationalDex(
          allSpecies: allSpecies(3),
          upTo: 3,
          availableSpecies: const {},
        );

        expect(national.length, 3);
        expect(national.every((e) => e.availableInGame), isFalse);
      },
    );
  });
}
