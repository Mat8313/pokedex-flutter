import 'package:flutter/material.dart';

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

  final PokeApiService apiService = PokeApiService();

  Future<void> fetchPokemonList() async {
    int limit = widget.endId - widget.startId + 1;
    int offset = widget.startId - 1;
    try {
      final list = await apiService.fetchPokemonList(limit, offset);
      setState(() {
        pokemonList = list;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('ERREUR réseaux : $e');
      setState(() => isLoading = false);
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
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'POKÉDEX',
          style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 2.0),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
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
