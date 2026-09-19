import 'package:flutter/material.dart';

import '../l10n/localized_label.dart';

import '../l10n/app_localizations.dart';
import '../models/game.dart';
import '../models/game_forms.dart';
import '../models/pokedex_entry.dart';
import '../services/poke_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/pokemon_grid.dart';

/// Le Pokédex d'un jeu : un onglet par Pokédex régional, plus un onglet
/// national qui n'en est que la réunion.
class GamePokedexPage extends StatefulWidget {
  final GameDex game;

  const GamePokedexPage({super.key, required this.game});

  @override
  State<GamePokedexPage> createState() => _GamePokedexPageState();
}

class _GamePokedexPageState extends State<GamePokedexPage> {
  final PokeApiService apiService = PokeApiService();

  /// Mémorise le `Future` et non son résultat : une requête par Pokédex, quel
  /// que soit le nombre d'allers-retours entre les onglets.
  final Map<String, Future<List<PokedexEntry>>> _dexFutures = {};

  /// Clé du national dans [_dexFutures]. Aucun nom de Pokédex de l'API ne
  /// commence par `@`, la collision est donc impossible.
  static const String _nationalKey = '@national';

  Future<List<PokedexEntry>> _regionalDex(String apiName) => _dexFutures.putIfAbsent(
    apiName,
    // Les formes sont ajoutées ici plutôt que dans le service : elles dépendent
    // du jeu consulté, pas du Pokédex demandé.
    () async => withGameForms(await apiService.fetchPokedexEntries(apiName), widget.game),
  );

  /// Le Pokédex National du jeu : la liste complète des espèces jusqu'à son
  /// plafond, celles que le jeu ne contient pas étant marquées et non retirées.
  ///
  /// Les Pokédex régionaux ne servent qu'à savoir ce que le jeu contient. Ils
  /// passent par [_regionalDex], donc par le même cache que leurs onglets :
  /// rien n'est demandé deux fois, même si le national est ouvert en premier.
  ///
  /// N'est appelé que depuis l'onglet national, lequel n'existe pas quand
  /// `nationalDexMax` est nul.
  Future<List<PokedexEntry>> _nationalDex() =>
      _dexFutures.putIfAbsent(_nationalKey, () async {
        final dexes = await Future.wait([
          apiService.fetchPokedexEntries('national'),
          ...widget.game.pokedexes.map((dex) => _regionalDex(dex.apiName)),
        ]);

        return withGameForms(
          buildNationalDex(
            allSpecies: dexes.first,
            upTo: widget.game.nationalDexMax!,
            availableSpecies: speciesInGame(dexes.skip(1).toList()),
          ),
          widget.game,
        );
      });

  /// [dexKey] est un nom de Pokédex de l'API, ou [_nationalKey].
  ///
  /// Le `Builder` n'est pas décoratif : il retarde la résolution du `Future`
  /// au moment où l'onglet est réellement affiché. Sans lui, ouvrir
  /// Épée·Bouclier déclencherait ses trois requêtes d'un coup.
  Widget _dexTab(String dexKey) {
    return Builder(
      builder: (context) => FutureBuilder<List<PokedexEntry>>(
        future: dexKey == _nationalKey ? _nationalDex() : _regionalDex(dexKey),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.errorPokedexLoad,
                style: TextStyle(color: context.mutedColor),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return PokemonGrid(entries: snapshot.data!);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pokedexes = widget.game.pokedexes;
    // Beaucoup de jeux n'ont pas de Pokédex National : aucun avant la gen II,
    // aucun depuis la gen VII sauf Diamant Étincelant·Perle Scintillante.
    final hasNationalDex = widget.game.nationalDexMax != null;

    return DefaultTabController(
      length: pokedexes.length + (hasNationalDex ? 1 : 0),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.label(widget.game.label).toUpperCase()),
          bottom: TabBar(
            // Au-delà de deux onglets, les libellés ne tiennent plus sur la
            // largeur d'un téléphone.
            isScrollable: pokedexes.length > 1,
            tabAlignment: pokedexes.length > 1 ? TabAlignment.start : null,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              for (final dex in pokedexes) Tab(text: context.label(dex.label).toUpperCase()),
              if (hasNationalDex) Tab(text: AppLocalizations.of(context)!.tabNational),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final dex in pokedexes) _dexTab(dex.apiName),
            if (hasNationalDex) _dexTab(_nationalKey),
          ],
        ),
      ),
    );
  }
}
