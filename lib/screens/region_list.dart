import 'package:flutter/material.dart';

import 'pokemon_page.dart';
import '../models/region.dart';

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
      name: 'Kanto',
      firstId: 1,
      lastId: 151,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png',
      ],
    ),
    Region(
      name: 'Johto',
      firstId: 152,
      lastId: 251,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/152.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/155.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/158.png',
      ],
    ),
    Region(
      name: 'Hoenn',
      firstId: 252,
      lastId: 386,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/252.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/255.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/258.png',
      ],
    ),
    Region(
      name: 'Sinnoh',
      firstId: 387,
      lastId: 493,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/387.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/390.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/393.png',
      ],
    ),
    Region(
      name: 'unys',
      firstId: 494,
      lastId: 649,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/495.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/498.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/501.png',
      ],
    ),
    Region(
      name: 'kalos',
      firstId: 650,
      lastId: 721,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/650.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/653.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/656.png',
      ],
    ),
    Region(
      name: 'alola',
      firstId: 722,
      lastId: 809,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/722.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/725.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/728.png',
      ],
    ),
    Region(
      name: 'galar',
      firstId: 810,
      lastId: 898,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/810.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/813.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/816.png',
      ],
    ),
    Region(
      name: 'hisui',
      firstId: 899,
      lastId: 905,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/899.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/900.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/901.png',
      ],
    ),
    Region(
      name: 'paldea',
      firstId: 906,
      lastId: 1025,
      starters: [
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/906.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/909.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/912.png',
      ],
    ),
    Region(
      name: 'all pokemons',
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
            gradient: const LinearGradient(
              colors: [Color(0xFF2A2D34), Color(0xFF1E1E1E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
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
                      regionName: region.name,
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
                              region.name.toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                letterSpacing: 1.5,
                                color: Colors.white,
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
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '#${region.firstId.toString().padLeft(4, '0')} - #${region.lastId.toString().padLeft(4, '0')}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      flex: 6,
                      child: FittedBox(
                        fit: BoxFit
                            .contain, // Demande de remplir l'espace au maximum
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              region.starters[0],
                              height: 100,
                              width: 100,
                            ),
                            Image.network(
                              region.starters[1],
                              height: 100,
                              width: 100,
                            ),
                            Image.network(
                              region.starters[2],
                              height: 100,
                              width: 100,
                            ),
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
