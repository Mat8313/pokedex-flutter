import 'package:flutter/material.dart';

import '../services/poke_api_service.dart';
import '../models/pokemon_detail.dart';
import '../models/pokemon_forms.dart';
import '../utils/type_helper.dart';

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
  List<PokemonForm>? pokemonForms;
  final PokeApiService apiService = PokeApiService();

  Future<void> fetchPokemonDetails(int id) async {
    try {
      final details = await apiService.fetchPokemonDetails(id);
      setState(() {
        pokemonDetails = details;
      });
    } catch (e) {
      debugPrint('ERREUR réseau: $e');
    }
  }

  Future<void> fetchPokemonForm() async {
    try {
      final forms = await apiService.fetchPokemonForm(widget.pokemonId);
      setState(() {
        pokemonForms = forms;
      });
    } catch (e) {
      debugPrint('ERREUR réseau : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPokemonDetails(widget.pokemonId);
    fetchPokemonForm();
  }

  @override
  Widget build(BuildContext context) {
  final int currentId = pokemonDetails?.id ?? widget.pokemonId;

  final imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$currentId.png';
    String bgPath = 'assets/background/Fond_Type_Normal_GO.png';
    if (pokemonDetails != null && pokemonDetails!.types.isNotEmpty) {
      bgPath = typeBackgrounds[pokemonDetails!.types[0]] ?? bgPath;
    }

    final List<Shadow> textShadows = [
      Shadow(
        offset: const Offset(1, 1),
        blurRadius: 5.0,
        color: Colors.black.withValues(
          alpha: 0.6,
        ), // Ombre noire semi-transparente
      ),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bgPath),
              fit: BoxFit.cover,
            ),
          ),
          child: pokemonDetails == null
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: SafeArea(
                          bottom: false,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Hero(
                                tag: 'pokemon-${widget.pokemonId}',
                                child: Image.network(
                                  imageUrl,
                                  height: 200,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.catching_pokemon,
                                    color: Colors.white,
                                    size: 28,
                                    shadows: textShadows,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${widget.pokemonId.toString().padLeft(4, '0')} ${widget.pokemonName.toUpperCase()}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      shadows: textShadows, // ⬅️ Application de l'ombre
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: pokemonDetails!.types.map((type) {
                                  final iconPath = typeIcons[type];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                    ),
                                    child: Column(
                                      children: [
                                        if (iconPath != null)
                                          Image.asset(
                                            iconPath,
                                            height: 48,
                                            width: 48,
                                          )
                                        else
                                          const SizedBox(height: 48, width: 48),
                                        const SizedBox(height: 6),
                                        Text(
                                          type,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                            shadows: textShadows, // ⬅️ Application de l'ombre
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 24),

                              if (pokemonForms != null &&
                                  pokemonForms!.isNotEmpty)
                                Wrap(
                                  spacing: 8.0, // Espace horizontal entre les boutons
                                  alignment: WrapAlignment.center,
                                  children: pokemonForms!.map((forme) {
                                    return ElevatedButton(
                                      onPressed: () {
                                        int formId = int.parse(
                                          forme.url.split(
                                            '/',
                                          )[forme.url.split('/').length - 2],
                                        );
                                        if (pokemonDetails!.id == formId){
                                        fetchPokemonDetails(widget.pokemonId);
                                        }else {
                                          fetchPokemonDetails(formId);
                                        }
                                      },
                                      child: Text(forme.name),
                                    );
                                  }).toList(),
                                ),

                              const SizedBox(height: 24),

                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  // On passe d'un blanc transparent à un noir transparent
                                  color: Colors.black.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildGlassStat(
                                      'POIDS',
                                      '${pokemonDetails!.weight / 10} kg',
                                      textShadows,
                                    ),
                                    Container(
                                      height: 30,
                                      width: 1,
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                    ),
                                    _buildGlassStat(
                                      'TAILLE',
                                      '${pokemonDetails!.height / 10} m',
                                      textShadows,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                      // Barre d'onglets épinglée
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            indicatorColor: Colors.white,
                            indicatorWeight: 3,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white70,
                            // On ajoute l'ombre directement dans le style des textes de la TabBar
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              shadows: textShadows,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              shadows: textShadows,
                            ),
                            tabs: const [
                              Tab(text: 'FORMES'),
                              Tab(text: 'INFOS'),
                              Tab(text: 'COMBAT'),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },

                  body: TabBarView(
                    children: [
                      GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: (pokemonDetails!.sprites.values
                            .where((element) => element != null)
                            .length),

                        itemBuilder: (context, index) {
                          final entry = pokemonDetails!.sprites.entries
                              .where((entry) => entry.value != null)
                              .toList()[index];

                          String currentSpriteUrl = entry.value!;
                          String formName = entry.key;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(
                                alpha: 0.2,
                              ), // Grille assombrie
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(currentSpriteUrl),
                                Text(
                                  formName.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: textShadows,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Center(
                        child: Text(
                          'Infos du Pokémon',
                          style: TextStyle(
                            color: Colors.white,
                            shadows: textShadows,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Stats de combat',
                          style: TextStyle(
                            color: Colors.white,
                            shadows: textShadows,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildGlassStat(String label, String value, List<Shadow> textShadows) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
            shadows: textShadows,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: textShadows,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: overlapsContent
          ? Colors.black.withValues(alpha: 0.4)
          : Colors.transparent, // Plus sombre au scroll
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
