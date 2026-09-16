import 'package:flutter/material.dart';

import '../services/poke_api_service.dart';
import 'pokemon_detail_page.dart';
import '../models/pokemon.dart';

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
      final list = await apiService.fetchPokemonList(limit , offset);
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
    //Récupérer la largeur de l'écran
    final double screenWidth = MediaQuery.of(context).size.width;
  
    int dynamicCrossAxisCount = (screenWidth / 120).toInt();
    
    // minimum 3 colonnes 
    if (dynamicCrossAxisCount < 3) {
      dynamicCrossAxisCount = 3;
    }

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
          : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              // 4. On utilise notre variable calculée ici !
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: dynamicCrossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = pokemonList[index];

                return GestureDetector(
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
                  },
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              pokemon.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          pokemon.name.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#${pokemon.id.toString().padLeft(3, '0')}', 
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}