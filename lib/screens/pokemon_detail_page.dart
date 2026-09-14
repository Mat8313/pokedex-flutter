import 'package:flutter/material.dart';

import '../services/poke_api_service.dart';
import '../models/pokemon_detail.dart';

class PokemonDetailPage extends StatefulWidget {
  final String pokemonName;
  final int pokemonId;

  const PokemonDetailPage({
    super.key,
    required this.pokemonName,
    required this.pokemonId,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  PokemonDetail? pokemonDetails;

  final PokeApiService apiService = PokeApiService();

  Future<void> fetchPokemonDetails() async {
    try {
      final details = await apiService.fetchPokemonDetails(widget.pokemonId);
      setState(() {
        pokemonDetails = details;
      });
    } catch (e) {
      debugPrint('ERREUR réseau: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPokemonDetails(); // On lance la requête au chargement de cette page
  }

  @override
  Widget build(BuildContext context) {
    // On recrée l'URL de l'image avec l'ID pour l'afficher en grand
    final imageUrl =
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${widget.pokemonId}.png';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pokemonName.toUpperCase()),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: pokemonDetails == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // On centre tout verticalement
                children: [
                  // L'image en grand !
                  Image.network(imageUrl, height: 250),
                  const SizedBox(height: 30),

                  // Une petite "Card" (carte) pour faire un fond esthétique aux stats
                  Card(
                    color: Colors.grey[800], // Une couleur qui ressort bien en mode sombre
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            'Numéro : #${widget.pokemonId}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            // L'interface se contente d'afficher, elle ne calcule plus !
                            pokemonDetails!.types.join(' / '),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Poids : ${pokemonDetails!.weight} hg',
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Taille : ${pokemonDetails!.height} dm',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
