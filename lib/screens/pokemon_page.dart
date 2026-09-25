import 'package:flutter/material.dart';

import '../widgets/network_error.dart';

import '../services/poke_api_service.dart';
import '../models/pokemon.dart';
import '../models/pokedex_entry.dart';
import '../widgets/pokemon_grid.dart';

class PokemonPage extends StatefulWidget {
  final String regionName;
  final int startId, endId;

  const PokemonPage({
    super.key,
    required this.regionName,
    required this.startId,
    required this.endId,
  });

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  List<Pokemon> pokemonList = [];
  bool isLoading = true; // Pour afficher un chargement stylé
  bool hasError = false;

  final PokeApiService apiService = PokeApiService();

  Future<void> fetchPokemonList() async {
    int limit = widget.endId - widget.startId + 1;
    int offset = widget.startId - 1;
    try {
      final list = await apiService.fetchPokemonList(limit, offset);
      if (!mounted) return;
      setState(() {
        pokemonList = list;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('ERREUR réseaux : $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.regionName.toUpperCase())),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
          ? NetworkErrorView(
              onRetry: () {
                setState(() {
                  isLoading = true;
                  hasError = false;
                });
                fetchPokemonList();
              },
            )
          // Le tri par région numérote au national : les deux numéros d'une
          // entrée sont donc les mêmes.
          : PokemonGrid(
              entries: pokemonList
                  .map(
                    (pokemon) => PokedexEntry(
                      entryNumber: pokemon.id,
                      speciesId: pokemon.id,
                      name: pokemon.name,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
