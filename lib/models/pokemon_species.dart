/// Les informations d'espèce, celles que `/pokemon` ne porte pas.
///
/// Les textes traduits sont conservés **par langue** plutôt que résolus au
/// moment de la lecture : la fiche est chargée une fois, et changer la langue
/// de l'application ne doit pas obliger à la recharger.
class PokemonSpecies {
  /// Code de langue → catégorie (« Pokémon Graine »).
  final Map<String, String> genus;

  /// Code de langue → description du Pokédex, la plus récente disponible.
  final Map<String, String> flavorText;

  /// Identifiants d'API des groupes d'œufs.
  final List<String> eggGroups;

  /// 0 à 255 ; plus c'est haut, plus l'espèce est facile à capturer.
  final int captureRate;

  /// Nombre de chances sur huit d'obtenir une femelle, `-1` pour une espèce
  /// asexuée. C'est la convention de l'API, gardée telle quelle.
  final int genderRate;

  final int? evolutionChainId;

  const PokemonSpecies({
    required this.genus,
    required this.flavorText,
    required this.eggGroups,
    required this.captureRate,
    required this.genderRate,
    required this.evolutionChainId,
  });

  /// Les langues que l'application sait afficher. Garder les autres gonflerait
  /// la mémoire pour rien : l'API en renvoie jusqu'à neuf.
  static const List<String> _languages = ['en', 'fr'];

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    final genus = <String, String>{};
    for (final entry in json['genera'] as List) {
      final language = entry['language']['name'] as String;
      if (_languages.contains(language)) genus[language] = entry['genus'] as String;
    }

    // Les entrées sont rendues de la plus ancienne à la plus récente : la
    // dernière de chaque langue est donc celle du jeu le plus récent.
    final flavorText = <String, String>{};
    for (final entry in json['flavor_text_entries'] as List) {
      final language = entry['language']['name'] as String;
      if (!_languages.contains(language)) continue;

      flavorText[language] = _clean(entry['flavor_text'] as String);
    }

    return PokemonSpecies(
      genus: genus,
      flavorText: flavorText,
      eggGroups: [for (final group in json['egg_groups'] as List) group['name'] as String],
      captureRate: json['capture_rate'] as int,
      genderRate: json['gender_rate'] as int,
      evolutionChainId: _idFromUrl(json['evolution_chain']?['url'] as String?),
    );
  }

  /// Les descriptions sont formatées pour l'écran d'une console : sauts de
  /// ligne forcés, saut de page entre les deux moitiés, espaces insécables.
  static String _clean(String text) =>
      text.replaceAll(RegExp(r'[\n\f­]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

  static int? _idFromUrl(String? url) {
    if (url == null) return null;

    return int.tryParse(url.split('/').where((part) => part.isNotEmpty).last);
  }
}

/// Un maillon d'une chaîne d'évolution.
class EvolutionNode {
  final int speciesId;
  final String name;

  /// Comment on arrive à ce maillon. Vide pour la forme de base, et parfois
  /// multiple : Évoli mis à part, une même évolution peut avoir plusieurs
  /// chemins (Cheniti par exemple).
  final List<EvolutionStep> steps;

  final List<EvolutionNode> evolvesTo;

  const EvolutionNode({
    required this.speciesId,
    required this.name,
    required this.steps,
    required this.evolvesTo,
  });

  factory EvolutionNode.fromJson(Map<String, dynamic> json) => EvolutionNode(
    speciesId: _idFromUrl(json['species']['url'] as String),
    name: json['species']['name'] as String,
    steps: [
      for (final detail in json['evolution_details'] as List) EvolutionStep.fromJson(detail),
    ],
    evolvesTo: [
      for (final child in json['evolves_to'] as List) EvolutionNode.fromJson(child),
    ],
  );

  /// La chaîne à plat, dans l'ordre d'affichage.
  List<EvolutionNode> get flattened => [
    this,
    for (final child in evolvesTo) ...child.flattened,
  ];

  static int _idFromUrl(String url) =>
      int.parse(url.split('/').where((part) => part.isNotEmpty).last);
}

/// Une condition d'évolution.
///
/// L'API en décrit une vingtaine ; seules les plus courantes sont retenues,
/// [trigger] servant de repli pour dire au moins par quel moyen l'évolution
/// se déclenche.
class EvolutionStep {
  final String trigger;
  final int? minLevel;
  final String? item;
  final String? heldItem;
  final int? minHappiness;
  final String? knownMove;
  final String? timeOfDay;

  const EvolutionStep({
    required this.trigger,
    this.minLevel,
    this.item,
    this.heldItem,
    this.minHappiness,
    this.knownMove,
    this.timeOfDay,
  });

  factory EvolutionStep.fromJson(Map<String, dynamic> json) {
    String? name(String field) => (json[field] as Map<String, dynamic>?)?['name'] as String?;
    final timeOfDay = json['time_of_day'] as String?;

    return EvolutionStep(
      trigger: name('trigger') ?? 'level-up',
      minLevel: json['min_level'] as int?,
      item: name('item'),
      heldItem: name('held_item'),
      minHappiness: json['min_happiness'] as int?,
      knownMove: name('known_move'),
      timeOfDay: (timeOfDay == null || timeOfDay.isEmpty) ? null : timeOfDay,
    );
  }
}
