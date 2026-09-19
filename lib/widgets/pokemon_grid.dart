import 'package:flutter/material.dart';

import '../models/pokedex_entry.dart';
import '../screens/pokemon_detail_page.dart';

/// Grille de vignettes, partagée par le tri par région et le tri par jeu.
///
/// Travaille sur des [PokedexEntry] plutôt que sur des `Pokemon` : c'est la
/// seule forme qui porte à la fois le numéro affiché et le numéro national,
/// lesquels diffèrent dans un Pokédex régional.
class PokemonGrid extends StatelessWidget {
  final List<PokedexEntry> entries;

  const PokemonGrid({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    int dynamicCrossAxisCount = (screenWidth / 120).toInt();

    // minimum 3 colonnes
    if (dynamicCrossAxisCount < 3) {
      dynamicCrossAxisCount = 3;
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: dynamicCrossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        // Dans un Pokédex National, une espèce absente du jeu garde sa place
        // mais s'efface : c'est notre équivalent du ----- affiché par le jeu.
        // Elle reste consultable, l'application étant un ouvrage de référence
        // et non une sauvegarde.
        final missing = !entry.availableInGame;

        Widget sprite = Image.network(entry.imageUrl, fit: BoxFit.contain);
        if (missing) {
          sprite = ColorFiltered(
            colorFilter: const ColorFilter.matrix(_greyscale),
            child: sprite,
          );
        }

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemonDetailPage(
                  pokemonName: entry.name,
                  // Le numéro national, jamais le numéro régional : le Pokédex
                  // de Sinnoh commence à Tortipouss, qui est le 387e national.
                  pokemonId: entry.speciesId,
                ),
              ),
            );
          },
          child: Opacity(
            opacity: missing ? 0.4 : 1,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: sprite,
                    ),
                  ),
                  Text(
                    entry.name.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '#${entry.entryNumber.toString().padLeft(3, '0')}',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Hauteur réservée même sans second numéro, pour que les
                  // vignettes d'une même grille gardent la même taille d'image.
                  SizedBox(
                    height: 14,
                    child: entry.hasOwnNumbering
                        ? Text(
                            'N°${entry.speciesId.toString().padLeft(4, '0')}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Matrice de désaturation (luminance ITU-R BT.709), pour les espèces qu'un jeu
/// ne contient pas.
const List<double> _greyscale = <double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0,
];
