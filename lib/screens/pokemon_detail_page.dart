import 'dart:ui';
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
  String? displayedCosmeticName;
  
  final PokeApiService apiService = PokeApiService();

  Future<void> fetchPokemonDetails(int id) async {
    try {
      final details = await apiService.fetchPokemonDetails(id);
      setState(() {
        pokemonDetails = details;
        displayedCosmeticName = null;
      });
    } catch (e) {
      debugPrint('ERREUR réseau: $e');
    }
  }

  Future<void> fetchPokemonForm(int id) async {
    try {
      final forms = await apiService.fetchPokemonForm(id);
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
    fetchPokemonForm(widget.pokemonId);
  }

  @override
  Widget build(BuildContext context) {
    final currentBaseId = pokemonDetails?.id ?? widget.pokemonId;
    
    final mainImageUrl = displayedCosmeticName != null
        ? 'https://img.pokemondb.net/sprites/home/normal/$displayedCosmeticName.png'
        : 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/$currentBaseId.png';

    final displayName = displayedCosmeticName ?? pokemonDetails?.name ?? widget.pokemonName;

    String bgPath = 'assets/background/Fond_Type_Normal_GO.png';
    if (pokemonDetails != null && pokemonDetails!.types.isNotEmpty) {
      bgPath = typeBackgrounds[pokemonDetails!.types[0]] ?? bgPath;
    }

    final List<Shadow> textShadows = [
      Shadow(
        offset: const Offset(1, 1),
        blurRadius: 5.0,
        color: Colors.black.withValues(alpha: 0.6),
      ),
    ];

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        
        // =========================================================================
        // APP BAR
        // =========================================================================
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        
        // =========================================================================
        // BACKGROUND 
        // =========================================================================
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
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: SafeArea(
                          bottom: false,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              
                              // =========================================================================
                              // IMAGE PRINCIPALE
                              // =========================================================================
                              Hero(
                                tag: 'pokemon-${widget.pokemonId}',
                                child: Image.network(
                                  mainImageUrl,
                                  height: 200,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    if (displayedCosmeticName != null) {
                                      return Image.network(
                                        'https://img.pokemondb.net/sprites/black-white/normal/$displayedCosmeticName.png',
                                        height: 200,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const Icon(Icons.catching_pokemon, size: 100, color: Colors.white54),
                                      );
                                    }
                                    return Image.network(
                                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$currentBaseId.png',
                                      height: 200,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.network(
                                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$currentBaseId.png',
                                          height: 200,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) =>
                                              const Icon(Icons.catching_pokemon, size: 100, color: Colors.white54),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),

                              // =========================================================================
                              // NOM ET ID
                              // =========================================================================
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.catching_pokemon, color: Colors.white, size: 28, shadows: textShadows),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${widget.pokemonId.toString().padLeft(4, '0')} ${displayName.toUpperCase()}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                          shadows: textShadows,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // =========================================================================
                              // TYPES
                              // =========================================================================
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: pokemonDetails!.types.map((type) {
                                  final iconPath = typeIcons[type];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Column(
                                      children: [
                                        if (iconPath != null)
                                          Image.asset(iconPath, height: 48, width: 48)
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
                                            shadows: textShadows,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 24),

                              // =========================================================================
                              // CARROUSEL DES FORMES COSMETIQUES
                              // =========================================================================
                              if (pokemonDetails!.cosmeticSprite.length > 1) ...[
                                SizedBox(
                                  height: 120,
                                  child: ScrollConfiguration(
                                    behavior: const MaterialScrollBehavior().copyWith(
                                      dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
                                    ),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(horizontal: 40),
                                      itemCount: pokemonDetails!.cosmeticSprite.length,
                                      itemBuilder: (context, index) {
                                        final cosmetic = pokemonDetails!.cosmeticSprite[index];
                                        final cosmeticName = cosmetic.name; 
                                        debugPrint(cosmeticName);
                                        debugPrint('https://img.pokemondb.net/sprites/home/normal/$cosmeticName.png');
                                        final isSelected = (displayedCosmeticName == cosmeticName);

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() => displayedCosmeticName = cosmeticName);
                                          },
                                          child: Container(
                                            width: 100,
                                            margin: const EdgeInsets.only(right: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.2),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.1),
                                                width: isSelected ? 2.0 : 1.0,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    
                                                    child: Image.network(
                                                      'https://img.pokemondb.net/sprites/home/normal/$cosmeticName.png',
                                                      fit: BoxFit.contain,
                                                      errorBuilder: (context, error, stackTrace) {
                                                        return Image.network(
                                                          'https://img.pokemondb.net/sprites/black-white/normal/$cosmeticName.png',
                                                          fit: BoxFit.contain,
                                                          errorBuilder: (context, error, stackTrace) =>
                                                              const Icon(Icons.image_not_supported, color: Colors.white54),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
                                                  child: Text(
                                                    cosmeticName.toUpperCase(),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      shadows: textShadows,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],

                              // =========================================================================
                              // PILULES DES TRANSFORMATIONS
                              // =========================================================================
                              if (pokemonForms != null && pokemonForms!.isNotEmpty) ...[
                                Wrap(
                                  spacing: 12.0,
                                  runSpacing: 12.0,
                                  alignment: WrapAlignment.center,
                                  children: pokemonForms!.map((forme) {
                                    int formId = forme.id; 
                                    bool isSelected = (currentBaseId == formId);

                                    return GestureDetector(
                                      onTap: () {
                                        if (isSelected) {
                                          fetchPokemonDetails(widget.pokemonId);
                                        } else {
                                          fetchPokemonDetails(formId);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.25),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.3),
                                            width: isSelected ? 2.0 : 1.0,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.change_circle, color: Colors.white70, size: 18),
                                            const SizedBox(width: 8),
                                            Text(
                                              forme.name.toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                shadows: textShadows,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      // =========================================================================
                      // BARRE D'ONGLETS
                      // =========================================================================
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            indicatorColor: Colors.white,
                            indicatorWeight: 3,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white70,
                            labelStyle: TextStyle(fontWeight: FontWeight.bold, shadows: textShadows),
                            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, shadows: textShadows),
                            tabs: const [
                              Tab(text: 'SPRITES'),
                              Tab(text: 'INFOS'),
                              Tab(text: 'COMBAT'),
                            ],
                          ),
                        ),
                      ),
                    ];
                  },
                  
                  // =========================================================================
                  // CONTENU DES ONGLETS
                  // =========================================================================
                  body: TabBarView(
                    children: [
                      Center(child: Text('Onglet Sprites (À faire)', style: TextStyle(color: Colors.white, shadows: textShadows))),
                      Center(child: Text('Infos (Poids/Taille à déplacer ici)', style: TextStyle(color: Colors.white, shadows: textShadows))),
                      Center(child: Text('Stats de combat', style: TextStyle(color: Colors.white, shadows: textShadows))),
                    ],
                  ),
                ),
        ),
      ),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: overlapsContent ? Colors.black.withValues(alpha: 0.4) : Colors.transparent,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}