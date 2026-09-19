import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/models/game.dart';
import 'package:pokedex/models/game_forms.dart';
import 'package:pokedex/models/pokedex_entry.dart';
import 'package:pokedex/services/api_names.dart';

/// Ces tests chargent les vrais fichiers d'assets : ils vérifient que les
/// tables générées hors ligne sont bien embarquées et bien lues, ce qu'aucun
/// test sur des données factices ne peut attraper.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await ApiNames.load();
  });

  group('Noms traduits', () {
    test('Doit traduire une espèce dans les deux langues', () {
      expect(ApiNames.species(1, const Locale('fr'), apiName: 'bulbasaur'), 'Bulbizarre');
      expect(ApiNames.species(1, const Locale('en'), apiName: 'bulbasaur'), 'Bulbasaur');
    });

    test("Doit se replier sur l'identifiant pour une forme sans nom d'espèce", () {
      expect(
        ApiNames.species(10033, const Locale('fr'), apiName: 'venusaur-mega'),
        'Venusaur Mega',
      );
    });

    test('Doit traduire les objets, dont dépendent les évolutions', () {
      expect(ApiNames.item('fire-stone', const Locale('fr')), 'Pierre Feu');
      expect(ApiNames.item('fire-stone', const Locale('en')), 'Fire Stone');
    });

    test('Doit traduire les talents', () {
      expect(ApiNames.ability(65, const Locale('en'), apiName: 'overgrow'), 'Overgrow');
      expect(ApiNames.ability(65, const Locale('fr'), apiName: 'overgrow'), 'Engrais');
    });
  });

  group('Types hors ligne', () {
    test('Doit donner les types dans l\'ordre des emplacements', () {
      expect(ApiNames.types(1), ['grass', 'poison']);
      expect(ApiNames.types(25), ['electric']);
    });

    test('Doit rendre une liste vide pour une forme alternative', () {
      expect(ApiNames.types(10033), isEmpty);
    });
  });

  group('Formes par jeu', () {
    test("Doit connaître les formes régionales d'une espèce", () {
      final miaouss = ApiNames.forms(52);

      expect(miaouss.map((form) => form['vg']), containsAll(['sun-moon', 'sword-shield']));
    });

    test('Ne doit pas contenir de méga-évolution', () {
      // Elles sont marquées « combat uniquement » : aucun Pokédex ne les liste.
      final florizarre = ApiNames.forms(3);

      expect(florizarre.where((form) => (form['name'] as String).contains('mega')), isEmpty);
    });

    test('Doit insérer la forme de Galar dans Épée·Bouclier, pas dans Soleil·Lune', () {
      const entry = PokedexEntry(entryNumber: 52, speciesId: 52, name: 'meowth');

      final galar = withGameForms([entry], gamePokedexes.firstWhere(
        (game) => game.versionGroup == 'sword-shield',
      ));
      final alola = withGameForms([entry], gamePokedexes.firstWhere(
        (game) => game.versionGroup == 'sun-moon',
      ));

      expect(galar.map((e) => e.name), contains('meowth-galar'));
      expect(alola.map((e) => e.name), isNot(contains('meowth-galar')));
      // La forme d'Alola, elle, est disponible dans les deux.
      expect(alola.map((e) => e.name), contains('meowth-alola'));
    });

    test("Une forme garde le numero de son espece", () {
      const entry = PokedexEntry(entryNumber: 7, speciesId: 52, name: 'meowth');

      final expanded = withGameForms([entry], gamePokedexes.firstWhere(
        (game) => game.versionGroup == 'sword-shield',
      ));

      expect(expanded.every((e) => e.entryNumber == 7), isTrue);
      expect(expanded.every((e) => e.speciesId == 52), isTrue);
      // Le visuel, lui, est celui de la forme.
      expect(expanded.last.imageUrl, isNot(contains('/52.png')));
    });

    test('Ne doit rien ajouter a une espece sans forme', () {
      const entry = PokedexEntry(entryNumber: 1, speciesId: 1, name: 'bulbasaur');

      expect(
        withGameForms([entry], gamePokedexes.first).length,
        1,
      );
    });
  });
}
