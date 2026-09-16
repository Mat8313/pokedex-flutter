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
        itemCount: regions.length,
        itemBuilder: (context, index) {
          final region = regions[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(region.starters[0], height: 50, width: 50),
                    Image.network(region.starters[1], height: 50, width: 50),
                    Image.network(region.starters[2], height: 50, width: 50),
                    Text(
                      region.name.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      '#${region.firstId.toString().padLeft(4, '0')}-#${region.lastId.toString().padLeft(4, '0')}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
