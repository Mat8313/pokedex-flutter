import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import '../utils/network_image.dart';
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';
import '../models/pokemon_species.dart';
import '../services/api_names.dart';
import '../models/pokemon_type.dart';
import '../widgets/detail/battle_tab.dart';
import '../widgets/detail/detail_panel.dart';
import '../widgets/detail/evolution_tab.dart';
import '../widgets/detail/info_tab.dart';
import '../settings/app_settings.dart';

import '../l10n/localized_label.dart';

import '../services/poke_api_service.dart';
import '../models/pokemon_detail.dart';
import '../models/pokemon_forms.dart';
import '../models/sprite_set.dart';
import '../utils/assets_helper.dart';
import '../widgets/network_error.dart';

final List<Shadow> _textShadows = [
  Shadow(
    offset: const Offset(1, 1),
    blurRadius: 5.0,
    color: Colors.black.withValues(alpha: 0.6),
  ),
];

const List<Color> _megaGlowColors = [
  Color(0xFFFF3B30),
  Color(0xFFFF9500),
  Color(0xFFFFCC00),
  Color(0xFF34C759),
  Color(0xFF00C7BE),
  Color(0xFF007AFF),
  Color(0xFFAF52DE),
];

const List<Color> _gigamaxGlowColors = [
  Color(0xFFFF2D55),
  Color(0xFFFF6B6B),
  Color(0xFFE0218A),
  Color(0xFFFF375F),
];

/// Libellé traduit d'un type tel que la fiche le reçoit (`FIRE`), en capitales.
String typeLabel(BuildContext context, String type) {
  final known = pokemonTypesByKey[type.toLowerCase()];
  return known == null ? type : context.label(known.label).toUpperCase();
}

class PokemonDetailPage extends StatefulWidget {
  final String pokemonName;

  /// L'espèce : elle porte les formes, les évolutions et la description.
  final int pokemonId;

  /// La forme à ouvrir d'emblée, quand on arrive depuis une vignette de forme
  /// (Tauros de Paldéa) plutôt que depuis l'espèce.
  final int? initialFormId;

  const PokemonDetailPage({
    super.key,
    required this.pokemonName,
    required this.pokemonId,
    this.initialFormId,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  PokemonDetail? pokemonDetails;
  List<PokemonForm>? pokemonForms;
  List<PokemonForm>? pokemonTransformations;
  PokemonSpecies? species;
  EvolutionNode? evolutionChain;
  String? displayedCosmeticName;
  // On mémorise la clé du jeu choisi, pas l'URL : l'image se recalcule ainsi
  // toute seule quand les bascules shiny/sexe changent.
  String? selectedGameKey;
  String? formVersionGroup;

  /// Initialisé dans [didChangeDependencies] depuis le réglage
  /// « chromatique par défaut », que l'on ne peut pas lire dans [initState].
  bool isShiny = false;
  bool _shinyInitialised = false;
  bool isFemale = false;

  /// Le premier chargement a échoué : sans fiche, rien d'autre à montrer que
  /// l'erreur et de quoi réessayer.
  bool detailsFailed = false;

  /// L'espèce n'a pas pu être chargée : description et évolutions manquent.
  bool speciesFailed = false;

  final PokeApiService apiService = PokeApiService();

  Future<void> fetchPokemonDetails(int id) async {
    try {
      final details = await apiService.fetchPokemonDetails(id);
      if (!mounted) return;
      setState(() {
        pokemonDetails = details;
        displayedCosmeticName = null;
        // Le shiny suit le Pokémon d'une forme à l'autre, le sexe non :
        // toutes les formes n'ont pas de variante femelle. Idem pour le jeu
        // choisi, une méga n'existe pas dans les jeux anciens.
        selectedGameKey = null;
        formVersionGroup = null;
        isFemale = false;
      });
      fetchFormVersionGroup(details);
    } catch (e) {
      debugPrint('ERREUR réseau: $e');
      if (!mounted) return;
      if (pokemonDetails == null) {
        setState(() => detailsFailed = true);
      } else {
        // Une fiche est déjà affichée : c'est le passage à une autre forme qui
        // a échoué. On la laisse en place et on le signale sans tout masquer.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorFormLoad)),
        );
      }
    }
  }

  /// Relance tout ce qui a pu échouer, depuis le bouton « Réessayer ».
  void retry() {
    setState(() {
      detailsFailed = false;
      speciesFailed = false;
    });
    fetchPokemonDetails(widget.initialFormId ?? widget.pokemonId);
    fetchPokemonForm(widget.pokemonId);
    fetchPokemonTransformation(widget.pokemonId);
    fetchSpeciesAndEvolutions(widget.pokemonId);
  }

  /// Date la forme affichée pour pouvoir masquer les sprites de jeux antérieurs.
  /// En cas d'échec on ne filtre rien : mieux vaut trop de sprites que pas d'onglet.
  Future<void> fetchFormVersionGroup(PokemonDetail details) async {
    if (details.cosmeticSprite.isEmpty) return;

    try {
      final versionGroup = await apiService.fetchFormVersionGroup(
        details.cosmeticSprite.first.id,
      );
      if (!mounted || pokemonDetails?.id != details.id) return;
      setState(() => formVersionGroup = versionGroup);
    } catch (e) {
      debugPrint('ERREUR réseau : $e');
    }
  }

  Future<void> fetchPokemonForm(int id) async {
    try {
      final forms = await apiService.fetchPokemonForm(id);
      if (!mounted) return;
      setState(() {
        pokemonForms = forms;
      });
    } catch (e) {
      debugPrint('ERREUR réseau : $e');
    }
  }

  Future<void> fetchPokemonTransformation(int id) async {
    try {
      final transformations = await apiService.fetchPokemonTransformation(id);
      if (!mounted) return;
      setState(() {
        pokemonTransformations = transformations;
      });
    } catch (e) {
      debugPrint('ERREUR réseau : $e');
    }
  }

  // Un second appui sur la forme déjà affichée revient au Pokémon de base.
  void showForm(int formId) {
    HapticFeedback.selectionClick();
    final isAlreadyDisplayed =
        (pokemonDetails?.id ?? widget.pokemonId) == formId;
    fetchPokemonDetails(isAlreadyDisplayed ? widget.pokemonId : formId);
  }

  // 'charizard-mega-x' -> 'X'. Sert à distinguer plusieurs formes d'une même transformation.
  String transformationSuffix(PokemonForm form) =>
      form.name.split('-').last.toUpperCase();

  static const String _spritesRoot =
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon';

  // Toutes les combinaisons variante/forme n'existent pas côté PokeAPI : les formes
  // alternatives n'ont pas de rendu femelle. D'où une liste de replis du plus précis
  // au plus générique, en lâchant le sexe avant le chromatique (plus visible).
  List<String> spriteUrlCandidates(int id) {
    final shinySegment = isShiny ? '/shiny' : '';
    return [
      if (isFemale) '$_spritesRoot/other/home$shinySegment/female/$id.png',
      '$_spritesRoot/other/home$shinySegment/$id.png',
      '$_spritesRoot/other/official-artwork$shinySegment/$id.png',
      if (isShiny) '$_spritesRoot/other/official-artwork/$id.png',
      '$_spritesRoot/$id.png',
    ];
  }

  String? get selectedGameSpriteUrl {
    if (selectedGameKey == null || pokemonDetails == null) return null;

    for (final generation in pokemonDetails!.spritesByGeneration) {
      for (final gameSprites in generation.games) {
        if (gameSprites.game.spriteKey == selectedGameKey) {
          return gameSprites.sprites.variant(shiny: isShiny, female: isFemale);
        }
      }
    }
    return null;
  }

  List<String> cosmeticUrlCandidates(String name) => [
    'https://img.pokemondb.net/sprites/home/${isShiny ? 'shiny' : 'normal'}/$name.png',
    if (isShiny) 'https://img.pokemondb.net/sprites/home/normal/$name.png',
    'https://img.pokemondb.net/sprites/black-white/normal/$name.png',
  ];

  /// L'espèce porte le lien vers la chaîne d'évolution : les deux appels sont
  /// donc enchaînés, et la fiche s'affiche sans attendre qu'ils aboutissent.
  Future<void> fetchSpeciesAndEvolutions(int speciesId) async {
    try {
      final loaded = await apiService.fetchPokemonSpecies(speciesId);
      if (!mounted) return;
      setState(() => species = loaded);

      final chainId = loaded.evolutionChainId;
      if (chainId == null) return;

      final chain = await apiService.fetchEvolutionChain(chainId);
      if (!mounted) return;
      setState(() => evolutionChain = chain);
    } catch (e) {
      debugPrint('ERREUR réseau : $e');
      if (mounted) setState(() => speciesFailed = true);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPokemonDetails(widget.initialFormId ?? widget.pokemonId);
    fetchPokemonForm(widget.pokemonId);
    fetchPokemonTransformation(widget.pokemonId);
    fetchSpeciesAndEvolutions(widget.pokemonId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Une seule fois : un changement de réglage en cours de route ne doit pas
    // écraser la bascule faite à la main sur cette fiche.
    if (_shinyInitialised) return;
    _shinyInitialised = true;
    isShiny = context.settings.shinyByDefault;
  }

  @override
  Widget build(BuildContext context) {
    final currentBaseId = pokemonDetails?.id ?? widget.pokemonId;

    final gameSpriteUrl = selectedGameSpriteUrl;
    final mainImageUrls = gameSpriteUrl != null
        ? [gameSpriteUrl, ...spriteUrlCandidates(currentBaseId)]
        : displayedCosmeticName != null
        ? cosmeticUrlCandidates(displayedCosmeticName!)
        : spriteUrlCandidates(currentBaseId);

    final rawName =
        displayedCosmeticName ?? pokemonDetails?.name ?? widget.pokemonName;
    // L'espèce de base a un nom traduit ; une forme (`raichu-alola`) passe par
    // la table des formes, qui retombe sur l'identifiant mis en forme.
    // La forme par défaut porte l'id de son espèce : c'est ce qui les distingue,
    // le nom reçu pouvant être celui d'une forme quand on vient de la grille.
    final showsSpecies = displayedCosmeticName == null
        ? currentBaseId == widget.pokemonId
        : rawName == widget.pokemonName && widget.initialFormId == null;
    final displayName = showsSpecies
        ? context.speciesName(widget.pokemonId, rawName)
        : context.formName(widget.pokemonId, rawName);

    String bgPath = 'assets/background/Fond_Type_Normal_GO.png';
    if (pokemonDetails != null && pokemonDetails!.types.isNotEmpty) {
      bgPath = typeBackgrounds[pokemonDetails!.types[0]] ?? bgPath;
    }

    // Les formes alternatives n'ont pas toutes de variante : on grise le bouton
    // plutôt que de laisser cliquer vers un sprite inexistant.
    final hasFemaleSprite = pokemonDetails?.sprites.frontFemale != null;
    final hasShinySprite = pokemonDetails?.sprites.frontShiny != null;

    final megaForms =
        pokemonTransformations
            ?.where((form) => form.name.contains('mega'))
            .toList() ??
        [];
    final gmaxForms =
        pokemonTransformations
            ?.where((form) => form.name.contains('gmax'))
            .toList() ??
        [];

    // Les trois morceaux de la fiche, assemblés plus bas selon la largeur.
    final isWide = MediaQuery.sizeOf(context).width >= 840;
    final l10n = AppLocalizations.of(context)!;

    // =========================================================================
    // EN-TÊTE : image, nom, types, formes et transformations
    // =========================================================================
    final Widget header = pokemonDetails == null
        ? const SizedBox.shrink()
        : SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 10),

                // =========================================================================
                // IMAGE PRINCIPALE
                // =========================================================================
                Hero(
                  tag: 'pokemon-${widget.pokemonId}',
                  child: _FallbackNetworkImage(
                    urls: mainImageUrls,
                    semanticLabel: displayName,
                    height: 200,
                    // Les sprites de jeu sont du pixel art : sans
                    // ça, l'agrandissement les rend flous.
                    filterQuality: gameSpriteUrl != null
                        ? FilterQuality.none
                        : FilterQuality.medium,
                    fallback: const Icon(
                      Icons.catching_pokemon,
                      size: 100,
                      color: Colors.white54,
                    ),
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
                        Icon(
                          Icons.catching_pokemon,
                          color: Colors.white,
                          size: 28,
                          shadows: _textShadows,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${widget.pokemonId.toString().padLeft(4, '0')} ${displayName.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 1.5,
                            shadows: _textShadows,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blocs de largeur fixe : les boutons restent au même
                    // endroit quel que soit le nombre ou la longueur des types.
                    SizedBox(
                      width: 32,
                      child: _MiniToggleButton(
                        icon: isFemale ? Icons.female : Icons.male,
                        activeColor: isFemale
                            ? const Color(0xFFFF6BAA)
                            : const Color(0xFF64B5F6),
                        isActive: hasFemaleSprite,
                        label: l10n.a11yFemaleSprite,
                        onTap: hasFemaleSprite
                            ? () {
                                HapticFeedback.selectionClick();
                                setState(() => isFemale = !isFemale);
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // FittedBox : un libellé long (ELECTRIC + FIGHTING) est
                    // réduit au lieu de déborder de la largeur fixe.
                    SizedBox(
                      width: 176,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: pokemonDetails!.types.map((type) {
                            final iconPath = typeIcons[type];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Column(
                                children: [
                                  if (iconPath != null)
                                    // Le libellé écrit dessous suffit aux lecteurs d'écran.
                                    Image.asset(
                                      iconPath,
                                      height: 48,
                                      width: 48,
                                      excludeFromSemantics: true,
                                    )
                                  else
                                    const SizedBox(height: 48, width: 48),
                                  const SizedBox(height: 6),
                                  Text(
                                    typeLabel(context, type),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      shadows: _textShadows,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 32,
                      child: _MiniToggleButton(
                        icon: Icons.auto_awesome,
                        activeColor: const Color(0xFFFFD54F),
                        isActive: isShiny,
                        label: l10n.a11yShinySprite,
                        onTap: hasShinySprite
                            ? () {
                                HapticFeedback.selectionClick();
                                setState(() => isShiny = !isShiny);
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // =========================================================================
                // CARROUSEL DES FORMES COSMETIQUES
                // =========================================================================
                if (pokemonDetails!.cosmeticSprite.length > 1) ...[
                  _FormCarousel(
                    cards: pokemonDetails!.cosmeticSprite.map((cosmetic) {
                      return _FormCard(
                        label: context.formName(
                          widget.pokemonId,
                          cosmetic.name,
                        ),
                        imageUrl:
                            'https://img.pokemondb.net/sprites/home/normal/${cosmetic.name}.png',
                        fallbackImageUrl:
                            'https://img.pokemondb.net/sprites/black-white/normal/${cosmetic.name}.png',
                        isSelected: displayedCosmeticName == cosmetic.name,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            displayedCosmeticName = cosmetic.name;
                            selectedGameKey = null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // =========================================================================
                // PILULES DES TRANSFORMATIONS
                // =========================================================================
                if (pokemonForms != null && pokemonForms!.isNotEmpty) ...[
                  _FormCarousel(
                    cards: pokemonForms!.map((forme) {
                      return _FormCard(
                        label: context.formName(widget.pokemonId, forme.name),
                        imageUrl:
                            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${forme.id}.png',
                        fallbackImageUrl:
                            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${forme.id}.png',
                        isSelected: currentBaseId == forme.id,
                        onTap: () => showForm(forme.id),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                // =========================================================================
                // BOUTONS MEGA / GIGAMAX
                // =========================================================================
                if (megaForms.isNotEmpty || gmaxForms.isNotEmpty) ...[
                  Wrap(
                    spacing: 24.0,
                    runSpacing: 16.0,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final mega in megaForms)
                        _TransformationButton(
                          iconPath: transformationIcons['Mega']!,
                          badge: megaForms.length > 1
                              ? transformationSuffix(mega)
                              : null,
                          label: context.formName(widget.pokemonId, mega.name),
                          glowColors: _megaGlowColors,
                          isSelected: currentBaseId == mega.id,
                          onTap: () => showForm(mega.id),
                        ),
                      for (final gmax in gmaxForms)
                        _TransformationButton(
                          iconPath: transformationIcons['Gigamax']!,
                          badge: gmaxForms.length > 1
                              ? transformationSuffix(gmax)
                              : null,
                          label: context.formName(widget.pokemonId, gmax.name),
                          glowColors: _gigamaxGlowColors,
                          isSelected: currentBaseId == gmax.id,
                          onTap: () => showForm(gmax.id),
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ],
            ),
          );

    // =========================================================================
    // BARRE D'ONGLETS
    // =========================================================================
    final tabBar = TabBar(
      indicatorColor: Colors.white,
      indicatorWeight: 3,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      labelStyle: TextStyle(fontWeight: FontWeight.bold, shadows: _textShadows),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.normal,
        shadows: _textShadows,
      ),
      tabs: [
        Tab(text: AppLocalizations.of(context)!.tabSprites),
        Tab(text: AppLocalizations.of(context)!.tabInfo),
        Tab(text: AppLocalizations.of(context)!.tabBattle),
        Tab(text: AppLocalizations.of(context)!.tabEvolutions),
      ],
    );

    // =========================================================================
    // CONTENU DES ONGLETS
    // =========================================================================
    final Widget tabViews = pokemonDetails == null
        ? const SizedBox.shrink()
        : TabBarView(
            children: [
              _SpritesTab(
                generations: spritesSinceVersionGroup(
                  pokemonDetails!.spritesByGeneration,
                  formVersionGroup,
                ),
                isShiny: isShiny,
                isFemale: isFemale,
                selectedGameKey: selectedGameKey,
                onSelect: (gameKey) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    // Un second appui revient au rendu par défaut.
                    selectedGameKey = selectedGameKey == gameKey
                        ? null
                        : gameKey;
                    displayedCosmeticName = null;
                  });
                },
              ),
              InfoTab(
                details: pokemonDetails!,
                species: species,
                speciesFailed: speciesFailed,
                onRetry: retry,
              ),
              BattleTab(details: pokemonDetails!),
              EvolutionTab(
                chain: evolutionChain,
                currentSpeciesId: widget.pokemonId,
                speciesFailed: speciesFailed,
                onRetry: retry,
                // On empile une nouvelle fiche plutôt que de recharger
                // celle-ci : le retour arrière ramène au Pokémon d'où
                // l'on vient, ce qui est le comportement attendu.
                onSelect: (speciesId, apiName) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PokemonDetailPage(
                      pokemonName: apiName,
                      pokemonId: speciesId,
                    ),
                  ),
                ),
              ),
            ],
          );

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        extendBodyBehindAppBar: true,

        // =========================================================================
        // APP BAR
        // =========================================================================
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          // Flèche propre à chaque plateforme (chevron sur iOS, flèche sur
          // Android), avec son infobulle traduite pour les lecteurs d'écran.
          leading: const BackButton(),
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
          child: detailsFailed
              ? NetworkErrorView(onImage: true, onRetry: retry)
              : pokemonDetails == null
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              // Tablette : la fiche à gauche, les onglets à droite, chacun
              // défilant de son côté. Le téléphone garde l'en-tête qui défile
              // et la barre d'onglets qui s'épingle.
              : isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: header,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: SafeArea(
                        left: false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: kToolbarHeight),
                          child: Column(
                            children: [
                              tabBar,
                              Expanded(child: tabViews),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              // Le défilement commence sous la barre d'app transparente : la
              // barre d'onglets s'épingle juste sous la flèche retour au lieu
              // de passer dessous. La marge du haut est alors consommée ici.
              : Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.paddingOf(context).top + kToolbarHeight,
                  ),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) => [
                        SliverToBoxAdapter(child: header),

                        // Sans cet absorbeur, le corps du NestedScrollView est
                        // posé par-dessus l'en-tête épinglé et intercepte ses
                        // clics : la barre d'onglets devient inerte.
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                context,
                              ),
                          sliver: SliverPersistentHeader(
                            pinned: true,
                            delegate: _SliverAppBarDelegate(tabBar),
                          ),
                        ),
                      ],
                      body: tabViews,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _SpritesTab extends StatelessWidget {
  const _SpritesTab({
    required this.generations,
    required this.isShiny,
    required this.isFemale,
    required this.selectedGameKey,
    required this.onSelect,
  });

  final List<GenerationSprites> generations;
  final bool isShiny;
  final bool isFemale;
  final String? selectedGameKey;
  final void Function(String gameKey) onSelect;

  @override
  Widget build(BuildContext context) {
    if (generations.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.noGameSprites,
          style: TextStyle(color: Colors.white70, shadows: _textShadows),
        ),
      );
    }

    return DetailTabList(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        for (final generation in generations) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              context.label(generation.generation.label).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                shadows: _textShadows,
              ),
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final gameSprites in generation.games)
                _GameSpriteTile(
                  label: context.label(gameSprites.game.label),
                  imageUrl: gameSprites.sprites.variant(
                    shiny: isShiny,
                    female: isFemale,
                  )!,
                  isSelected: selectedGameKey == gameSprites.game.spriteKey,
                  onTap: () => onSelect(gameSprites.game.spriteKey),
                ),
            ],
          ),
          const SizedBox(height: 28),
        ],
      ],
    );
  }
}

class _GameSpriteTile extends StatelessWidget {
  const _GameSpriteTile({
    required this.label,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 104,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: isSelected ? 0.4 : 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.15),
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 64,
                // Pixel art : pas de lissage, sinon l'agrandissement le rend flou.
                child: Image(
                  image: networkImage(imageUrl),
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.none,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    color: Colors.white54,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                  shadows: _textShadows,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Essaie les URL dans l'ordre : chaque échec relance le widget avec la suite de
// la liste, jusqu'au widget de repli si plus rien ne charge.
class _FallbackNetworkImage extends StatelessWidget {
  const _FallbackNetworkImage({
    required this.urls,
    required this.fallback,
    this.height,
    this.filterQuality = FilterQuality.medium,
    this.semanticLabel,
  });

  final String? semanticLabel;
  final List<String> urls;
  final Widget fallback;
  final double? height;
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return fallback;

    return Image(
      image: networkImage(urls.first),
      height: height,
      fit: BoxFit.contain,
      filterQuality: filterQuality,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) => _FallbackNetworkImage(
        urls: urls.sublist(1),
        fallback: fallback,
        height: height,
        filterQuality: filterQuality,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

class _MiniToggleButton extends StatelessWidget {
  const _MiniToggleButton({
    required this.icon,
    required this.activeColor,
    required this.isActive,
    required this.label,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color activeColor;
  final bool isActive;
  // null = variante indisponible pour cette forme : bouton visible mais grisé.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return Semantics(
      button: true,
      toggled: isActive,
      enabled: isEnabled,
      label: label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        // Aligné sur l'icône de type (48 px) : (48 - 32) / 2 = 8.
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: isActive ? 0.45 : 0.25),
              shape: BoxShape.circle,
              border: Border.all(
                color: !isEnabled
                    ? Colors.white.withValues(alpha: 0.12)
                    : isActive
                    ? activeColor
                    : Colors.white.withValues(alpha: 0.3),
                width: isActive ? 2.0 : 1.0,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              size: 18,
              color: !isEnabled
                  ? Colors.white.withValues(alpha: 0.25)
                  : isActive
                  ? activeColor
                  : Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormCarousel extends StatelessWidget {
  const _FormCarousel({required this.cards});

  final List<Widget> cards;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ScrollConfiguration(
        behavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          children: cards,
        ),
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.label,
    required this.imageUrl,
    required this.fallbackImageUrl,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String imageUrl;
  final String fallbackImageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.1),
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image(
                    image: networkImage(imageUrl),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image(
                        image: networkImage(fallbackImageUrl),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.image_not_supported,
                              color: Colors.white54,
                            ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                  left: 4.0,
                  right: 4.0,
                ),
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: _textShadows,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TransformationButton extends StatefulWidget {
  const _TransformationButton({
    required this.iconPath,
    required this.label,
    required this.badge,
    required this.glowColors,
    required this.isSelected,
    required this.onTap,
  });

  final String iconPath;

  /// Le nom de la forme (« Méga-Dracaufeu X ») : l'icône seule ne dit rien à
  /// un lecteur d'écran.
  final String label;
  final String? badge;
  final List<Color> glowColors;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_TransformationButton> createState() => _TransformationButtonState();
}

class _TransformationButtonState extends State<_TransformationButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  @override
  void initState() {
    super.initState();
    if (widget.isSelected) _controller.repeat();
  }

  // L'animation ne tourne que sur la forme active, pour ne pas repeindre inutilement.
  @override
  void didUpdateWidget(_TransformationButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isSelected && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.glowColors;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 48,
              width: 48,
              child: AnimatedBuilder(
                animation: _controller,
                // L'icône est passée en `child` : construite une seule fois,
                // elle n'est pas reconstruite à chaque image de l'animation.
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(7),
                  child: Image.asset(widget.iconPath, fit: BoxFit.contain),
                ),
                builder: (context, child) {
                  final turn = _controller.value * 2 * math.pi;

                  return Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: widget.isSelected
                          ? SweepGradient(
                              colors: [...colors, colors.first],
                              transform: GradientRotation(turn),
                            )
                          : null,
                      border: widget.isSelected
                          ? null
                          : Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                      boxShadow: widget.isSelected
                          ? [
                              for (var i = 0; i < colors.length; i++)
                                BoxShadow(
                                  color: colors[i].withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: Offset(
                                    math.cos(
                                          turn +
                                              i * 2 * math.pi / colors.length,
                                        ) *
                                        3,
                                    math.sin(
                                          turn +
                                              i * 2 * math.pi / colors.length,
                                        ) *
                                        3,
                                  ),
                                ),
                            ]
                          : null,
                    ),
                    child: child,
                  );
                },
              ),
            ),
            if (widget.badge != null)
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  height: 20,
                  width: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    widget.badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
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
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: overlapsContent
          ? Colors.black.withValues(alpha: 0.4)
          : Colors.transparent,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
