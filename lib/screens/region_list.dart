import 'package:flutter/material.dart';
import '../utils/network_image.dart';

import 'pokemon_page.dart';
import '../models/region.dart';
import '../l10n/localized_label.dart';
import '../theme/app_theme.dart';

/// La liste des régions, sans échafaudage : elle est montée comme onglet de
/// [HomePage], à côté de la liste des jeux.
class RegionList extends StatefulWidget {
  const RegionList({super.key});

  @override
  State<RegionList> createState() => _RegionListState();
}

class _RegionListState extends State<RegionList> {
  final List<Region> regions = [
    Region(
      name: LocalizedLabel('Kanto', 'Kanto'),
      firstId: 1,
      lastId: 151,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
      ],
    ),
    Region(
      name: LocalizedLabel('Johto', 'Johto'),
      firstId: 152,
      lastId: 251,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/152.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/155.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/158.png',
      ],
    ),
    Region(
      name: LocalizedLabel('Hoenn', 'Hoenn'),
      firstId: 252,
      lastId: 386,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/252.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/255.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/258.png',
      ],
    ),
    Region(
      name: LocalizedLabel('Sinnoh', 'Sinnoh'),
      firstId: 387,
      lastId: 493,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/387.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/390.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/393.png',
      ],
    ),
    Region(
      name: LocalizedLabel('Unova', 'Unys'),
      firstId: 494,
      lastId: 649,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/495.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/498.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/501.png',
      ],
    ),
    Region(
      name: LocalizedLabel('Kalos', 'Kalos'),
      firstId: 650,
      lastId: 721,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/650.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/653.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/656.png',
      ],
    ),
    Region(
      name: LocalizedLabel('Alola', 'Alola'),
      firstId: 722,
      lastId: 809,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/722.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/725.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/728.png',
      ],
    ),
    Region(
      name: LocalizedLabel('Galar', 'Galar'),
      firstId: 810,
      lastId: 898,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/810.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/813.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/816.png',
      ],
    ),
    Region(
      name: LocalizedLabel('Hisui', 'Hisui'),
      firstId: 899,
      lastId: 905,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/899.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/900.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/901.png',
      ],
    ),
    Region(
      name: LocalizedLabel('Paldea', 'Paldea'),
      firstId: 906,
      lastId: 1025,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/906.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/909.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/912.png',
      ],
    ),
    Region(
      name: LocalizedLabel('All Pokémon', 'Tous les Pokémon'),
      firstId: 1,
      lastId: 1025,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/151.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/150.png',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: regions.length,
      itemBuilder: (context, index) {
        final region = regions[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [context.colors.surfaceContainerHighest, context.cardColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PokemonPage(
                      regionName: context.label(region.name),
                      startId: region.firstId,
                      endId: region.lastId,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.label(region.name).toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                letterSpacing: 1.5,
                                color: context.colors.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.onSurface.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#${region.firstId.toString().padLeft(4, '0')} - #${region.lastId.toString().padLeft(4, '0')}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: context.mutedColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      flex: 6,
                      // Remplit l'espace au maximum sans déformer les sprites.
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final starter in region.starters)
                              Image(image: networkImage(starter), height: 100, width: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
