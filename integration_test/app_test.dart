import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pokedex/main.dart' as app;

/// Parcours complet sur un vrai appareil, avec le vrai réseau.
///
/// C'est le genre de test qui aurait attrapé les bugs trouvés en filmant
/// l'application : types non traduits sur la fiche, onglets qui recouvraient le
/// contenu, mauvaise forme ouverte depuis la grille. Aucun test unitaire ne les
/// voyait, parce qu'ils n'existaient qu'une fois tous les écrans assemblés.
///
/// À lancer avec un appareil branché ou un émulateur :
///   flutter test integration_test
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Attend qu'un élément apparaisse : le réseau n'a pas de durée fixe.
  Future<void> waitFor(WidgetTester tester, Finder finder, {int seconds = 20}) async {
    for (var i = 0; i < seconds * 4; i++) {
      await tester.pump(const Duration(milliseconds: 250));
      if (finder.evaluate().isNotEmpty) return;
    }
    fail('Toujours introuvable après $seconds s : $finder');
  }

  testWidgets('Région → fiche → infos → passage en français', (tester) async {
    // On part toujours de la même langue, quel que soit l'état de l'appareil.
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await preferences.setString('language', 'en');

    await app.main();
    await waitFor(tester, find.text('KANTO'));

    // Kanto, puis Bulbizarre, premier de la grille.
    await tester.tap(find.text('KANTO'));
    await waitFor(tester, find.text('BULBASAUR'));
    await tester.tap(find.text('BULBASAUR'));

    // La fiche : nom, et types traduits (pas la clé brute de l'API).
    await waitFor(tester, find.text('0001 BULBASAUR'));
    expect(find.text('GRASS'), findsOneWidget);
    expect(find.text('POISON'), findsOneWidget);

    // Onglet Infos : les groupes d'œufs viennent de l'espèce, chargée à part.
    await tester.tap(find.text('INFO'));
    await waitFor(tester, find.text('Egg groups'));
    await tester.dragUntilVisible(
      find.text('Egg groups'),
      find.byType(CustomScrollView).last,
      const Offset(0, -200),
    );
    expect(find.text('Egg groups'), findsOneWidget);

    // Retour à l'accueil, puis passage en français depuis les réglages.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Français'));
    await tester.pumpAndSettle();
    // pageBack() cherche l'infobulle anglaise « Back » : l'application est
    // désormais en français, on vise donc le bouton lui-même.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('RÉGIONS'), findsOneWidget);
    expect(find.text('JEUX'), findsOneWidget);
  });
}
