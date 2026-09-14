import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex/main.dart'; // Remplace 'pokedex' par le vrai nom de ton projet si différent

void main() {
  testWidgets('Smoke test de lancement', (WidgetTester tester) async {
    // On lance simplement l'application pour vérifier qu'elle ne crashe pas au démarrage
    await tester.pumpWidget(const PokedexApp());
    
    // Le test passe si on arrive ici sans erreur
    expect(true, isTrue);
  });
}