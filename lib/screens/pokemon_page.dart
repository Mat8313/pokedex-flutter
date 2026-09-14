import 'package:flutter/material.dart';

import '../services/poke_api_service.dart';
import 'pokemon_detail_page.dart';
import '../models/pokemon.dart';

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  List<Pokemon> pokemonList = [];

  final PokeApiService apiService = PokeApiService();

  Future<void> fetchPokemonList() async {
    try {
      final list = await apiService.fetchPokemonList();
      setState(() => pokemonList = list);
    } catch (e) {
      debugPrint('ERREUR réseaux : $e');
    }
  }

  // 3. Cette méthode magique lance la requête au démarrage de l'app !
  @override
  void initState() {
    super.initState();
    fetchPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Pokédex'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      // 4. On remplace la Column par notre ListView.builder
      body: ListView.builder(
        // On lui dit combien d'éléments il y a dans notre liste
        itemCount: pokemonList.length,

        // Cette fonction construit la "case" visuelle pour chaque élément
        itemBuilder: (context, index) {
          final pokemon = pokemonList[index];


          // ListTile est un widget natif de Flutter parfait pour les listes (avec une image à gauche, un titre, etc.)
          return ListTile(
            leading: Image.network(pokemon.imageUrl, width: 50, height: 50),
            title: Text(
              pokemon.name.toUpperCase(), // On met le nom en majuscules
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text('#${pokemon.id}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailPage(
                    pokemonName: pokemon.name,
                    pokemonId: pokemon.id,
                  ),
                ),
              );
            }, // On affiche le numéro en dessous
          );
        },
      ),
    );
  }
}
