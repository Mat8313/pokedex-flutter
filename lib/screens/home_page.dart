import 'package:flutter/material.dart';

import 'game_list.dart';
import 'region_list.dart';

/// L'accueil : les deux façons d'entrer dans le Pokédex.
///
/// Région et jeu ne découpent pas la même chose — Kanto est une région, mais
/// cinq jeux répartis sur quatre générations s'y déroulent. D'où deux onglets
/// plutôt qu'un seul classement.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          title: const Text(
            'POKÉDEX',
            style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2.0),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          bottom: const TabBar(
            indicatorColor: Colors.redAccent,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
            tabs: [
              Tab(text: 'RÉGIONS'),
              Tab(text: 'JEUX'),
            ],
          ),
        ),
        body: const TabBarView(children: [RegionList(), GameList()]),
      ),
    );
  }
}
