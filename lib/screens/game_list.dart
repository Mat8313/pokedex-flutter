import 'package:flutter/material.dart';

import '../l10n/localized_label.dart';

import '../models/game.dart';
import '../utils/assets_helper.dart';
import 'game_pokedex_page.dart';

/// L'étagère de jeux, montée comme onglet de [HomePage].
///
/// Chaque tuile est un version-group et non une région : Kanto y apparaît
/// quatre fois, de Rouge·Bleu à Let's Go.
class GameList extends StatelessWidget {
  const GameList({super.key});

  /// Le libellé de la génération du jeu, lu dans le référentiel des sprites.
  static LocalizedLabel? _generationLabel(GameDex game) {
    for (final generation in pokemonGenerations) {
      if (generation.key == game.generationKey) return generation.label;
    }
    return null;
  }

  static String _generationName(BuildContext context, GameDex game) {
    final label = _generationLabel(game);
    return label == null ? '' : context.label(label);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Deux colonnes sur un téléphone, davantage dès qu'il y a la place.
    int crossAxisCount = (screenWidth / 200).toInt();
    if (crossAxisCount < 2) {
      crossAxisCount = 2;
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.66,
      ),
      itemCount: gamePokedexes.length,
      itemBuilder: (context, index) {
        final game = gamePokedexes[index];
        final color = gameColors[game.versionGroup] ?? const Color(0xFF2A2D34);

        return Material(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          elevation: 6,
          shadowColor: Colors.black,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GamePokedexPage(game: game)),
              );
            },
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.6), const Color(0xFF1E1E1E)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Image.asset(
                      gameCoverPath(game.versionGroup),
                      fit: BoxFit.contain,
                      // Les jaquettes vont du carré (Game Boy) au portrait
                      // (Switch) : on les contient plutôt que de les rogner.
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text(
                          context.label(game.label).toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Hauteur fixe, sans quoi un titre à rallonge rognerait la
                // jaquette de sa seule tuile et casserait l'alignement.
                SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Deux lignes exactement : la hauteur de ligne est
                        // imposée pour que la place réservée corresponde au
                        // rendu, sinon le second titre est rogné au lieu d'être
                        // abrégé.
                        SizedBox(
                          height: 26,
                          child: Text(
                            context.label(game.label).toUpperCase(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                              height: 1.3,
                              letterSpacing: 0.4,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _generationName(context, game),
                          style: TextStyle(
                            fontSize: 9,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
