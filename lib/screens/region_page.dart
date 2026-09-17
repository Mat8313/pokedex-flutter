import 'package:flutter/material.dart';

import 'pokemon_page.dart';
import '../models/region.dart';

class RegionPage extends StatefulWidget {
  const RegionPage({super.key});

  @override
  State<RegionPage> createState() => _RegionPage();
}

class _RegionPage extends State<RegionPage> {
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
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/133.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png',
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Regions',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2.0),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: ListView.builder(
        // On ajoute un padding global pour la liste
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: regions.length,
        itemBuilder: (context, index) {
          final region = regions[index];

          return Container(
            margin: const EdgeInsets.only(
              bottom: 16,
            ), // Espace entre les cartes
            decoration: BoxDecoration(
              // Un léger dégradé pour donner du relief à la carte
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
            // Material + InkWell permet d'avoir le bel effet de clic "vague"
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
                      // --- GAUCHE : Textes ---
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            region.name.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Petit Badge pour les IDs
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

                      // --- DROITE : Les 3 Starters ---
                      Row(
                        children: [
                          Image.network(
                            region.starters[0],
                            height: 80,
                            width: 80,
                          ),
                          Image.network(
                            region.starters[1],
                            height: 80,
                            width: 80,
                          ),
                          Image.network(
                            region.starters[2],
                            height: 80,
                            width: 80,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
