import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import 'game_list.dart';
import 'region_list.dart';
import 'settings_page.dart';

/// L'accueil : les deux façons d'entrer dans le Pokédex.
///
/// Région et jeu ne découpent pas la même chose — Kanto est une région, mais
/// cinq jeux répartis sur quatre générations s'y déroulent. D'où deux onglets
/// plutôt qu'un seul classement.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.appTitle.toUpperCase()),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: l10n.settingsTitle,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.tabRegions),
              Tab(text: l10n.tabGames),
            ],
          ),
        ),
        // Les pages d'un TabBarView sont conservées d'une reconstruction à
        // l'autre : un changement de thème atteint la barre de navigation, qui
        // lit le thème elle-même, mais pas les listes, qui restent peintes dans
        // l'ancien. La clé force leur reconstruction quand un réglage
        // d'affichage change — au prix de la position de défilement, ce qui est
        // sans conséquence pour une action aussi rare.
        body: KeyedSubtree(
          key: ValueKey('${Theme.of(context).brightness}-${Localizations.localeOf(context)}'),
          child: const TabBarView(children: [RegionList(), GameList()]),
        ),
      ),
    );
  }
}
